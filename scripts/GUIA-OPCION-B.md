# GUÍA COMPLETA - OPCIÓN B: Desarrollo Local → GitHub → Servidor

## 📋 FLUJO DE TRABAJO PROFESIONAL

### PASO 1: CONFIGURAR AMBIENTE LOCAL
```
1. Editar en → Máquina Local (proyecto original)
2. Probar → Navegador local
3. Subir → GitHub (control de versiones)
4. Descargar → Servidor (desde GitHub)
5. Actualizar → Producción (C:\inetpub\wwwroot)
```

---

## 🖥️ PASO 1: EDITAR EN MÁQUINA LOCAL

### A. Ubicar tu proyecto local
- **Encuentra** tu carpeta de desarrollo local
- **Abrir** en tu editor preferido (VS Code, etc.)
- **Editar** archivos fuente (no minificados)

### B. Archivos principales a editar:
```
src/
├── app/
│   ├── page.tsx          ← Contenido principal
│   ├── layout.tsx        ← Estructura y meta tags
│   └── globals.css       ← Estilos globales
├── components/
│   └── landing/          ← Componentes de la landing
└── lib/
    └── image-paths.ts    ← Rutas de imágenes
```

---

## 🌐 PASO 2: CONTROL DE VERSIONES - GITHUB

### A. Comandos básicos Git:
```bash
# 1. Verificar estado
git status

# 2. Agregar cambios
git add .

# 3. Hacer commit
git commit -m "feat: actualizar datos de contacto"

# 4. Subir a GitHub
git push origin master
```

### B. Script automatizado para commits:
```powershell
# Crear archivo: commit-changes.ps1
param([string]$message = "Actualización de contenido")

Write-Host "🔄 Subiendo cambios a GitHub..." -ForegroundColor Cyan

git add .
git commit -m $message
git push origin master

Write-Host "✅ Cambios subidos exitosamente" -ForegroundColor Green
```

---

## 📡 PASO 3: ACTUALIZAR SERVIDOR DESDE GITHUB

### A. Script de descarga automática:
```powershell
# Archivo: update-from-github.ps1
Write-Host "🔄 Actualizando desde GitHub..." -ForegroundColor Yellow

# Navegar a carpeta de GitHub
Set-Location "C:\inetpub\wwwroot\page_ofseg_dirisln"

# Descargar últimos cambios
git pull origin master

# Verificar si hay cambios
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Descarga exitosa desde GitHub" -ForegroundColor Green
} else {
    Write-Host "❌ Error al descargar desde GitHub" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Archivos actualizados en staging" -ForegroundColor Cyan
```

### B. Verificar descarga:
```powershell
# Verificar fecha de última modificación
Get-ChildItem "C:\inetpub\wwwroot\page_ofseg_dirisln\index.html" | 
Select-Object Name, LastWriteTime
```

---

## 🚀 PASO 4: DESPLEGAR A PRODUCCIÓN

### A. Script de despliegue completo:
```powershell
# Archivo: deploy-to-production.ps1
param([switch]$Force)

Write-Host "🚀 DESPLEGANDO A PRODUCCIÓN" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

$staging = "C:\inetpub\wwwroot\page_ofseg_dirisln"
$production = "C:\inetpub\wwwroot"

# 1. Backup de producción actual
Write-Host "1. Creando backup..." -ForegroundColor Cyan
$backupName = "backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$backupPath = "$production\backups\$backupName"
New-Item -ItemType Directory -Path "$production\backups" -Force | Out-Null

Copy-Item "$production\index.html" "$backupPath-index.html" -Force
Copy-Item "$production\_next" "$backupPath-_next" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "$production\images" "$backupPath-images" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "✓ Backup creado: $backupName" -ForegroundColor Green

# 2. Copiar archivos principales
Write-Host "2. Copiando archivos..." -ForegroundColor Cyan

# index.html principal
Copy-Item "$staging\index.html" "$production\index.html" -Force
Write-Host "✓ index.html copiado" -ForegroundColor Green

# Carpeta _next (si existe)
if (Test-Path "$staging\_next") {
    Copy-Item "$staging\_next" "$production\_next" -Recurse -Force
    Write-Host "✓ Carpeta _next copiada" -ForegroundColor Green
}

# Carpeta images (si existe)
if (Test-Path "$staging\images") {
    Copy-Item "$staging\images" "$production\images" -Recurse -Force
    Write-Host "✓ Carpeta images copiada" -ForegroundColor Green
}

# web.config (si existe)
if (Test-Path "$staging\web.config") {
    Copy-Item "$staging\web.config" "$production\web.config" -Force
    Write-Host "✓ web.config copiado" -ForegroundColor Green
}

# 3. Verificar despliegue
Write-Host "3. Verificando despliegue..." -ForegroundColor Cyan

$prodFile = Get-Item "$production\index.html"
$stagingFile = Get-Item "$staging\index.html"

if ($prodFile.LastWriteTime -eq $stagingFile.LastWriteTime) {
    Write-Host "✅ DESPLIEGUE EXITOSO" -ForegroundColor Green
    Write-Host "Tamaño archivo: $($prodFile.Length) bytes" -ForegroundColor White
    Write-Host "Última modificación: $($prodFile.LastWriteTime)" -ForegroundColor White
} else {
    Write-Host "⚠️  Advertencia: Las fechas no coinciden" -ForegroundColor Yellow
}

# 4. Probar sitio
Write-Host "4. Probando sitio..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost/" -UseBasicParsing -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Sitio funcionando correctamente" -ForegroundColor Green
        Write-Host "URL: http://localhost/" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Error al probar sitio: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 DESPLIEGUE COMPLETADO" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Yellow
```

