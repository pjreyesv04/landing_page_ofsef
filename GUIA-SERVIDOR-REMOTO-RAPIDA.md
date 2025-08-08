# =============================================
# 🎯 GUÍA RÁPIDA - SERVIDOR REMOTO IIS
# =============================================

## 📋 PASOS PARA CONECTARTE AL SERVIDOR REMOTO

### 1. Conectar por Escritorio Remoto
```
1. Abrir Conexión a Escritorio Remoto
2. Conectar al servidor IIS
3. Iniciar sesión con credenciales
```

### 2. Preparar Scripts en el Servidor
```powershell
# En el servidor, crear directorio para scripts:
mkdir C:\scripts-diris
cd C:\scripts-diris

# Copiar el contenido de scripts-servidor-remoto.ps1
# Crear archivos individuales:
```

#### 📄 update-staging.ps1
```powershell
# Script para actualizar STAGING
# Guardar en: C:\scripts-diris\update-staging.ps1
# Ejecutar desde: C:\inetpub\wwwroot\page_ofseg_dirisln

Write-Host "🎯 ACTUALIZANDO STAGING - DIRIS Lima Norte" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

try {
    # Verificar directorio
    if (-not (Test-Path "package.json")) {
        Write-Error "❌ Ejecutar desde C:\inetpub\wwwroot\page_ofseg_dirisln"
        exit 1
    }
    
    # Sincronizar con GitHub
    Write-Host "📥 Sincronizando con GitHub..."
    git pull origin master
    
    # Actualizar dependencias si es necesario
    $packageChanged = git diff HEAD~1 HEAD --name-only | Where-Object { $_ -eq "package.json" }
    if ($packageChanged) {
        Write-Host "📦 Actualizando dependencias..."
        npm install
    }
    
    # Build para staging
    Write-Host "🔨 Generando build..."
    if (Test-Path "next.config.iis.ts") {
        Copy-Item "next.config.ts" "next.config.ts.backup" -Force
        Copy-Item "next.config.iis.ts" "next.config.ts" -Force
    }
    
    npm run build
    
    # Restaurar config
    if (Test-Path "next.config.ts.backup") {
        Copy-Item "next.config.ts.backup" "next.config.ts" -Force
        Remove-Item "next.config.ts.backup" -Force
    }
    
    Write-Host "✅ STAGING ACTUALIZADO" -ForegroundColor Green
    Write-Host "🌐 URL: http://localhost/page_ofseg_dirisln/" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ ERROR: $_" -ForegroundColor Red
}
```

#### 📄 update-production.ps1
```powershell
# Script para actualizar PRODUCCIÓN
# Guardar en: C:\scripts-diris\update-production.ps1
# Ejecutar desde: C:\inetpub\wwwroot

Write-Host "🌟 ACTUALIZANDO PRODUCCIÓN" -ForegroundColor Red

$confirm = Read-Host "¿Continuar con PRODUCCIÓN? (s/n)"
if ($confirm -ne "s") { exit 0 }

try {
    # Verificar directorio
    if (-not (Test-Path "package.json")) {
        Write-Error "❌ Ejecutar desde C:\inetpub\wwwroot"
        exit 1
    }
    
    # Sincronizar con GitHub
    Write-Host "📥 Sincronizando con GitHub..."
    git pull origin master
    
    # Actualizar dependencias si es necesario
    $packageChanged = git diff HEAD~1 HEAD --name-only | Where-Object { $_ -eq "package.json" }
    if ($packageChanged) {
        Write-Host "📦 Actualizando dependencias..."
        npm install
    }
    
    # Build para producción (sin basePath)
    Write-Host "🔨 Generando build..."
    $content = Get-Content "next.config.ts" -Raw
    Set-Content "next.config.ts.backup" $content
    
    $productionConfig = $content -replace "basePath: '/[^']*'", "basePath: ''"
    Set-Content "next.config.ts" $productionConfig
    
    npm run build
    
    # Restaurar config
    Copy-Item "next.config.ts.backup" "next.config.ts" -Force
    Remove-Item "next.config.ts.backup" -Force
    
    # Reiniciar IIS
    Write-Host "🔄 Reiniciando IIS..."
    iisreset /noforce
    
    Write-Host "✅ PRODUCCIÓN ACTUALIZADA" -ForegroundColor Green
    Write-Host "🌐 URL: http://localhost/" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ ERROR: $_" -ForegroundColor Red
}
```

### 3. Configurar Directorios en el Servidor

#### Para STAGING:
```
C:\inetpub\wwwroot\page_ofseg_dirisln\
```

#### Para PRODUCCIÓN:
```
C:\inetpub\wwwroot\
```

### 4. Workflow de Deployment

#### 🔧 Para actualizar STAGING:
```powershell
# En el servidor remoto:
cd C:\inetpub\wwwroot\page_ofseg_dirisln
C:\scripts-diris\update-staging.ps1
```

#### 🚀 Para actualizar PRODUCCIÓN:
```powershell
# En el servidor remoto:
cd C:\inetpub\wwwroot
C:\scripts-diris\update-production.ps1
```

### 5. URLs de Verificación

- **STAGING**: `http://[IP-SERVIDOR]/page_ofseg_dirisln/`
- **PRODUCCIÓN**: `http://[IP-SERVIDOR]/`

### 6. Comandos de Emergencia

#### Si hay problemas con Git:
```powershell
git reset --hard HEAD
git clean -fd
git pull origin master
```

#### Si hay problemas con dependencias:
```powershell
Remove-Item node_modules -Recurse -Force
Remove-Item package-lock.json -Force
npm install
```

#### Si hay problemas con IIS:
```powershell
iisreset /noforce
```

## 🔄 FLUJO COMPLETO

1. **En tu máquina local**: Hacer cambios y push a GitHub
2. **Conectar al servidor remoto**: Via Escritorio Remoto
3. **Actualizar STAGING**: Ejecutar script staging
4. **Verificar STAGING**: Probar funcionalidad
5. **Actualizar PRODUCCIÓN**: Ejecutar script producción
6. **Verificar PRODUCCIÓN**: Confirmar que todo funciona

## ⚠️ IMPORTANTE

- Siempre probar en STAGING antes de PRODUCCIÓN
- Mantener backups de configuraciones
- Verificar URLs después de cada deployment
- Documentar cualquier problema encontrado
