@echo off
echo ========================================
echo    DESPLIEGUE DIRIS LIMA NORTE
echo    Servidor IIS Remoto - Windows Server
echo ========================================
echo.

REM Configuración - MODIFICAR ESTOS VALORES
set /p SERVER_IP="Ingresa la IP del servidor remoto: "
set /p USERNAME="Ingresa el usuario administrador: "
set /p PASSWORD="Ingresa la contraseña: "

set SITE_NAME=DIRIS Lima Norte
set APP_POOL_NAME=DirisLimaNorte
set REMOTE_PATH=C:\inetpub\wwwroot\diris-lima-norte
set PORT=80

echo.
echo [INFO] Configuración:
echo   - Servidor: %SERVER_IP%
echo   - Usuario: %USERNAME%
echo   - Sitio: %SITE_NAME%
echo   - Puerto: %PORT%
echo.

set /p CONFIRM="¿Continuar con el despliegue? (S/N): "
if /i not "%CONFIRM%"=="S" (
    echo Despliegue cancelado.
    pause
    exit /b 1
)

echo.
echo [1/5] Verificando requisitos...

REM Verificar Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js no está instalado.
    echo Por favor instalar Node.js 18+ desde: https://nodejs.org
    pause
    exit /b 1
)
echo   ✓ Node.js encontrado

REM Verificar npm
npm --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm no está disponible.
    pause
    exit /b 1
)
echo   ✓ npm encontrado

REM Verificar package.json
if not exist "package.json" (
    echo [ERROR] package.json no encontrado.
    echo Ejecutar desde la carpeta raíz del proyecto.
    pause
    exit /b 1
)
echo   ✓ package.json encontrado

echo.
echo [2/5] Generando build de producción...

REM Limpiar builds anteriores
if exist "out" rmdir /s /q "out"
if exist "deploy.zip" del /f "deploy.zip"

REM Instalar dependencias
echo   - Instalando dependencias...
call npm install
if errorlevel 1 (
    echo [ERROR] Error al instalar dependencias.
    pause
    exit /b 1
)

REM Generar build
echo   - Generando build...
call npm run build
if errorlevel 1 (
    echo [ERROR] Error al generar build.
    pause
    exit /b 1
)

REM Verificar que se generó la carpeta out
if not exist "out" (
    echo [ERROR] Carpeta 'out' no fue generada.
    echo Verificar configuración de Next.js.
    pause
    exit /b 1
)

REM Copiar web.config
if exist "web.config" (
    copy "web.config" "out\web.config" >nul
    echo   ✓ web.config copiado
) else (
    echo [WARNING] web.config no encontrado, se usará configuración por defecto
)

echo   ✓ Build generado exitosamente

echo.
echo [3/5] Preparando archivos para transferencia...

REM Crear archivo comprimido
powershell -Command "Compress-Archive -Path 'out\*' -DestinationPath 'deploy.zip' -Force"
if errorlevel 1 (
    echo [ERROR] Error al comprimir archivos.
    pause
    exit /b 1
)
echo   ✓ Archivos comprimidos en deploy.zip

echo.
echo [4/5] Transfiriendo al servidor remoto...

REM Verificar conectividad
ping -n 2 %SERVER_IP% >nul
if errorlevel 1 (
    echo [ERROR] No se puede conectar al servidor %SERVER_IP%
    echo Verificar IP y conectividad de red.
    pause
    exit /b 1
)
echo   ✓ Servidor accesible

REM Ejecutar script PowerShell para despliegue
echo   - Ejecutando despliegue remoto...
powershell -ExecutionPolicy Bypass -File "scripts\deploy-to-remote-iis.ps1" -ServerIP "%SERVER_IP%" -Username "%USERNAME%" -Password "%PASSWORD%" -RemotePath "%REMOTE_PATH%" -SiteName "%SITE_NAME%" -AppPoolName "%APP_POOL_NAME%" -Port %PORT%

if errorlevel 1 (
    echo.
    echo [ERROR] Error durante el despliegue remoto.
    echo Verificar:
    echo   - Credenciales de acceso
    echo   - IIS instalado en el servidor
    echo   - Permisos de administrador
    echo   - PowerShell Remoting habilitado
    echo.
    pause
    exit /b 1
)

echo.
echo [5/5] Verificando despliegue...

REM Probar acceso al sitio
echo   - Probando conectividad al sitio...
timeout /t 5 /nobreak >nul

curl -s -o nul -w "%%{http_code}" "http://%SERVER_IP%:%PORT%" > temp_status.txt 2>nul
set /p HTTP_STATUS=<temp_status.txt
del temp_status.txt >nul 2>&1

if "%HTTP_STATUS%"=="200" (
    echo   ✓ Sitio web responde correctamente (HTTP %HTTP_STATUS%)
) else (
    echo   ⚠ Verificar manualmente: http://%SERVER_IP%:%PORT%
)

REM Limpiar archivos temporales
if exist "deploy.zip" del /f "deploy.zip"

echo.
echo ========================================
echo           ¡DESPLIEGUE COMPLETADO!
echo ========================================
echo.
echo 🌐 URL del sitio: http://%SERVER_IP%:%PORT%
echo 📁 Ruta en servidor: %REMOTE_PATH%
echo 🏊 Application Pool: %APP_POOL_NAME%
echo 🖥️ Sitio IIS: %SITE_NAME%
echo.
echo ✅ La aplicación DIRIS Lima Norte está lista!
echo.
echo 📋 Próximos pasos opcionales:
echo   1. Configurar dominio personalizado
echo   2. Instalar certificado SSL
echo   3. Configurar monitoreo automático
echo   4. Configurar backups automáticos
echo.

REM Abrir sitio en navegador
set /p OPEN_SITE="¿Abrir sitio en navegador? (S/N): "
if /i "%OPEN_SITE%"=="S" (
    start http://%SERVER_IP%:%PORT%
)

echo.
echo Presiona cualquier tecla para continuar...
pause >nul
