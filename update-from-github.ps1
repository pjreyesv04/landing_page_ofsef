# 🚀 Script de Actualización Automática desde GitHub
# Archivo: update-from-github.ps1
# Ubicación: C:\inetpub\wwwroot\page_ofseg_dirisln\

param(
    [string]$CommitMessage = "Actualización automática desde GitHub"
)

Write-Host "🚀 INICIANDO ACTUALIZACIÓN DESDE GITHUB" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Función para logging con timestamp
function Write-LogMessage {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch($Type) {
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$timestamp] $Type: $Message" -ForegroundColor $color
}

# Variables de configuración
$BackupDir = ".\backups\$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$GitRepo = "https://github.com/pjreyesv04/landing_page_ofsef.git"
$TempDir = ".\temp_update"

try {
    # PASO 1: Crear backup de la versión actual
    Write-LogMessage "📁 Creando backup de la versión actual..."
    if (!(Test-Path "backups")) { New-Item -ItemType Directory -Path "backups" }
    New-Item -ItemType Directory -Path $BackupDir -Force
    
    # Backup archivos críticos
    $CriticalFiles = @("index.html", "web.config", "_next", "images", "*.js", "*.css", "*.json")
    foreach ($pattern in $CriticalFiles) {
        if (Test-Path $pattern) {
            Copy-Item $pattern -Destination $BackupDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-LogMessage "✅ Backup creado en: $BackupDir" "SUCCESS"

    # PASO 2: Limpiar directorio temporal
    Write-LogMessage "🧹 Limpiando directorio temporal..."
    if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force }
    Write-LogMessage "✅ Directorio temporal limpio" "SUCCESS"

    # PASO 3: Clonar repositorio
    Write-LogMessage "📥 Descargando última versión desde GitHub..."
    git clone $GitRepo $TempDir
    if ($LASTEXITCODE -ne 0) {
        throw "Error al clonar repositorio de GitHub"
    }
    Write-LogMessage "✅ Repositorio clonado exitosamente" "SUCCESS"

    # PASO 4: Verificar configuración Next.js
    Write-LogMessage "⚙️ Configurando Next.js para IIS..."
    $NextConfigPath = "$TempDir\next.config.ts"
    $IISConfigPath = "$TempDir\next.config.iis.ts"
    
    if (Test-Path $IISConfigPath) {
        Copy-Item $IISConfigPath -Destination $NextConfigPath -Force
        Write-LogMessage "✅ Configuración IIS aplicada" "SUCCESS"
    } else {
        Write-LogMessage "⚠️ No se encontró next.config.iis.ts, usando configuración por defecto" "WARNING"
    }

    # PASO 5: Instalar dependencias y build
    Write-LogMessage "📦 Instalando dependencias de Node.js..."
    Set-Location $TempDir
    npm install --silent
    if ($LASTEXITCODE -ne 0) {
        throw "Error instalando dependencias npm"
    }
    Write-LogMessage "✅ Dependencias instaladas" "SUCCESS"

    Write-LogMessage "🔨 Construyendo aplicación Next.js..."
    npm run build --silent
    if ($LASTEXITCODE -ne 0) {
        throw "Error en el proceso de build"
    }
    Write-LogMessage "✅ Build completado exitosamente" "SUCCESS"

    # PASO 6: Verificar archivos generados
    Write-LogMessage "🔍 Verificando archivos generados..."
    $OutDir = ".\out"
    if (!(Test-Path $OutDir)) {
        throw "Directorio 'out' no fue generado. Verificar configuración de Next.js"
    }
    
    $RequiredFiles = @("index.html", "_next")
    foreach ($file in $RequiredFiles) {
        if (!(Test-Path "$OutDir\$file")) {
            throw "Archivo crítico no encontrado: $file"
        }
    }
    Write-LogMessage "✅ Archivos críticos verificados" "SUCCESS"

    # PASO 7: Regresar al directorio principal
    Set-Location ..

    # PASO 8: Respaldar web.config actual
    Write-LogMessage "💾 Respaldando configuración IIS actual..."
    if (Test-Path "web.config") {
        Copy-Item "web.config" -Destination "$BackupDir\web.config.backup" -Force
    }

    # PASO 9: Copiar archivos nuevos (excluyendo web.config si ya existe y es válido)
    Write-LogMessage "📁 Copiando archivos actualizados..."
    
    # Copiar contenido del directorio out
    $SourceOut = "$TempDir\out\*"
    Copy-Item $SourceOut -Destination "." -Recurse -Force
    
    # Copiar archivos adicionales necesarios
    $AdditionalFiles = @("package.json", "package-lock.json")
    foreach ($file in $AdditionalFiles) {
        if (Test-Path "$TempDir\$file") {
            Copy-Item "$TempDir\$file" -Destination "." -Force
        }
    }
    Write-LogMessage "✅ Archivos copiados exitosamente" "SUCCESS"

    # PASO 10: Verificar web.config
    Write-LogMessage "🔧 Verificando configuración IIS..."
    if (Test-Path "web.config") {
        try {
            [xml]$xmlContent = Get-Content "web.config" -Raw
            Write-LogMessage "✅ web.config es válido" "SUCCESS"
        } catch {
            Write-LogMessage "⚠️ web.config inválido, restaurando backup..." "WARNING"
            Copy-Item "$BackupDir\web.config.backup" -Destination "web.config" -Force
        }
    } else {
        Write-LogMessage "❌ web.config no encontrado, copiando desde backup" "ERROR"
        Copy-Item "$BackupDir\web.config.backup" -Destination "web.config" -Force
    }

    # PASO 11: Limpiar archivos temporales
    Write-LogMessage "🧹 Limpiando archivos temporales..."
    if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force }
    Write-LogMessage "✅ Limpieza completada" "SUCCESS"

    # PASO 12: Verificaciones finales
    Write-LogMessage "🔍 Ejecutando verificaciones finales..."
    
    # Verificar que index.html existe y no es una página 404
    if (Test-Path "index.html") {
        $indexContent = Get-Content "index.html" -Raw
        if ($indexContent -match "404.*page.*not.*found") {
            Write-LogMessage "⚠️ ADVERTENCIA: index.html parece ser una página 404" "WARNING"
        } else {
            Write-LogMessage "✅ index.html válido" "SUCCESS"
        }
    }
    
    # Verificar archivos CSS y JS
    $CSSFiles = Get-ChildItem "_next\static\css\*.css" -ErrorAction SilentlyContinue
    $JSFiles = Get-ChildItem "_next\static\chunks\*.js" -ErrorAction SilentlyContinue
    
    Write-LogMessage "📊 Archivos encontrados:" "INFO"
    Write-LogMessage "   - CSS: $($CSSFiles.Count) archivos" "INFO"
    Write-LogMessage "   - JS: $($JSFiles.Count) archivos" "INFO"

    # PASO 13: Crear log de deployment
    $LogFile = "deployment-log.txt"
    $LogContent = @"
=== DEPLOYMENT LOG ===
Fecha: $(Get-Date)
Commit: $CommitMessage
Backup Location: $BackupDir
Status: SUCCESS

Archivos Críticos:
- index.html: $(if (Test-Path "index.html") { "✅ OK" } else { "❌ MISSING" })
- web.config: $(if (Test-Path "web.config") { "✅ OK" } else { "❌ MISSING" })
- CSS Files: $($CSSFiles.Count)
- JS Files: $($JSFiles.Count)

Próximos pasos:
1. Verificar sitio en Chrome: http://localhost/page_ofseg_dirisln/
2. Verificar sitio en Firefox: http://localhost/page_ofseg_dirisln/
3. Ejecutar diagnóstico: http://localhost/page_ofseg_dirisln/browser-test.html
"@
    $LogContent | Out-File -FilePath $LogFile -Encoding UTF8 -Force

    Write-Host "" -ForegroundColor Green
    Write-Host "🎉 ACTUALIZACIÓN COMPLETADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Green
    Write-LogMessage "📋 Log guardado en: $LogFile" "SUCCESS"
    Write-LogMessage "💾 Backup disponible en: $BackupDir" "INFO"
    Write-LogMessage "🌐 Verificar sitio en: http://localhost/page_ofseg_dirisln/" "INFO"

} catch {
    Write-LogMessage "❌ ERROR DURANTE LA ACTUALIZACIÓN: $($_.Exception.Message)" "ERROR"
    
    # Restaurar desde backup en caso de error
    if (Test-Path $BackupDir) {
        Write-LogMessage "🔄 Restaurando desde backup..." "WARNING"
        Copy-Item "$BackupDir\*" -Destination "." -Recurse -Force
        Write-LogMessage "✅ Restauración completada" "SUCCESS"
    }
    
    # Limpiar archivos temporales
    if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force }
    
    Write-Host "❌ ACTUALIZACIÓN FALLÓ. Sistema restaurado al estado anterior." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Proceso completado. Revisar log para detalles." -ForegroundColor Green
