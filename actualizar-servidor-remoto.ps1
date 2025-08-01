# SCRIPT PARA SERVIDOR REMOTO - ACTUALIZAR IIS
# Ejecutar como Administrador en PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    ACTUALIZAR IIS EN SERVIDOR REMOTO" -ForegroundColor Cyan
Write-Host "    (Actualización para corregir imágenes)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configurar variables
$ProjectPath = "C:\proyecto"  # CAMBIAR por la ruta real de tu proyecto
$IISPath = "C:\inetpub\wwwroot\diris-lima-norte"

Write-Host "[1/7] Verificando ubicación del proyecto..." -ForegroundColor Yellow
if (!(Test-Path $ProjectPath)) {
    Write-Host "ERROR: No se encuentra el proyecto en $ProjectPath" -ForegroundColor Red
    Write-Host "Modifica la variable ProjectPath en el script" -ForegroundColor Red
    pause
    exit
}
Set-Location $ProjectPath
Write-Host "✓ Proyecto encontrado en: $ProjectPath" -ForegroundColor Green

Write-Host ""
Write-Host "[2/7] Limpiando build anterior..." -ForegroundColor Yellow
if (Test-Path "out") {
    Remove-Item -Path "out" -Recurse -Force
    Write-Host "✓ Build anterior eliminado" -ForegroundColor Green
} else {
    Write-Host "✓ No hay build anterior" -ForegroundColor Green
}

Write-Host ""
Write-Host "[3/8] Generando nuevo build para IIS..." -ForegroundColor Yellow
# Usar configuración específica para IIS
Copy-Item -Path "next.config.iis.ts" -Destination "next.config.ts" -Force
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Fallo en npm run build" -ForegroundColor Red
    pause
    exit
}
Write-Host "✓ Build para IIS generado exitosamente" -ForegroundColor Green

Write-Host ""
Write-Host "[4/7] Copiando web.config..." -ForegroundColor Yellow
if (Test-Path "web.config.subcarpeta") {
    Copy-Item -Path "web.config.subcarpeta" -Destination "out\web.config" -Force
    Write-Host "✓ web.config.subcarpeta copiado" -ForegroundColor Green
} elseif (Test-Path "web.config.minimal") {
    Copy-Item -Path "web.config.minimal" -Destination "out\web.config" -Force
    Write-Host "✓ web.config.minimal copiado" -ForegroundColor Green
} elseif (Test-Path "web.config") {
    Copy-Item -Path "web.config" -Destination "out\web.config" -Force
    Write-Host "✓ web.config original copiado" -ForegroundColor Green
} else {
    Write-Host "WARNING: No se encontró web.config" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/7] Creando carpeta IIS si no existe..." -ForegroundColor Yellow
if (!(Test-Path $IISPath)) {
    New-Item -Path $IISPath -ItemType Directory -Force | Out-Null
    Write-Host "✓ Carpeta IIS creada: $IISPath" -ForegroundColor Green
} else {
    Write-Host "✓ Carpeta IIS ya existe: $IISPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "[6/8] Actualizando archivos en IIS..." -ForegroundColor Yellow
try {
    # Limpiar archivos antiguos
    Remove-Item -Path "$IISPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Copiar nuevos archivos
    Copy-Item -Path "out\*" -Destination $IISPath -Recurse -Force
    Write-Host "✓ Archivos actualizados en IIS" -ForegroundColor Green
} catch {
    Write-Host "ERROR: No se pudieron copiar archivos a IIS" -ForegroundColor Red
    Write-Host "Verifica permisos de administrador" -ForegroundColor Red
    pause
    exit
}

Write-Host ""
Write-Host "[7/8] Verificando archivos de imágenes..." -ForegroundColor Yellow
if (Test-Path "$IISPath\images") {
    $imageCount = (Get-ChildItem -Path "$IISPath\images" -Recurse -File).Count
    Write-Host "✓ Carpeta images copiada con $imageCount archivos" -ForegroundColor Green
} else {
    Write-Host "⚠ WARNING: Carpeta images no encontrada" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[8/8] Reiniciando Application Pool..." -ForegroundColor Yellow
try {
    Import-Module WebAdministration -ErrorAction SilentlyContinue
    Restart-WebAppPool -Name "DefaultAppPool" -ErrorAction SilentlyContinue
    Write-Host "✓ Application Pool reiniciado" -ForegroundColor Green
} catch {
    Write-Host "WARNING: No se pudo reiniciar Application Pool automáticamente" -ForegroundColor Yellow
    Write-Host "Reinicia manualmente en IIS Manager" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "    ¡ACTUALIZACIÓN COMPLETADA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Prueba tu página en:" -ForegroundColor Cyan
Write-Host "   http://localhost/diris-lima-norte" -ForegroundColor White
Write-Host ""
Write-Host "📁 Archivos actualizados en:" -ForegroundColor Gray
Write-Host "   $IISPath" -ForegroundColor White
Write-Host ""

$openBrowser = Read-Host "¿Abrir en navegador? (S/N)"
if ($openBrowser -eq "S" -or $openBrowser -eq "s") {
    Start-Process "http://localhost/diris-lima-norte"
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
