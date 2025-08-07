# Script Maestro de Sincronización - DIRIS Lima Norte
# Gestiona sincronización entre todos los entornos

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('github', 'staging', 'production', 'all', 'status')]
    [string]$target,
    
    [string]$message = "Actualización $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    [switch]$force = $false,
    [switch]$noConfirm = $false
)

Write-Host "🔄 DIRIS LIMA NORTE - MAESTRO DE SINCRONIZACIÓN" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

# Verificar ubicación
if (-not (Test-Path "package.json")) {
    Write-Error "❌ Ejecutar desde d:\proyecto\"
    exit 1
}

function Show-Status {
    Write-Host "`n📊 ESTADO DE ENTORNOS:" -ForegroundColor Cyan
    
    # Local
    Write-Host "`n1️⃣ LOCAL (Desarrollo):" -ForegroundColor Green
    Write-Host "   📁 Ubicación: $(Get-Location)" -ForegroundColor White
    Write-Host "   📋 Archivos: $(Get-ChildItem src -Recurse | Measure-Object).Count archivos en src/" -ForegroundColor White
    
    # GitHub
    Write-Host "`n2️⃣ GITHUB (Repositorio):" -ForegroundColor Blue
    Write-Host "   🌐 URL: https://github.com/pjreyesv04/landing_page_ofsef" -ForegroundColor White
    Write-Host "   📄 Páginas: https://pjreyesv04.github.io/landing_page_ofsef/" -ForegroundColor White
    
    try {
        $gitStatus = git status --porcelain
        if ($gitStatus) {
            Write-Host "   ⚠️  Cambios pendientes: $($gitStatus.Count) archivos" -ForegroundColor Yellow
        } else {
            Write-Host "   ✅ Sin cambios pendientes" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ❓ Estado de Git no disponible" -ForegroundColor Gray
    }
    
    # Staging
    Write-Host "`n3️⃣ STAGING (Pruebas IIS):" -ForegroundColor Yellow
    Write-Host "   📁 Destino: C:\inetpub\wwwroot\page_ofseg_dirisln (Staging)" -ForegroundColor White
    if (Test-Path "deployment-staging") {
        $stagingFiles = (Get-ChildItem "deployment-staging" -Recurse).Count
        $stagingSize = [math]::Round((Get-ChildItem "deployment-staging" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
        Write-Host "   📊 Último build: $stagingFiles archivos, $stagingSize MB" -ForegroundColor White
    } else {
        Write-Host "   ⚠️  Sin build de staging preparado" -ForegroundColor Yellow
    }
    
    # Production
    Write-Host "`n4️⃣ PRODUCCIÓN (IIS Público):" -ForegroundColor Red
    Write-Host "   📁 Destino: C:\inetpub\wwwroot\page_ofseg_dirisln (Producción)" -ForegroundColor White
    if (Test-Path "deployment-production") {
        $prodFiles = (Get-ChildItem "deployment-production" -Recurse).Count
        $prodSize = [math]::Round((Get-ChildItem "deployment-production" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
        Write-Host "   📊 Último build: $prodFiles archivos, $prodSize MB" -ForegroundColor White
    } else {
        Write-Host "   ⚠️  Sin build de producción preparado" -ForegroundColor Yellow
    }
    
    # Logs
    Write-Host "`n📝 LOGS RECIENTES:" -ForegroundColor Cyan
    $logFiles = @("sync\github-sync.log", "sync\staging-sync.log", "sync\production-sync.log")
    foreach ($logFile in $logFiles) {
        if (Test-Path $logFile) {
            $lastEntry = Get-Content $logFile -Tail 1
            Write-Host "   📄 $($logFile.Split('\')[1]): $lastEntry" -ForegroundColor Gray
        }
    }
}

function Sync-GitHub {
    Write-Host "`n🔄 SINCRONIZANDO CON GITHUB..." -ForegroundColor Blue
    & ".\sync\sync-to-github.ps1" -message $message -force:$force
}

function Sync-Staging {
    Write-Host "`n🔄 PREPARANDO STAGING..." -ForegroundColor Yellow
    & ".\sync\sync-to-staging.ps1"
}

function Sync-Production {
    Write-Host "`n🔄 PREPARANDO PRODUCCIÓN..." -ForegroundColor Red
    & ".\sync\sync-to-production.ps1" -confirm:(-not $noConfirm)
}

# Ejecutar según el target
switch ($target) {
    'status' {
        Show-Status
    }
    
    'github' {
        Show-Status
        Sync-GitHub
    }
    
    'staging' {
        Show-Status
        Sync-Staging
    }
    
    'production' {
        Show-Status
        Sync-Production
    }
    
    'all' {
        Show-Status
        
        if (-not $noConfirm) {
            Write-Host "`n⚠️  SINCRONIZACIÓN COMPLETA: GitHub + Staging + Producción" -ForegroundColor Red
            $confirm = Read-Host "¿Continuar con sincronización completa? (s/n)"
            if ($confirm -ne "s" -and $confirm -ne "S") {
                Write-Host "❌ Operación cancelada" -ForegroundColor Red
                exit 0
            }
        }
        
        Write-Host "`n🚀 INICIANDO SINCRONIZACIÓN COMPLETA..." -ForegroundColor Magenta
        
        # 1. GitHub
        Sync-GitHub
        if ($LASTEXITCODE -ne 0) { 
            Write-Error "❌ Error en sincronización GitHub"
            exit 1 
        }
        
        # 2. Staging
        Sync-Staging
        if ($LASTEXITCODE -ne 0) { 
            Write-Error "❌ Error en preparación Staging"
            exit 1 
        }
        
        # 3. Production
        Sync-Production
        if ($LASTEXITCODE -ne 0) { 
            Write-Error "❌ Error en preparación Producción"
            exit 1 
        }
        
        Write-Host "`n🎉 SINCRONIZACIÓN COMPLETA EXITOSA" -ForegroundColor Green
        Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
        Write-Host "   1. Copiar deployment-staging al servidor de pruebas" -ForegroundColor White
        Write-Host "   2. Probar funcionamiento en staging" -ForegroundColor White
        Write-Host "   3. Copiar deployment-production al servidor público" -ForegroundColor White
    }
}

Write-Host "`n✅ OPERACIÓN COMPLETADA" -ForegroundColor Green
