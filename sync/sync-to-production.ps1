# Script de Sincronización IIS Producción - DIRIS Lima Norte
# Prepara archivos para ambiente de producción en servidor IIS

param(
    [string]$serverPath = "C:\inetpub\wwwroot\page_ofseg_dirisln",
    [switch]$fromStaging = $false,
    [switch]$confirm = $true
)

Write-Host "=== SINCRONIZACIÓN IIS PRODUCCIÓN - DIRIS LIMA NORTE ===" -ForegroundColor Green
Write-Host "Ruta destino: $serverPath" -ForegroundColor Yellow

# Verificar directorio de trabajo
if (-not (Test-Path "package.json")) {
    Write-Error "❌ No se encontró package.json. Ejecutar desde d:\proyecto\"
    exit 1
}

# Confirmación de seguridad para producción
if ($confirm) {
    Write-Host "⚠️  ATENCIÓN: Estás preparando archivos para PRODUCCIÓN" -ForegroundColor Red
    Write-Host "🌐 Esto afectará el sitio web público de DIRIS Lima Norte" -ForegroundColor Red
    $confirmProd = Read-Host "¿Estás seguro de continuar? Escribe 'PRODUCCION' para confirmar"
    
    if ($confirmProd -ne "PRODUCCION") {
        Write-Host "❌ Operación cancelada por seguridad" -ForegroundColor Red
        exit 0
    }
}

