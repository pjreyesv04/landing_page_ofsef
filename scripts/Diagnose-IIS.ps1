# Script de Diagnóstico y Reparación IIS
# Ejecutar como Administrador

Write-Host "=== DIAGNÓSTICO COMPLETO IIS ===" -ForegroundColor Yellow

# 1. Verificar servicios IIS
Write-Host "`n1. Estado de servicios IIS:" -ForegroundColor Cyan
Get-Service -Name W3SVC,WAS | Select-Object Name,Status

# 2. Verificar Application Pools
Write-Host "`n2. Application Pools:" -ForegroundColor Cyan
try {
    Import-Module WebAdministration -ErrorAction Stop
    Get-IISAppPool | Select-Object Name,State
} catch {
    Write-Host "Error al cargar WebAdministration: $_" -ForegroundColor Red
}

# 3. Verificar sitios web
Write-Host "`n3. Sitios web configurados:" -ForegroundColor Cyan
try {
    Get-IISSite | Select-Object Name,State,Bindings
} catch {
    Write-Host "Error al obtener sitios: $_" -ForegroundColor Red
}

# 4. Verificar puerto 80
Write-Host "`n4. Puertos en uso:" -ForegroundColor Cyan
netstat -an | findstr ":80"

# 5. Probar archivo básico
Write-Host "`n5. Creando archivo de prueba..." -ForegroundColor Cyan
$testContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Test IIS</title>
</head>
<body>
    <h1>IIS Test Page</h1>
    <p>Si puedes ver esto, IIS está funcionando</p>
    <p>Hora: $(Get-Date)</p>
</body>
</html>
"@

$testPath = "C:\inetpub\wwwroot\test-iis.html"
Set-Content -Path $testPath -Value $testContent -Encoding UTF8
Write-Host "Archivo creado en: $testPath" -ForegroundColor Green

# 6. Verificar permisos
Write-Host "`n6. Permisos del directorio raíz:" -ForegroundColor Cyan
Get-Acl "C:\inetpub\wwwroot" | Select-Object Owner,Group

# 7. Intentar acceso HTTP
Write-Host "`n7. Probando acceso HTTP..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost/test-iis.html" -UseBasicParsing
    Write-Host "✓ HTTP Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "✓ Content Length: $($response.Content.Length)" -ForegroundColor Green
} catch {
    Write-Host "✗ Error HTTP: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "✗ Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# 8. Verificar logs de eventos
Write-Host "`n8. Últimos errores de IIS en Event Log:" -ForegroundColor Cyan
try {
    Get-EventLog -LogName System -Source "Microsoft-Windows-IIS*" -Newest 5 -ErrorAction SilentlyContinue | 
    Select-Object TimeGenerated,EntryType,Message | Format-Table -Wrap
} catch {
    Write-Host "No se pudieron obtener logs de eventos" -ForegroundColor Yellow
}

Write-Host "`n=== FIN DIAGNÓSTICO ===" -ForegroundColor Yellow
Write-Host "Si hay errores HTTP 500.19, ejecutar: Fix-IISConfiguration.ps1" -ForegroundColor Cyan
