# Script de Sincronización IIS Staging - DIRIS Lima Norte
# Prepara archivos para ambiente de pruebas en servidor IIS

param(
    [string]$serverPath = "C:\inetpub\wwwroot\page_ofseg_dirisln",
    [switch]$includeTesting = $true
)

Write-Host "=== SINCRONIZACIÓN IIS STAGING - DIRIS LIMA NORTE ===" -ForegroundColor Green
Write-Host "Ruta destino: $serverPath" -ForegroundColor Yellow

# Verificar directorio de trabajo
if (-not (Test-Path "package.json")) {
    Write-Error "❌ No se encontró package.json. Ejecutar desde d:\proyecto\"
    exit 1
}

try {
    # 1. Generar build para IIS
    Write-Host "1. Generando build para IIS..." -ForegroundColor Cyan
    npm run build:iis
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error en build de IIS"
        exit 1
    }

    # 2. Limpiar directorio staging anterior
    Write-Host "2. Preparando directorio staging..." -ForegroundColor Cyan
    $stagingDir = "deployment-staging"
    
    if (Test-Path $stagingDir) {
        Remove-Item $stagingDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $stagingDir | Out-Null

    # 3. Copiar archivos build
    Write-Host "3. Copiando archivos de build..." -ForegroundColor Cyan
    Copy-Item "out\*" -Destination $stagingDir -Recurse -Force

    # 4. Agregar configuraciones IIS
    Write-Host "4. Agregando configuraciones IIS..." -ForegroundColor Cyan
    Copy-Item "deployment-iis\web.config" -Destination $stagingDir -Force
    Copy-Item "deployment-iis\web.config.utf8" -Destination $stagingDir -Force
    Copy-Item "deployment-iis\configure-utf8-iis.ps1" -Destination $stagingDir -Force

    # 5. Agregar archivos de testing si está habilitado
    if ($includeTesting) {
        Write-Host "5. Agregando archivos de testing..." -ForegroundColor Cyan
        Copy-Item "deployment-iis\test-utf8.html" -Destination $stagingDir -Force
        
        # Crear archivo de información del ambiente
        $envInfo = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>🧪 Ambiente STAGING - DIRIS Lima Norte</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background: #f39c12; color: white; }
        .container { background: rgba(0,0,0,0.8); padding: 20px; border-radius: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧪 AMBIENTE DE STAGING</h1>
        <p><strong>DIRIS Lima Norte - Ambiente de Pruebas</strong></p>
        <p>📅 Generado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        <p>🔧 Versión: Staging/Testing</p>
        <p>⚠️ Este es un ambiente de pruebas</p>
        <hr>
        <p><a href="index.html" style="color: #3498db;">🏠 Ir al sitio principal</a></p>
        <p><a href="test-utf8.html" style="color: #3498db;">🧪 Prueba UTF-8</a></p>
    </div>
</body>
</html>
"@
        Set-Content -Path "$stagingDir\staging-info.html" -Value $envInfo -Encoding UTF8
    }

    # 6. Generar información del deployment
    Write-Host "6. Generando información del deployment..." -ForegroundColor Cyan
    $deploymentInfo = @"
# DEPLOYMENT STAGING - DIRIS Lima Norte

## Información del Build:
- Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- Ambiente: STAGING
- Ruta destino: $serverPath
- Archivos testing: $(if($includeTesting){'Incluidos'}else{'No incluidos'})

## Archivos incluidos:
- Build completo de Next.js
- web.config para IIS
- web.config.utf8 (UTF-8 específico)
- configure-utf8-iis.ps1 (script configuración)
$(if($includeTesting){
"- test-utf8.html (prueba caracteres)
- staging-info.html (info ambiente)"
})

## Instrucciones para el servidor:
1. Copiar todo el contenido de deployment-staging a: $serverPath
2. Ejecutar como Administrador: .\configure-utf8-iis.ps1
3. Verificar en: http://[IP-SERVIDOR]/page_ofseg_dirisln/
$(if($includeTesting){"4. Testing en: http://[IP-SERVIDOR]/page_ofseg_dirisln/staging-info.html"})

## URLs de prueba:
- Sitio principal: http://[IP-SERVIDOR]/page_ofseg_dirisln/
$(if($includeTesting){
"- Info staging: http://[IP-SERVIDOR]/page_ofseg_dirisln/staging-info.html
- Test UTF-8: http://[IP-SERVIDOR]/page_ofseg_dirisln/test-utf8.html"
})
"@

    Set-Content -Path "$stagingDir\DEPLOYMENT-INFO.md" -Value $deploymentInfo -Encoding UTF8

    # 7. Mostrar resumen
    $fileCount = (Get-ChildItem $stagingDir -Recurse).Count
    $folderSize = [math]::Round((Get-ChildItem $stagingDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

    Write-Host "`n✅ STAGING PREPARADO" -ForegroundColor Green
    Write-Host "📁 Directorio: deployment-staging\" -ForegroundColor White
    Write-Host "📊 Archivos: $fileCount" -ForegroundColor White
    Write-Host "📏 Tamaño: $folderSize MB" -ForegroundColor White
    Write-Host "🎯 Listo para copiar a: $serverPath" -ForegroundColor White

    # 8. Guardar log
    $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Staging preparado - $fileCount archivos - $folderSize MB"
    Add-Content -Path "sync\staging-sync.log" -Value $logEntry

} catch {
    Write-Error "❌ Error durante preparación de staging: $_"
    exit 1
}
