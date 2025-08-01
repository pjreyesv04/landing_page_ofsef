@echo off
echo ========================================
echo    BUILD PARA GITHUB PAGES
echo ========================================
echo.

echo [1/3] Generando build para GitHub Pages...
set DEPLOY_TARGET=github
call npm run build
if errorlevel 1 (
    echo [ERROR] Error en build para GitHub
    pause
    exit /b 1
)
echo   ✓ Build para GitHub Pages generado

echo.
echo [2/3] Verificando archivos generados...
if exist "out\index.html" (
    echo   ✓ index.html encontrado
) else (
    echo   ✗ index.html NO encontrado
    pause
    exit /b 1
)

if exist "out\images" (
    echo   ✓ Carpeta images encontrada
) else (
    echo   ✗ Carpeta images NO encontrada
)

echo.
echo [3/3] Archivos listos para GitHub Pages
echo.
echo 📁 Archivos en carpeta: out\
dir /b "out"
echo.
echo 🚀 Ahora puedes hacer commit y push a GitHub
echo.
pause
