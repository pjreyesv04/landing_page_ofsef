# 🛠️ SCRIPT MAESTRO PARA DESARROLLO
# Ejecutar este proceso cada vez que hagas cambios

param(
    [string]$mensaje = "Actualización de contenido",
    [switch]$skipStaging = $false,
    [switch]$skipProduction = $false
)

Write-Host "🚀 INICIANDO PROCESO DE DESARROLLO Y SINCRONIZACIÓN" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green

try {
    # PASO 1: Verificar y sincronizar con GitHub
    Write-Host "`n1. 📥 SINCRONIZANDO CON GITHUB..." -ForegroundColor Cyan
    
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Hay cambios locales pendientes. Verificando..." -ForegroundColor Yellow
        git status
    }
    
    Write-Host "📥 Obteniendo últimos cambios de GitHub..."
    git pull origin master
    
    if ($LASTEXITCODE -ne 0) {
        throw "Error al sincronizar con GitHub"
    }
    
    # PASO 2: Mostrar estado actual
    Write-Host "`n2. 📊 ESTADO ACTUAL:" -ForegroundColor Cyan
    Write-Host "   Rama actual: $(git branch --show-current)"
    Write-Host "   Último commit: $(git log --oneline -1)"
    Write-Host "   Archivos modificados: $(if ($gitStatus) { $gitStatus.Count } else { 0 })"
    
    # PASO 3: Instrucciones para el usuario
    Write-Host "`n3. 🔧 REALIZAR CAMBIOS:" -ForegroundColor Cyan
    Write-Host "   - Edita los archivos en src/components/"
    Write-Host "   - Modifica contenido, textos, estilos"
    Write-Host "   - Prueba localmente con: npm run dev"
    Write-Host ""
    
    $continuar = Read-Host "¿Has realizado los cambios necesarios? (s/n)"
    if ($continuar -ne "s" -and $continuar -ne "S") {
        Write-Host "⏸️  Proceso pausado. Realiza los cambios y ejecuta el script nuevamente." -ForegroundColor Yellow
        exit 0
    }
    
    # PASO 4: Build y preparación
    Write-Host "`n4. 🔨 GENERANDO BUILDS..." -ForegroundColor Cyan
    
    Write-Host "   📦 Build para GitHub Pages..."
    $env:DEPLOY_TARGET = "github"
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        throw "Error en build para GitHub"
    }
    
    Write-Host "   📦 Build para IIS..."
    $env:DEPLOY_TARGET = "iis"
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        throw "Error en build para IIS"
    }
    
    # PASO 5: Commit y push a GitHub
    Write-Host "`n5. 📤 SUBIENDO A GITHUB..." -ForegroundColor Cyan
    
    git add .
    git commit -m "$mensaje - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin master
    
    if ($LASTEXITCODE -ne 0) {
        throw "Error al subir a GitHub"
    }
    
    Write-Host "✅ Cambios subidos a GitHub exitosamente" -ForegroundColor Green
    
    # PASO 6: Instrucciones para servidor remoto
    Write-Host "`n6. � DEPLOYMENT EN SERVIDOR REMOTO" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📡 CONECTAR AL SERVIDOR IIS:"
    Write-Host "   1. Abrir Conexión a Escritorio Remoto"
    Write-Host "   2. Conectar al servidor IIS"
    Write-Host "   3. Abrir PowerShell como Administrador"
    Write-Host ""
    Write-Host "🎯 PARA STAGING:"
    Write-Host "   cd C:\inetpub\wwwroot\page_ofseg_dirisln"
    Write-Host "   git pull origin master"
    Write-Host "   npm run build"
    Write-Host "   # Probar: http://[IP-SERVIDOR]/page_ofseg_dirisln/"
    Write-Host ""
    Write-Host "🌟 PARA PRODUCCIÓN (después de probar staging):"
    Write-Host "   cd C:\inetpub\wwwroot"
    Write-Host "   git pull origin master"
    Write-Host "   npm run build"
    Write-Host "   # Probar: http://[IP-SERVIDOR]/"
    Write-Host ""
    
    $abrirGuia = Read-Host "¿Deseas abrir la guía detallada del servidor remoto? (s/n)"
    if ($abrirGuia -eq "s" -or $abrirGuia -eq "S") {
        if (Test-Path "GUIA-SERVIDOR-REMOTO.md") {
            Start-Process "GUIA-SERVIDOR-REMOTO.md"
        }
    }
    
    # PASO 7: Resumen final
    Write-Host "`n7. ✅ PROCESO LOCAL COMPLETADO" -ForegroundColor Green
    Write-Host "=" * 60 -ForegroundColor Green
    Write-Host "🎯 Cambios subidos a GitHub exitosamente"
    Write-Host ""
    Write-Host "📡 PRÓXIMOS PASOS EN SERVIDOR REMOTO:"
    Write-Host "   1. Conectar por escritorio remoto al servidor IIS"
    Write-Host "   2. Actualizar staging: git pull + npm run build"
    Write-Host "   3. Probar staging en navegador"
    Write-Host "   4. Actualizar producción: git pull + npm run build"
    Write-Host "   5. Verificar sitio público"
    Write-Host ""
    Write-Host "� URLs disponibles después del deployment:"
    Write-Host "   • GitHub Pages: https://pjreyesv04.github.io/landing_page_ofsef/"
    Write-Host "   • Staging: http://[IP-SERVIDOR]/page_ofseg_dirisln/"
    Write-Host "   • Producción: http://[IP-SERVIDOR]/"
    Write-Host ""
    Write-Host "📁 Estado actual:"
    Write-Host "   • Local: ✅ Actualizado y sincronizado"
    Write-Host "   • GitHub: ✅ Actualizado con últimos cambios"
    Write-Host "   • Servidor IIS: ⏳ Pendiente de actualización remota"
    
} catch {
    Write-Host "`n❌ ERROR: $_" -ForegroundColor Red
    Write-Host "Proceso interrumpido. Revisa el error y vuelve a intentar." -ForegroundColor Red
    exit 1
}
