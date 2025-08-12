@echo off
echo.
echo ========================================
echo   SINCRONIZACION DESARROLLO LOCAL
echo ========================================
echo.

:: Verificar si estamos en un repositorio Git
if not exist ".git" (
    echo ❌ ERROR: No es un repositorio Git
    echo    Ejecutar desde: C:\Desarrollo\page_ofseg_dirisln
    pause
    exit /b 1
)

echo 🔄 Sincronizando con GitHub...
echo.

:: Guardar cambios locales si existen
git status --porcelain > nul 2>&1
if %ERRORLEVEL% EQU 0 (
    for /f %%i in ('git status --porcelain') do (
        echo ⚠️  Hay cambios locales sin confirmar
        echo    Guardando cambios temporalmente...
        git stash push -m "Backup automático antes de sincronizar"
        goto :pull
    )
)

:pull
:: Sincronizar con GitHub
git pull origin master
if %ERRORLEVEL% EQU 0 (
    echo ✅ Sincronización completada
    
    :: Restaurar cambios locales si existían
    git stash list | findstr "Backup automático" > nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo 🔄 Restaurando cambios locales...
        git stash pop
        echo ✅ Cambios locales restaurados
        echo.
        echo ⚠️  Verificar que no hay conflictos antes de continuar
    )
    
    echo.
    echo ========================================
    echo   SINCRONIZACIÓN COMPLETADA
    echo ========================================
    echo.
    echo 🚀 Listo para desarrollar:
    echo    npm run dev
    echo.
    echo 🌐 Sitio local disponible en:
    echo    http://localhost:3000
    echo.
) else (
    echo ❌ Error en sincronización
    echo.
    echo Posibles soluciones:
    echo 1. Verificar conexión a internet
    echo 2. Verificar credenciales de Git
    echo 3. Resolver conflictos manualmente
    echo.
    echo Para resolver conflictos:
    echo    git status
    echo    git add .
    echo    git commit -m "Resolver conflictos"
    echo    git pull origin master
)

echo.
pause
