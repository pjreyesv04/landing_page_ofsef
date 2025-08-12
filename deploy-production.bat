@echo off
echo.
echo ==========================================
echo   DEPLOYMENT A PRODUCCIÓN DESDE GITHUB
echo ==========================================
echo.

:: Verificar si estamos en el directorio correcto
if not exist "web.config" (
    echo ERROR: No se encuentra web.config. Ejecutar desde el directorio correcto.
    pause
    exit /b 1
)

:: Advertencia importante
echo ⚠️  ATENCIÓN: Deployment a PRODUCCIÓN
echo.
echo Este proceso actualizará el sitio en PRODUCCIÓN
echo con la última versión desde GitHub.
echo.
set /p confirm="¿Continuar? (S/N): "
if /i "%confirm%" NEQ "S" (
    echo Deployment cancelado por el usuario.
    pause
    exit /b 0
)

:: Configurar ambiente producción
echo Configurando ambiente PRODUCCIÓN...
copy "next.config.production.ts" "next.config.ts" /Y > nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo configurar ambiente producción
    pause
    exit /b 1
)

echo ✅ Configuración PRODUCCIÓN aplicada

:: Ejecutar script de actualización
echo Ejecutando deployment desde GitHub...
powershell -ExecutionPolicy Bypass -File "update-from-github.ps1"

:: Verificar resultado
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo   DEPLOYMENT A PRODUCCIÓN COMPLETADO
    echo ==========================================
    echo.
    echo ✅ Sitio disponible en PRODUCCIÓN:
    echo    http://tu-dominio-produccion.com/
    echo.
    echo 🔍 Verificar en navegadores:
    echo    - Chrome:  http://tu-dominio-produccion.com/
    echo    - Firefox: http://tu-dominio-produccion.com/
    echo.
    echo 📊 Monitorear métricas y logs de producción
    echo 🔔 Notificar al equipo sobre el deployment
) else (
    echo.
    echo ==========================================
    echo   DEPLOYMENT A PRODUCCIÓN FALLÓ
    echo ==========================================
    echo ❌ ROLLBACK REQUERIDO - Contactar administrador
    echo.
    echo Revisar logs para más detalles.
)

echo.
pause
