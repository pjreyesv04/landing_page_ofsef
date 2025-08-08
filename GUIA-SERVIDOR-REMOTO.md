# 🌐 GUÍA DE SINCRONIZACIÓN CON SERVIDOR REMOTO IIS
## DIRIS Lima Norte - Deployment Remoto

### 📡 CONFIGURACIÓN SERVIDOR REMOTO:

**Equipo**: Servidor IIS (acceso por escritorio remoto)
- **IP/Nombre**: [CONFIGURAR_IP_DEL_SERVIDOR]
- **Usuario**: [CONFIGURAR_USUARIO]
- **Staging**: `C:\inetpub\wwwroot\page_ofseg_dirisln\`
- **Producción**: `C:\inetpub\wwwroot\`

---

## 🔄 PROCESO DE DEPLOYMENT COMPLETO:

### FASE 1: TRABAJO LOCAL (Tu máquina)

```powershell
# 1. Sincronizar con GitHub
git pull origin master

# 2. Realizar cambios en src/components/
# Editar archivos necesarios

# 3. Probar localmente
npm run dev

# 4. Commit y push a GitHub
git add .
git commit -m "Descripción de cambios"
git push origin master
```

### FASE 2: DEPLOYMENT EN SERVIDOR REMOTO

**🖥️ CONECTAR AL SERVIDOR:**
1. Abrir **Conexión a Escritorio Remoto**
2. Conectar al servidor IIS
3. Abrir PowerShell como Administrador en el servidor

**📁 EN EL SERVIDOR REMOTO:**

#### Para STAGING:
```powershell
# Navegar a directorio staging
cd C:\inetpub\wwwroot\page_ofseg_dirisln

# Sincronizar con GitHub
git pull origin master

# Si hay cambios en dependencias
npm install

# Build para IIS
npm run build

# Verificar que IIS esté funcionando
# Probar: http://[IP-SERVIDOR]/page_ofseg_dirisln/
```

#### Para PRODUCCIÓN (después de probar staging):
```powershell
# Navegar a directorio producción
cd C:\inetpub\wwwroot

# Sincronizar con GitHub
git pull origin master

# Si hay cambios en dependencias
npm install

# Build para IIS (configuración de producción)
npm run build

# Reiniciar IIS (si es necesario)
iisreset

# Verificar: http://[IP-SERVIDOR]/
```

---

## 🛠️ SCRIPTS PARA EL SERVIDOR REMOTO:

### Script de Update Staging (guardar en servidor):
```powershell
# update-staging.ps1
cd C:\inetpub\wwwroot\page_ofseg_dirisln
Write-Host "Actualizando Staging..." -ForegroundColor Green
git pull origin master
if ($LASTEXITCODE -eq 0) {
    npm run build
    Write-Host "✅ Staging actualizado" -ForegroundColor Green
} else {
    Write-Host "❌ Error en git pull" -ForegroundColor Red
}
```

### Script de Update Producción (guardar en servidor):
```powershell
# update-production.ps1
cd C:\inetpub\wwwroot
Write-Host "⚠️ Actualizando PRODUCCIÓN..." -ForegroundColor Yellow
$confirm = Read-Host "¿Continuar? (s/n)"
if ($confirm -eq "s") {
    git pull origin master
    if ($LASTEXITCODE -eq 0) {
        npm run build
        Write-Host "✅ Producción actualizada" -ForegroundColor Green
    } else {
        Write-Host "❌ Error en git pull" -ForegroundColor Red
    }
}
```

---

## 📋 CHECKLIST DE DEPLOYMENT REMOTO:

### Antes de cada deployment:
- [ ] Cambios realizados y probados localmente
- [ ] Commit y push a GitHub completado
- [ ] Conexión al servidor remoto establecida
- [ ] Backup de producción realizado (si es crítico)

### En el servidor remoto:
- [ ] Git pull exitoso en staging
- [ ] Build exitoso en staging
- [ ] Pruebas en staging completadas
- [ ] Git pull exitoso en producción
- [ ] Build exitoso en producción
- [ ] Verificación final del sitio público

---

## 🚨 TROUBLESHOOTING:

### Si git pull falla en el servidor:
```powershell
# Verificar estado
git status

# Si hay conflictos, resetear (CUIDADO)
git reset --hard origin/master

# O resolver conflictos manualmente
```

### Si npm run build falla:
```powershell
# Limpiar cache
npm cache clean --force

# Reinstalar dependencias
rm -rf node_modules
npm install

# Intentar build nuevamente
npm run build
```

### Si IIS no refleja cambios:
```powershell
# Reiniciar IIS
iisreset

# O reiniciar solo el Application Pool
# En IIS Manager → Application Pools → [Tu App] → Restart
```

---

## 🔧 CONFIGURACIÓN INICIAL DEL SERVIDOR:

Si el servidor no tiene los repositorios configurados:

```powershell
# En C:\inetpub\wwwroot\page_ofseg_dirisln\
git clone https://github.com/pjreyesv04/landing_page_ofsef.git .

# En C:\inetpub\wwwroot\
git clone https://github.com/pjreyesv04/landing_page_ofsef.git .

# En ambos directorios:
npm install
```