try {
    $sourceDir = ""
    
    if ($fromStaging) {
        # Usar archivos de staging ya preparados
        Write-Host "1. Usando archivos de STAGING como base..." -ForegroundColor Cyan
        $sourceDir = "deployment-staging"
        
        if (-not (Test-Path $sourceDir)) {
            Write-Error "❌ No se encontró directorio de staging. Ejecutar sync-to-staging.ps1 primero"
            exit 1
        }
    } else {
        # Generar build nuevo para producción
        Write-Host "1. Generando build para PRODUCCIÓN..." -ForegroundColor Cyan
        npm run build:iis
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Error en build de IIS"
            exit 1
        }
        $sourceDir = "out"
    }

    # 2. Preparar directorio de producción
    Write-Host "2. Preparando directorio de producción..." -ForegroundColor Cyan
    $prodDir = "deployment-production"
    
    if (Test-Path $prodDir) {
        Remove-Item $prodDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $prodDir | Out-Null

    # 3. Copiar archivos principales
    Write-Host "3. Copiando archivos principales..." -ForegroundColor Cyan
    if ($fromStaging) {
        # Copiar desde staging excluyendo archivos de testing
        Get-ChildItem $sourceDir | Where-Object { 
            $_.Name -notlike "*test*" -and 
            $_.Name -notlike "*staging*" -and 
            $_.Name -ne "DEPLOYMENT-INFO.md"
        } | Copy-Item -Destination $prodDir -Recurse -Force
    } else {
        Copy-Item "$sourceDir\*" -Destination $prodDir -Recurse -Force
    }

    # 4. Agregar configuraciones IIS optimizadas para producción
    Write-Host "4. Agregando configuraciones IIS para producción..." -ForegroundColor Cyan
    
    # Usar configuración UTF-8 como principal para producción
    Copy-Item "deployment-iis\web.config.utf8" -Destination "$prodDir\web.config" -Force
    Copy-Item "deployment-iis\configure-utf8-iis.ps1" -Destination $prodDir -Force

    # 5. Crear archivo de información de producción
    Write-Host "5. Generando información de producción..." -ForegroundColor Cyan
    $prodInfo = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>🌐 PRODUCCIÓN - DIRIS Lima Norte</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #27ae60; color: white; }
        .container { background: rgba(0,0,0,0.8); padding: 20px; border-radius: 10px; }
        .warning { background: #e74c3c; padding: 10px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 AMBIENTE DE PRODUCCIÓN</h1>
        <p><strong>DIRIS Lima Norte - Sitio Web Oficial</strong></p>
        <p>📅 Último deployment: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        <p>🔒 Versión: Producción</p>
        
        <div class="warning">
            <h3>⚠️ IMPORTANTE</h3>
            <p>Este archivo debe ser eliminado en producción por seguridad</p>
            <p>Solo para verificación del deployment</p>
        </div>
        
        <hr>
        <p><a href="index.html" style="color: #3498db;">🏠 Ir al sitio principal</a></p>
        <p><small>Eliminar este archivo después de verificar el deployment</small></p>
    </div>
</body>
</html>
"@
    Set-Content -Path "$prodDir\production-info.html" -Value $prodInfo -Encoding UTF8

    # 6. Generar documentación del deployment
    Write-Host "6. Generando documentación..." -ForegroundColor Cyan
    $deploymentDoc = @"
# DEPLOYMENT PRODUCCIÓN - DIRIS Lima Norte

## ⚠️ INFORMACIÓN CRÍTICA:
- Ambiente: PRODUCCIÓN
- Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- Origen: $(if($fromStaging){'Staging'}else{'Build directo'})
- Ruta destino: $serverPath

## 📋 Checklist Pre-Deployment:
- [ ] Build completado sin errores
- [ ] Configuración UTF-8 incluida
- [ ] Archivos de testing removidos
- [ ] Backup del sitio actual realizado

## 📁 Contenido del Package:
- Sitio web estático completo
- web.config optimizado para UTF-8
- configure-utf8-iis.ps1 (script configuración)
- production-info.html (ELIMINAR después del deployment)

## 🚀 Instrucciones de Deployment:

### 1. Pre-Deployment:
- Realizar backup del sitio actual
- Informar a usuarios sobre mantenimiento (si aplicable)
- Verificar conectividad al servidor

### 2. Deployment:
1. Copiar contenido de deployment-production a: $serverPath
2. Ejecutar como Administrador: .\configure-utf8-iis.ps1
3. Eliminar production-info.html por seguridad
4. Ejecutar: iisreset

### 3. Post-Deployment:
1. Verificar sitio: http://[IP-SERVIDOR]/page_ofseg_dirisln/
2. Probar navegación y funcionalidades
3. Verificar tildes y caracteres especiales
4. Confirmar que imágenes cargan correctamente
5. Notificar deployment completado

## 🔍 URLs de Verificación:
- Sitio principal: http://[IP-SERVIDOR]/page_ofseg_dirisln/
- Imágenes: http://[IP-SERVIDOR]/page_ofseg_dirisln/images/backgrounds/family-hero.jpg
- CSS: http://[IP-SERVIDOR]/page_ofseg_dirisln/_next/static/css/[archivo].css

## 📞 Contacto en caso de problemas:
- Revisar logs de IIS
- Verificar configuración web.config
- Ejecutar script UTF-8 nuevamente si hay problemas con caracteres

---
**⚠️ RECORDATORIO: Eliminar production-info.html después del deployment**
"@

    Set-Content -Path "$prodDir\DEPLOYMENT-PRODUCTION.md" -Value $deploymentDoc -Encoding UTF8

    # 7. Mostrar resumen final
    $fileCount = (Get-ChildItem $prodDir -Recurse).Count
    $folderSize = [math]::Round((Get-ChildItem $prodDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

    Write-Host "`n🌐 PRODUCCIÓN PREPARADA" -ForegroundColor Green
    Write-Host "📁 Directorio: deployment-production\" -ForegroundColor White
    Write-Host "📊 Archivos: $fileCount" -ForegroundColor White
    Write-Host "📏 Tamaño: $folderSize MB" -ForegroundColor White
    Write-Host "🎯 Listo para deployment en: $serverPath" -ForegroundColor White
    
    Write-Host "`n⚠️  RECORDATORIOS IMPORTANTES:" -ForegroundColor Yellow
    Write-Host "1. Realizar backup antes del deployment" -ForegroundColor White
    Write-Host "2. Eliminar production-info.html después del deployment" -ForegroundColor White
    Write-Host "3. Ejecutar script UTF-8 en el servidor" -ForegroundColor White

    # 8. Guardar log
    $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Producción preparada - $fileCount archivos - $folderSize MB - Origen: $(if($fromStaging){'Staging'}else{'Build directo'})"
    Add-Content -Path "sync\production-sync.log" -Value $logEntry

} catch {
    Write-Error "❌ Error durante preparación de producción: $_"
    exit 1
}
