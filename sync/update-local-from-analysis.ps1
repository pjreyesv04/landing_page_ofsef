# Script de Actualización Local - Desde Análisis IIS
# Ayuda a actualizar el código fuente local basado en cambios del servidor IIS

param(
    [string]$analysisFile = "",
    [string]$tempDir = "temp-iis-download",
    [switch]$interactive = $true
)

Write-Host "🔄 ACTUALIZACIÓN LOCAL DESDE ANÁLISIS IIS" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta

# Verificar directorio de trabajo
if (-not (Test-Path "package.json")) {
    Write-Error "❌ Ejecutar desde d:\proyecto\"
    exit 1
}

# Verificar que existe el directorio temporal con archivos IIS
if (-not (Test-Path $tempDir)) {
    Write-Error "❌ No se encontró $tempDir. Ejecutar sync-from-iis.ps1 primero"
    exit 1
}

try {
    Write-Host "`n1. Analizando archivos del servidor IIS..." -ForegroundColor Cyan
    
    $iisFiles = Get-ChildItem $tempDir -Recurse
    Write-Host "   📊 Total archivos IIS: $($iisFiles.Count)" -ForegroundColor White

    # 2. Buscar archivos que podrían indicar cambios en contenido
    Write-Host "`n2. Identificando posibles cambios de contenido..." -ForegroundColor Cyan
    
    # Buscar en index.html cambios de texto/contenido
    $indexFile = Join-Path $tempDir "index.html"
    if (Test-Path $indexFile) {
        Write-Host "   📄 Analizando index.html..." -ForegroundColor White
        
        $indexContent = Get-Content $indexFile -Raw
        
        # Buscar texto específico que podría haber cambiado
        $textPatterns = @(
            "DIRIS",
            "Lima Norte", 
            "Dirección Regional",
            "Salud",
            "Contacto",
            "Servicios"
        )
        
        Write-Host "   🔍 Contenido encontrado en IIS:" -ForegroundColor Yellow
        foreach ($pattern in $textPatterns) {
            if ($indexContent -match $pattern) {
                Write-Host "     ✅ Contiene: $pattern" -ForegroundColor Green
            }
        }
    }

    # 3. Comparar imágenes
    Write-Host "`n3. Verificando imágenes..." -ForegroundColor Cyan
    
    $iisImagesDir = Join-Path $tempDir "images"
    if (Test-Path $iisImagesDir) {
        $iisImages = Get-ChildItem $iisImagesDir -Recurse -File
        $localImages = Get-ChildItem "public\images" -Recurse -File -ErrorAction SilentlyContinue
        
        Write-Host "   🖼️ Imágenes en IIS: $($iisImages.Count)" -ForegroundColor White
        Write-Host "   🖼️ Imágenes locales: $($localImages.Count)" -ForegroundColor White
        
        # Buscar imágenes nuevas o diferentes
        $newImages = @()
        foreach ($iisImg in $iisImages) {
            $relativePath = $iisImg.FullName.Replace("$tempDir\images\", "")
            $localPath = "public\images\$relativePath"
            
            if (-not (Test-Path $localPath)) {
                $newImages += $relativePath
            }
        }
        
        if ($newImages.Count -gt 0) {
            Write-Host "   ⚠️ Imágenes nuevas en IIS:" -ForegroundColor Yellow
            foreach ($img in $newImages) {
                Write-Host "     + $img" -ForegroundColor Yellow
            }
        }
    }

    # 4. Analizar configuración web.config
    Write-Host "`n4. Verificando configuración..." -ForegroundColor Cyan
    
    $iisWebConfig = Join-Path $tempDir "web.config"
    if (Test-Path $iisWebConfig) {
        $localWebConfig = "deployment-iis\web.config"
        
        if (Test-Path $localWebConfig) {
            $iisConfigContent = Get-Content $iisWebConfig -Raw
            $localConfigContent = Get-Content $localWebConfig -Raw
            
            if ($iisConfigContent -ne $localConfigContent) {
                Write-Host "   ⚠️ web.config ha cambiado en el servidor" -ForegroundColor Yellow
            } else {
                Write-Host "   ✅ web.config sin cambios" -ForegroundColor Green
            }
        }
    }

    # 5. Generar plan de actualización
    Write-Host "`n5. Generando plan de actualización..." -ForegroundColor Cyan
    
    $updatePlan = @"
# PLAN DE ACTUALIZACIÓN LOCAL - Desde IIS
Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## ARCHIVOS ANALIZADOS:
* Directorio IIS: $tempDir
* Total archivos: $($iisFiles.Count)

## ACCIONES RECOMENDADAS:

### 1. REVISIÓN MANUAL REQUERIDA:
* Comparar contenido de texto en index.html del IIS vs componentes React
* Verificar si hay cambios en información de contacto  
* Revisar si se modificaron servicios o descripciones
* Comprobar cambios en imágenes o recursos

### 2. ARCHIVOS A REVISAR:
* $tempDir\index.html (contiene el HTML compilado)
* $tempDir\images\ (verificar imágenes nuevas o modificadas)
* $tempDir\web.config (configuración del servidor)

### 3. COMPONENTES LOCALES A ACTUALIZAR POSIBLEMENTE:
* src/components/landing/contact.tsx (información de contacto)
* src/components/landing/about.tsx (información institucional)
* src/components/landing/services.tsx (servicios ofrecidos)
* src/components/landing/hero.tsx (texto principal)
* public/images/ (imágenes nuevas o modificadas)

### 4. PASOS DESPUÉS DE ACTUALIZAR:
* Ejecutar npm run dev para probar localmente
* Ejecutar sync-to-github.ps1 para subir a GitHub  
* Ejecutar sync-to-staging.ps1 para generar staging
* Probar en staging antes de actualizar producción

## NOTAS IMPORTANTES:
* Los archivos del IIS están compilados/optimizados
* Los cambios reales están en el código fuente React (src/)
* Es necesario identificar QUÉ cambió para actualizarlo en el código fuente
"@

    $planFile = "PLAN-ACTUALIZACION-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    Set-Content -Path $planFile -Value $updatePlan -Encoding UTF8

    # 6. Modo interactivo para ayudar con la actualización
    if ($interactive) {
        Write-Host "`n6. 🤝 ASISTENCIA INTERACTIVA" -ForegroundColor Cyan
        Write-Host "   =========================" -ForegroundColor Cyan
        
        $openIndex = Read-Host "¿Quieres abrir el index.html del IIS para revisarlo? (s/n)"
        if ($openIndex -eq "s" -or $openIndex -eq "S") {
            if (Test-Path $indexFile) {
                Start-Process $indexFile
                Write-Host "   📄 Archivo abierto en navegador" -ForegroundColor Green
            }
        }
        
        $openFolder = Read-Host "¿Quieres abrir la carpeta de archivos IIS descargados? (s/n)"
        if ($openFolder -eq "s" -or $openFolder -eq "S") {
            Start-Process (Resolve-Path $tempDir).Path
            Write-Host "   📁 Carpeta abierta en explorador" -ForegroundColor Green
        }
        
        Write-Host "`n💡 SUGERENCIAS PARA IDENTIFICAR CAMBIOS:" -ForegroundColor Yellow
        Write-Host "1. Abre el index.html del IIS en un navegador" -ForegroundColor White
        Write-Host "2. Abre tu sitio local: npm run dev" -ForegroundColor White
        Write-Host "3. Compara visualmente ambos sitios" -ForegroundColor White
        Write-Host "4. Identifica qué textos, imágenes o secciones cambiaron" -ForegroundColor White
        Write-Host "5. Actualiza los componentes correspondientes en src/" -ForegroundColor White
    }

    # 7. Crear script de ejemplo para actualización común
    Write-Host "`n7. Creando script de ejemplo..." -ForegroundColor Cyan
    
    $exampleScript = @"
# Ejemplo de actualización de componentes
# Ejecutar después de identificar cambios

# Si cambió información de contacto:
# Editar: src/components/landing/contact.tsx

# Si cambió información institucional:
# Editar: src/components/landing/about.tsx

# Si cambiaron servicios:
# Editar: src/components/landing/services.tsx

# Si cambió el texto principal:
# Editar: src/components/landing/hero.tsx

# Después de hacer cambios:
npm run dev  # Probar localmente
.\sync\sync-to-github.ps1 -message "Sincronización desde servidor IIS"
.\sync\sync-to-staging.ps1
"@

    Set-Content -Path "ejemplo-actualizacion.ps1" -Value $exampleScript -Encoding UTF8

    Write-Host "`n✅ ANÁLISIS Y PLAN COMPLETADOS" -ForegroundColor Green
    Write-Host "📄 Plan generado: $planFile" -ForegroundColor White
    Write-Host "📝 Script ejemplo: ejemplo-actualizacion.ps1" -ForegroundColor White
    
    Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Cyan
    Write-Host "1. Revisar $planFile" -ForegroundColor White
    Write-Host "2. Comparar visualmente IIS vs local" -ForegroundColor White
    Write-Host "3. Actualizar componentes en src/ según cambios identificados" -ForegroundColor White
    Write-Host "4. Ejecutar: npm run dev para probar" -ForegroundColor White
    Write-Host "5. Resincronizar: .\sync\sync-to-github.ps1" -ForegroundColor White

} catch {
    Write-Error "❌ Error durante actualización: $_"
    exit 1
}
