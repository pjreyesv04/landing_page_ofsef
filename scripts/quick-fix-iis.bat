@echo off
echo ================================================
echo     REPARACION RAPIDA IIS - HTTP 500.19
echo ================================================
echo.

echo 1. Deteniendo IIS...
iisreset /stop
timeout 3 >nul

echo 2. Eliminando configuraciones corruptas...
del "C:\inetpub\wwwroot\web.config" /f /q 2>nul
del "C:\inetpub\wwwroot\*.config" /f /q 2>nul

echo 3. Reiniciando IIS...
iisreset /start
timeout 5 >nul

echo 4. Creando archivo de prueba...
echo ^<!DOCTYPE html^>^<html^>^<head^>^<title^>Test IIS^</title^>^</head^>^<body^>^<h1^>IIS Funcionando^</h1^>^<p^>Si ves esto, IIS esta funcionando correctamente^</p^>^</body^>^</html^> > "C:\inetpub\wwwroot\test-repair.html"

echo 5. Verificando servicios...
sc query w3svc | findstr STATE

echo.
echo ================================================
echo   PRUEBA MANUAL: http://localhost/test-repair.html
echo ================================================
echo.
echo Si aun hay errores 500.19, ejecutar como Administrador:
echo   powershell -ExecutionPolicy Bypass -File Fix-IISConfiguration.ps1
echo.
pause
