@echo off
echo.
echo =====================================================
echo   DIRIS LIMA NORTE - ENTORNO DE DESARROLLO
echo =====================================================
echo.
echo Selecciona una opcion:
echo.
echo 1. Iniciar desarrollo (servidor local)
echo 2. Proceso completo de cambios y sincronizacion
echo 3. Solo sincronizar a staging
echo 4. Solo sincronizar a produccion
echo 5. Verificar estado de todos los ambientes
echo.
set /p opcion="Ingresa tu opcion (1-5): "

if "%opcion%"=="1" (
    echo.
    echo 🚀 Iniciando servidor de desarrollo...
    npm run dev
) else if "%opcion%"=="2" (
    echo.
    echo 🔄 Iniciando proceso completo...
    powershell -ExecutionPolicy Bypass -File "desarrollo-maestro.ps1"
) else if "%opcion%"=="3" (
    echo.
    echo 🎯 Sincronizando a staging...
    powershell -ExecutionPolicy Bypass -File "sync\sync-to-staging.ps1"
) else if "%opcion%"=="4" (
    echo.
    echo 🌟 Sincronizando a produccion...
    powershell -ExecutionPolicy Bypass -File "sync\sync-to-production.ps1"
) else if "%opcion%"=="5" (
    echo.
    echo 📊 Verificando estado...
    powershell -ExecutionPolicy Bypass -File "sync\verify-sync.ps1"
) else (
    echo.
    echo ❌ Opcion invalida
)

echo.
pause
