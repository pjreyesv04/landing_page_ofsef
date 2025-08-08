# Scripts para copiar al SERVIDOR REMOTO IIS
# Guardar estos archivos en el servidor para facilitar deployment

# ===============================================
# update-staging.ps1
# Ejecutar en: C:\inetpub\wwwroot\page_ofseg_dirisln
# ===============================================

Write-Host "🎯 ACTUALIZANDO STAGING - DIRIS Lima Norte" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

try {
    # Verificar que estamos en el directorio correcto
    $currentPath = Get-Location
    Write-Host "📁 Directorio actual: $currentPath"
    
    if (-not (Test-Path "package.json")) {
        Write-Error "❌ No se encontró package.json. Verificar directorio."
        exit 1
    }
    
    # Verificar estado de Git
    Write-Host "`n📡 Verificando estado de Git..."
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Hay cambios locales. Mostrando estado:" -ForegroundColor Yellow
        git status
        
        $reset = Read-Host "`n¿Descartar cambios locales y sincronizar con GitHub? (s/n)"
        if ($reset -eq "s" -or $reset -eq "S") {
            git reset --hard HEAD
            git clean -fd
            Write-Host "🧹 Cambios locales descartados" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Operación cancelada" -ForegroundColor Red
            exit 1
        }
    }
    
    # Sincronizar con GitHub
    Write-Host "`n📥 Sincronizando con GitHub..."
    git pull origin master
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error al sincronizar con GitHub"
        exit 1
    }
    
    # Verificar si hay cambios en package.json
    $packageChanged = git diff HEAD~1 HEAD --name-only | Where-Object { $_ -eq "package.json" }
    if ($packageChanged) {
        Write-Host "`n📦 Detectados cambios en package.json. Actualizando dependencias..."
        npm install
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Error al instalar dependencias"
            exit 1
        }
    }
    
    # Build para staging
    Write-Host "`n🔨 Generando build para staging..."
    
    # Usar configuración específica para IIS staging
    if (Test-Path "next.config.iis.ts") {
        if (Test-Path "next.config.ts.backup") {
            Remove-Item "next.config.ts.backup" -Force
        }
        Copy-Item "next.config.ts" "next.config.ts.backup" -Force
        Copy-Item "next.config.iis.ts" "next.config.ts" -Force
        Write-Host "📄 Configuración IIS aplicada" -ForegroundColor Cyan
    }
    
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        # Restaurar configuración si falló
        if (Test-Path "next.config.ts.backup") {
            Copy-Item "next.config.ts.backup" "next.config.ts" -Force
        }
        Write-Error "❌ Error en build"
        exit 1
    }
    
    # Restaurar configuración original
    if (Test-Path "next.config.ts.backup") {
        Copy-Item "next.config.ts.backup" "next.config.ts" -Force
        Remove-Item "next.config.ts.backup" -Force
    }
    
    Write-Host "`n✅ STAGING ACTUALIZADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "🌐 Probar en: http://localhost/page_ofseg_dirisln/" -ForegroundColor Cyan
    Write-Host "🌐 O en: http://[IP-SERVIDOR]/page_ofseg_dirisln/" -ForegroundColor Cyan
    
} catch {
    Write-Host "`n❌ ERROR: $_" -ForegroundColor Red
    Write-Host "Verificar logs y volver a intentar." -ForegroundColor Red
    exit 1
}

Write-Host "`nPresiona cualquier tecla para continuar..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# ===============================================
# update-production.ps1  
# Ejecutar en: C:\inetpub\wwwroot
# ===============================================

Write-Host "`n`n🌟 ACTUALIZANDO PRODUCCIÓN - DIRIS Lima Norte" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor Red
Write-Host "⚠️  ATENCIÓN: Esto actualizará el sitio público" -ForegroundColor Yellow

$confirm = Read-Host "`n¿Continuar con actualización de PRODUCCIÓN? (s/n)"
if ($confirm -ne "s" -and $confirm -ne "S") {
    Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
    exit 0
}

try {
    # Verificar que estamos en el directorio correcto
    $currentPath = Get-Location
    Write-Host "📁 Directorio actual: $currentPath"
    
    if (-not (Test-Path "package.json")) {
        Write-Error "❌ No se encontró package.json. Verificar directorio."
        exit 1
    }
    
    # Verificar estado de Git
    Write-Host "`n📡 Verificando estado de Git..."
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "⚠️  Hay cambios locales. Mostrando estado:" -ForegroundColor Yellow
        git status
        
        $reset = Read-Host "`n¿Descartar cambios locales y sincronizar con GitHub? (s/n)"
        if ($reset -eq "s" -or $reset -eq "S") {
            git reset --hard HEAD
            git clean -fd
            Write-Host "🧹 Cambios locales descartados" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Operación cancelada" -ForegroundColor Red
            exit 1
        }
    }
    
    # Sincronizar con GitHub
    Write-Host "`n📥 Sincronizando con GitHub..."
    git pull origin master
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Error al sincronizar con GitHub"
        exit 1
    }
    
    # Verificar si hay cambios en package.json
    $packageChanged = git diff HEAD~1 HEAD --name-only | Where-Object { $_ -eq "package.json" }
    if ($packageChanged) {
        Write-Host "`n📦 Detectados cambios en package.json. Actualizando dependencias..."
        npm install
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "❌ Error al instalar dependencias"
            exit 1
        }
    }
    
    # Build para producción
    Write-Host "`n🔨 Generando build para producción..."
    
    # Para producción, usar configuración sin basePath
    if (Test-Path "next.config.ts") {
        $content = Get-Content "next.config.ts" -Raw
        # Backup
        Set-Content "next.config.ts.backup" $content
        
        # Modificar para producción (sin basePath)
        $productionConfig = $content -replace "basePath: '/[^']*'", "basePath: ''"
        $productionConfig = $productionConfig -replace "assetPrefix: '/[^']*'", "assetPrefix: ''"
        Set-Content "next.config.ts" $productionConfig
        
        Write-Host "📄 Configuración de producción aplicada" -ForegroundColor Cyan
    }
    
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        # Restaurar configuración si falló
        if (Test-Path "next.config.ts.backup") {
            Copy-Item "next.config.ts.backup" "next.config.ts" -Force
        }
        Write-Error "❌ Error en build"
        exit 1
    }
    
    # Restaurar configuración original
    if (Test-Path "next.config.ts.backup") {
        Copy-Item "next.config.ts.backup" "next.config.ts" -Force
        Remove-Item "next.config.ts.backup" -Force
    }
    
    # Reiniciar IIS Application Pool si es necesario
    Write-Host "`n🔄 Reiniciando IIS..."
    try {
        iisreset /noforce
        Write-Host "✅ IIS reiniciado" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  No se pudo reiniciar IIS automáticamente. Hazlo manualmente si es necesario." -ForegroundColor Yellow
    }
    
    Write-Host "`n✅ PRODUCCIÓN ACTUALIZADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "🌐 Sitio público en: http://localhost/" -ForegroundColor Cyan
    Write-Host "🌐 O en: http://[IP-SERVIDOR]/" -ForegroundColor Cyan
    
} catch {
    Write-Host "`n❌ ERROR: $_" -ForegroundColor Red
    Write-Host "Verificar logs y volver a intentar." -ForegroundColor Red
    exit 1
}

Write-Host "`nPresiona cualquier tecla para continuar..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
