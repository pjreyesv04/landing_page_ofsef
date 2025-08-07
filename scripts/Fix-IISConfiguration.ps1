# Script de Reparación IIS para HTTP 500.19
# Ejecutar como Administrador

Write-Host "=== REPARACIÓN IIS HTTP 500.19 ===" -ForegroundColor Yellow

# 1. Detener IIS
Write-Host "`n1. Deteniendo IIS..." -ForegroundColor Cyan
iisreset /stop
Start-Sleep -Seconds 3

# 2. Limpiar configuraciones corruptas
Write-Host "`n2. Limpiando configuraciones..." -ForegroundColor Cyan

# Eliminar web.config del directorio raíz
$webConfigPath = "C:\inetpub\wwwroot\web.config"
if (Test-Path $webConfigPath) {
    Remove-Item $webConfigPath -Force
    Write-Host "✓ Eliminado web.config corrupto" -ForegroundColor Green
}

# Limpiar archivos temporales de IIS
$tempPaths = @(
    "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files\*",
    "C:\Windows\Microsoft.NET\Framework\v4.0.30319\Temporary ASP.NET Files\*"
)

foreach ($path in $tempPaths) {
    if (Test-Path (Split-Path $path)) {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Limpiados archivos temporales: $path" -ForegroundColor Green
    }
}

# 3. Resetear Application Pool
Write-Host "`n3. Reseteando Application Pool..." -ForegroundColor Cyan
try {
    Import-Module WebAdministration
    Restart-WebAppPool -Name "DefaultAppPool"
    Write-Host "✓ DefaultAppPool reiniciado" -ForegroundColor Green
} catch {
    Write-Host "✗ Error al reiniciar AppPool: $_" -ForegroundColor Red
}

# 4. Verificar y reparar permisos
Write-Host "`n4. Reparando permisos..." -ForegroundColor Cyan
$wwwroot = "C:\inetpub\wwwroot"

# Dar permisos a IIS_IUSRS
icacls $wwwroot /grant "IIS_IUSRS:(OI)(CI)F" /T
icacls $wwwroot /grant "IUSR:(OI)(CI)R" /T
Write-Host "✓ Permisos de IIS_IUSRS y IUSR aplicados" -ForegroundColor Green

# 5. Crear web.config básico y funcional
Write-Host "`n5. Creando web.config básico..." -ForegroundColor Cyan
$basicWebConfig = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <defaultDocument>
            <files>
                <clear />
                <add value="index.html" />
                <add value="index.htm" />
                <add value="default.html" />
            </files>
        </defaultDocument>
        <staticContent>
            <mimeMap fileExtension=".json" mimeType="application/json" />
            <mimeMap fileExtension=".woff" mimeType="application/font-woff" />
            <mimeMap fileExtension=".woff2" mimeType="application/font-woff2" />
        </staticContent>
        <httpErrors existingResponse="PassThrough" />
    </system.webServer>
</configuration>
"@

Set-Content -Path $webConfigPath -Value $basicWebConfig -Encoding UTF8
Write-Host "✓ web.config básico creado" -ForegroundColor Green

# 6. Reiniciar IIS
Write-Host "`n6. Reiniciando IIS..." -ForegroundColor Cyan
iisreset /start
Start-Sleep -Seconds 5

# 7. Probar funcionamiento
Write-Host "`n7. Probando funcionamiento..." -ForegroundColor Cyan

# Crear archivo de prueba
$testContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Test Reparación IIS</title>
</head>
<body>
    <h1>✅ IIS Reparado Exitosamente</h1>
    <p>Si puedes ver esta página, la reparación fue exitosa.</p>
    <p>Hora: $(Get-Date)</p>
    <p><strong>Siguiente paso:</strong> Ahora puedes acceder a tu sitio en <a href="/">http://localhost/</a></p>
</body>
</html>
"@

$testPath = "C:\inetpub\wwwroot\test-repair.html"
Set-Content -Path $testPath -Value $testContent -Encoding UTF8

# Probar acceso
try {
    Start-Sleep -Seconds 2
    $response = Invoke-WebRequest -Uri "http://localhost/test-repair.html" -UseBasicParsing
    Write-Host "✅ ÉXITO: HTTP Status $($response.StatusCode)" -ForegroundColor Green
    Write-Host "✅ IIS funcionando correctamente" -ForegroundColor Green
    Write-Host "`nPuedes acceder a:" -ForegroundColor Cyan
    Write-Host "- http://localhost/test-repair.html (página de prueba)" -ForegroundColor White
    Write-Host "- http://localhost/ (tu sitio principal)" -ForegroundColor White
} catch {
    Write-Host "❌ Error persistente: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Código de estado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

Write-Host "`n=== FIN REPARACIÓN ===" -ForegroundColor Yellow
