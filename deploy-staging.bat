@echo off
echo.
echo ========================================
echo   DEPLOYMENT A STAGING DESDE GITHUB
echo ========================================
echo.

:: Verificar si estamos en el directorio correcto
if not exist "web.config" (
    echo ERROR: No se encuentra web.config. Ejecutar desde el directorio correcto.
    pause
    exit /b 1
)

:: Configurar ambiente staging
echo Configurando ambiente STAGING...
copy "next.config.staging.ts" "next.config.ts" /Y > nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo configurar ambiente staging
    pause
    exit /b 1
)

echo ✅ Configuración STAGING aplicada

:: Ejecutar script de actualización
echo Ejecutando deployment desde GitHub...
powershell -ExecutionPolicy Bypass -File "update-from-github.ps1"

:: Verificar resultado
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   DEPLOYMENT A STAGING COMPLETADO
    echo ========================================
    echo.
    echo ✅ Sitio disponible en STAGING:
    echo    http://localhost/page_ofseg_dirisln/
    echo.
    echo 🔍 Verificar en navegadores:
    echo    - Chrome:  http://localhost/page_ofseg_dirisln/
    echo    - Firefox: http://localhost/page_ofseg_dirisln/
    echo.
    echo 📋 Si todo funciona bien, proceder a PRODUCCIÓN
) else (
    echo.
    echo ========================================
    echo   DEPLOYMENT A STAGING FALLÓ
    echo ========================================
    echo Revisar logs para más detalles.
)

echo.
pause
