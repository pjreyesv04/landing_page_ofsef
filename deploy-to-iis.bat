@echo off
echo ========================================
echo    SCRIPT DE DESPLIEGUE PARA IIS
echo    DIRIS Lima Norte - Landing Page
echo ========================================
echo.

REM Configuración de rutas
set SOURCE_DIR=%~dp0
set BUILD_DIR=%SOURCE_DIR%out
set IIS_DIR=C:\inetpub\wwwroot\diris-lima-norte

echo [INFO] Directorio fuente: %SOURCE_DIR%
echo [INFO] Directorio build: %BUILD_DIR%
echo [INFO] Directorio IIS: %IIS_DIR%
echo.

REM Verificar si existe Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js no está instalado o no está en el PATH
    pause
    exit /b 1
)

echo [PASO 1] Instalando dependencias...
call npm install
if errorlevel 1 (
    echo [ERROR] Error al instalar dependencias
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas correctamente
echo.

echo [PASO 2] Generando build de producción...
call npm run build
if errorlevel 1 (
    echo [ERROR] Error al generar build
    pause
    exit /b 1
)
echo [OK] Build generado correctamente
echo.

echo [PASO 3] Verificando exportación estática...
if not exist "%BUILD_DIR%" (
    echo [ERROR] No se encontró el directorio de build exportado
    echo [INFO] El build de Next.js con 'output: export' debería generar la carpeta 'out'
    pause
    exit /b 1
)
echo [OK] Aplicación exportada correctamente (build automático)
echo.

echo [PASO 4] Preparando directorio de IIS...
if exist "%IIS_DIR%" (
    echo [INFO] Creando backup del sitio actual...
    if exist "%IIS_DIR%_backup" rmdir /s /q "%IIS_DIR%_backup"
    move "%IIS_DIR%" "%IIS_DIR%_backup"
    echo [OK] Backup creado en %IIS_DIR%_backup
)

mkdir "%IIS_DIR%" 2>nul
echo [OK] Directorio IIS preparado
echo.

echo [PASO 5] Copiando archivos al servidor IIS...
xcopy "%BUILD_DIR%\*" "%IIS_DIR%" /E /I /Y /Q
if errorlevel 1 (
    echo [ERROR] Error al copiar archivos
    pause
    exit /b 1
)

REM Copiar web.config optimizado para IIS
copy "%SOURCE_DIR%web.config.iis" "%IIS_DIR%\web.config" /Y
if not exist "%IIS_DIR%\web.config" (
    echo [WARNING] No se encontró web.config.iis, copiando web.config básico
    copy "%SOURCE_DIR%web.config" "%IIS_DIR%\" /Y
)
echo [OK] Archivos copiados correctamente
echo.

echo [PASO 6] Configurando permisos...
icacls "%IIS_DIR%" /grant "IIS_IUSRS:(OI)(CI)F" /T >nul 2>&1
icacls "%IIS_DIR%" /grant "IUSR:(OI)(CI)F" /T >nul 2>&1
echo [OK] Permisos configurados
echo.

echo [PASO 7] Reiniciando IIS...
iisreset /noforce >nul 2>&1
if errorlevel 1 (
    echo [WARNING] No se pudo reiniciar IIS automáticamente
    echo [INFO] Reinicia IIS manualmente: iisreset
) else (
    echo [OK] IIS reiniciado correctamente
)
echo.

echo ========================================
echo       DESPLIEGUE COMPLETADO
echo ========================================
echo.
echo [INFO] El sitio está disponible en:
echo        http://localhost/diris-lima-norte
echo        http://tu-servidor/diris-lima-norte
echo        (Como aplicación dentro del Default Web Site)
echo.
echo [INFO] Archivos desplegados en: %IIS_DIR%
echo [INFO] Backup anterior en: %IIS_DIR%_backup
echo.
pause
