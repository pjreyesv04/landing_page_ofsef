@echo off
echo ========================================
echo    ACTUALIZAR DEPLOYMENT CON BASEPATH
echo    Configuracion para /diris-lima-norte
echo ========================================
echo.

echo [1/6] Limpiando build anterior...
if exist "out" (
    rmdir /s /q "out"
    echo   ✓ Build anterior eliminado
)

echo.
echo [2/6] Generando nuevo build con basePath...
call npm run build
if errorlevel 1 (
    echo [ERROR] Error en build
    pause
    exit /b 1
)
echo   ✓ Build generado con basePath

echo.
echo [3/6] Copiando web.config optimizado...
copy "web.config.subcarpeta" "out\web.config" >nul
if errorlevel 1 (
    echo [ERROR] Error copiando web.config
    pause
    exit /b 1
)
echo   ✓ web.config copiado

echo.
echo [4/6] Eliminando archivos antiguos de IIS...
del /q "C:\inetpub\wwwroot\diris-lima-norte\*.*" >nul 2>&1
for /d %%x in ("C:\inetpub\wwwroot\diris-lima-norte\*") do rmdir /s /q "%%x" >nul 2>&1
echo   ✓ Archivos antiguos eliminados

echo.
echo [5/6] Copiando nuevos archivos a IIS...
xcopy "out\*" "C:\inetpub\wwwroot\diris-lima-norte\" /E /Y >nul
if errorlevel 1 (
    echo [ERROR] Error copiando archivos
    pause
    exit /b 1
)
echo   ✓ Archivos actualizados en IIS

echo.
echo [6/6] Reiniciando Application Pool...
powershell -Command "Import-Module WebAdministration; Restart-WebAppPool -Name 'DefaultAppPool'" >nul 2>&1
echo   ✓ Application Pool reiniciado

echo.
echo ========================================
echo    ¡ACTUALIZACIÓN COMPLETADA!
echo ========================================
echo.
echo 🌐 Prueba tu página en:
echo    http://localhost/diris-lima-norte
echo.
echo ✅ Ahora debería cargar con CSS, imágenes y animaciones
echo.

set /p OPEN_BROWSER="¿Abrir en navegador? (S/N): "
if /i "%OPEN_BROWSER%"=="S" (
    start http://localhost/diris-lima-norte
)

pause
