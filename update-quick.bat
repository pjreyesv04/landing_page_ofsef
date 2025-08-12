@echo off
echo.
echo ========================================
echo   ACTUALIZACION RAPIDA DESDE GITHUB
echo ========================================
echo.

:: Verificar si estamos en el directorio correcto
if not exist "web.config" (
    echo ERROR: No se encuentra web.config. Ejecutar desde el directorio correcto.
    pause
    exit /b 1
)

:: Ejecutar script de PowerShell
echo Ejecutando actualizacion automatica...
powershell -ExecutionPolicy Bypass -File "update-from-github.ps1"

:: Verificar resultado
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   ACTUALIZACION COMPLETADA
    echo ========================================
    echo.
    echo Verificar sitio en:
    echo - Chrome:  http://localhost/page_ofseg_dirisln/
    echo - Firefox: http://localhost/page_ofseg_dirisln/
    echo.
    echo Diagnostico: http://localhost/page_ofseg_dirisln/browser-test.html
) else (
    echo.
    echo ========================================
    echo   ACTUALIZACION FALLO
    echo ========================================
    echo Revisar logs para mas detalles.
)

echo.
pause