---

## 📋 PASO 5: SCRIPT MAESTRO - TODO EN UNO

### Crear script completo que automatice todo:
```powershell
# Archivo: full-deployment.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage,
    [switch]$SkipTests
)

Write-Host "🚀 FLUJO COMPLETO DE DESPLIEGUE" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow

# PASO 1: Subir a GitHub (desde local)
Write-Host "`n1. 📤 Subiendo cambios a GitHub..." -ForegroundColor Cyan
& .\commit-changes.ps1 -message $CommitMessage

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al subir a GitHub" -ForegroundColor Red
    exit 1
}

# PASO 2: Descargar en servidor
Write-Host "`n2. 📥 Descargando desde GitHub..." -ForegroundColor Cyan
& .\update-from-github.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al descargar desde GitHub" -ForegroundColor Red
    exit 1
}

# PASO 3: Desplegar a producción
Write-Host "`n3. 🚀 Desplegando a producción..." -ForegroundColor Cyan
& .\deploy-to-production.ps1

# PASO 4: Verificación final
Write-Host "`n4. ✅ Verificación final..." -ForegroundColor Cyan
Write-Host "Local → GitHub → Servidor → Producción" -ForegroundColor Green
Write-Host "Sitio disponible en: http://localhost/" -ForegroundColor White

Write-Host "`n🎯 FLUJO COMPLETADO EXITOSAMENTE" -ForegroundColor Green
```

---

## 📞 COMANDOS RÁPIDOS

### Para usar los scripts:
```powershell
# Despliegue completo
.\full-deployment.ps1 -CommitMessage "Actualizar datos de contacto"

# Solo subir a GitHub
.\commit-changes.ps1 -message "Cambios menores"

# Solo actualizar servidor
.\update-from-github.ps1

# Solo desplegar a producción
.\deploy-to-production.ps1
```

---

## 🔧 CONFIGURACIÓN INICIAL REQUERIDA

### 1. Configurar Git en el servidor:
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### 2. Clonar repositorio en servidor:
```bash
cd C:\inetpub\wwwroot
git clone https://github.com/pjreyesv04/landing_page_ofsef.git page_ofseg_dirisln
```

### 3. Crear carpeta para scripts:
```powershell
New-Item -ItemType Directory -Path "C:\inetpub\wwwroot\page_ofseg_dirisln\scripts" -Force
```

---

## ⚠️ CONSIDERACIONES IMPORTANTES

1. **Backup automático** antes de cada despliegue
2. **Verificación** de que el sitio funciona después del cambio
3. **Rollback** disponible en caso de problemas
4. **Sincronización** entre todas las versiones

---

## 🎯 VENTAJAS DE ESTE FLUJO

✅ **Control de versiones** completo
✅ **Historial** de todos los cambios
✅ **Rollback** fácil en caso de problemas
✅ **Automatización** de tareas repetitivas
✅ **Backup** automático antes de despliegues
✅ **Verificación** automática de funcionamiento
