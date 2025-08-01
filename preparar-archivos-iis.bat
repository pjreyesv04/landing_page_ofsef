@echo off
echo ========================================
echo    VERIFICACION DE ARCHIVOS PARA IIS
echo    Default Web Site - Puerto 80
echo ========================================
echo.

echo [INFO] Verificando estructura del proyecto...
echo.

REM Verificar archivo principal
if not exist "package.json" (
    echo [ERROR] package.json no encontrado.
    echo Ejecutar desde la carpeta raiz del proyecto.
    pause
    exit /b 1
)
echo   ✓ package.json encontrado

REM Verificar web.config
if not exist "web.config" (
    echo [ERROR] web.config no encontrado.
    echo Este archivo es OBLIGATORIO para IIS.
    pause
    exit /b 1
)
echo   ✓ web.config encontrado

REM Verificar Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js no está instalado.
    echo Instalar desde: https://nodejs.org
    pause
    exit /b 1
)
echo   ✓ Node.js instalado

echo.
echo [PASO 1/3] Generando build de producción...

REM Limpiar build anterior
if exist "out" (
    rmdir /s /q "out"
    echo   - Build anterior eliminado
)

REM Generar build
call npm run build
if errorlevel 1 (
    echo [ERROR] Error al generar build.
    pause
    exit /b 1
)

if not exist "out" (
    echo [ERROR] Carpeta 'out' no fue generada.
    pause
    exit /b 1
)
echo   ✓ Build generado exitosamente

echo.
echo [PASO 2/3] Preparando archivos para IIS...

REM Copiar web.config a out
copy "web.config" "out\web.config" >nul
if errorlevel 1 (
    echo [ERROR] Error al copiar web.config
    pause
    exit /b 1
)
echo   ✓ web.config copiado a carpeta out

echo.
echo [PASO 3/3] Verificando archivos necesarios...

REM Verificar archivos en out
if not exist "out\index.html" (
    echo [ERROR] index.html no encontrado en out/
    pause
    exit /b 1
)
echo   ✓ index.html encontrado

if not exist "out\web.config" (
    echo [ERROR] web.config no encontrado en out/
    pause
    exit /b 1
)
echo   ✓ web.config encontrado en out/

if not exist "out\_next" (
    echo [WARNING] Carpeta _next no encontrada (puede ser normal)
) else (
    echo   ✓ Carpeta _next encontrada
)

if exist "out\favicon.ico" (
    echo   ✓ favicon.ico encontrado
)

echo.
echo ========================================
echo    ARCHIVOS LISTOS PARA IIS
echo ========================================
echo.
echo 📁 Archivos preparados en carpeta: out\
echo.
echo 📋 SIGUIENTE PASO:
echo    1. Copia TODO el contenido de la carpeta 'out\'
echo    2. Pega en: C:\inetpub\wwwroot\diris-lima-norte\
echo    3. Sigue la guía: GUIA-IIS-DEFAULT-WEBSITE.md
echo.

echo 📊 RESUMEN DE ARCHIVOS:
echo.
dir /b "out"
echo.

echo 🌐 TU URL SERA: http://localhost/diris-lima-norte
echo.

set /p OPEN_FOLDER="¿Abrir carpeta 'out' para copiar archivos? (S/N): "
if /i "%OPEN_FOLDER%"=="S" (
    start explorer "out"
)

echo.
echo ✅ ¡Archivos listos! Sigue la guía para configurar IIS.
pause
