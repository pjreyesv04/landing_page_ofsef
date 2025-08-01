# 🚀 Guía Completa: Despliegue en IIS Windows Server Remoto

## 📋 REQUISITOS PREVIOS

### En tu Máquina Local (Desarrollo):
- [x] Node.js 18+ instalado
- [x] Acceso RDP al servidor remoto Windows Server
- [x] Credenciales de administrador del servidor remoto
- [x] Cliente FTP/SFTP (FileZilla, WinSCP) o acceso a carpetas compartidas

### En el Servidor Windows Server Remoto:
- [x] Windows Server 2016+ 
- [x] IIS (Internet Information Services) instalado y configurado
- [x] Node.js 18+ instalado (opcional, solo si vas a compilar en el servidor)
- [x] Firewall configurado para permitir tráfico HTTP/HTTPS
- [x] Permisos de administrador

---

## 🔧 PASO 1: PREPARAR LA APLICACIÓN LOCALMENTE

### 1.1 Instalar dependencias y generar build
```bash
# En tu máquina local, desde la carpeta del proyecto
npm install
npm run build
```

El comando `npm run build` generará la carpeta `out/` con todos los archivos estáticos listos para IIS.

### 1.2 Verificar archivos generados
Después del build, deberías tener:
- `out/` - Carpeta con todos los archivos estáticos
- `web.config` - Configuración para IIS
- Archivos estáticos (HTML, CSS, JS, imágenes)

---

## 🖥️ PASO 2: ACCEDER AL SERVIDOR REMOTO

### 2.1 Conectarse via RDP
```bash
# Ejecutar desde Windows (Run)
mstsc
```
- **Computer:** [IP-del-servidor]
- **User:** [usuario-admin]
- **Password:** [contraseña-admin]

### 2.2 Verificar IIS está instalado
En el servidor remoto, abrir PowerShell como administrador:
```powershell
# Verificar si IIS está instalado
Get-WindowsFeature -Name IIS-*

# Verificar servicios de IIS están corriendo
Get-Service -Name W3SVC
```

### 2.3 Instalar IIS si no está disponible
```powershell
# Instalar IIS con características necesarias
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpRedirect, IIS-ApplicationDevelopment, IIS-HealthAndDiagnostics, IIS-HttpLogging, IIS-Security, IIS-RequestFiltering, IIS-Performance, IIS-WebServerManagementTools, IIS-ManagementConsole, IIS-StaticContent, IIS-DefaultDocument, IIS-DirectoryBrowsing

# Reiniciar el servidor después de la instalación
Restart-Computer
```

---

## 📁 PASO 3: TRANSFERIR ARCHIVOS AL SERVIDOR

### Opción A: Usar RDP con Copia/Pega
1. Conectarse al servidor via RDP
2. Habilitar compartir clipboard en la conexión RDP
3. Copiar la carpeta `out/` desde tu máquina local
4. Pegar en el servidor en `C:\inetpub\wwwroot\diris-lima-norte\`

### Opción B: Usar WinSCP/FileZilla
1. Configurar conexión SFTP/FTP al servidor
2. Subir la carpeta `out/` completa
3. Subir también el archivo `web.config`

### Opción C: Usar PowerShell con carpetas compartidas
```powershell
# En el servidor, crear carpeta destino
New-Item -Path "C:\inetpub\wwwroot\diris-lima-norte" -ItemType Directory -Force

# Copiar archivos desde ubicación compartida
Copy-Item -Path "\\tu-maquina\shared\out\*" -Destination "C:\inetpub\wwwroot\diris-lima-norte\" -Recurse -Force
```

---

## 🛠️ PASO 4: CONFIGURAR IIS EN EL SERVIDOR

### 4.1 Abrir IIS Manager
```bash
# Ejecutar desde Run (Windows + R)
inetmgr
```

### 4.2 Crear Application Pool
1. En IIS Manager, clic derecho en **"Application Pools"**
2. Seleccionar **"Add Application Pool"**
3. Configurar:
   - **Name:** `DirisLimaNorte`
   - **.NET CLR Version:** `No Managed Code`
   - **Managed Pipeline Mode:** `Integrated`
4. Clic **OK**

### 4.3 Configurar Application Pool
1. Clic derecho en el pool creado → **"Advanced Settings"**
2. Configurar:
   - **Process Model → Identity:** `ApplicationPoolIdentity`
   - **Process Model → Idle Time-out:** `20` (minutos)
   - **Recycling → Regular Time Interval:** `1740` (minutos)

### 4.4 Crear Sitio Web
1. Clic derecho en **"Sites"** → **"Add Website"**
2. Configurar:
   - **Site name:** `DIRIS Lima Norte`
   - **Application pool:** `DirisLimaNorte`
   - **Physical path:** `C:\inetpub\wwwroot\diris-lima-norte`
   - **Binding Type:** `http`
   - **IP address:** `All Unassigned`
   - **Port:** `80` (o puerto deseado)
   - **Host name:** (opcional) `diris.tudominio.com`

### 4.5 Configurar permisos de carpeta
```powershell
# Dar permisos al Application Pool Identity
icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS AppPool\DirisLimaNorte:(OI)(CI)F" /T

# Dar permisos a IIS_IUSRS
icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS_IUSRS:(OI)(CI)R" /T
```

---

## 🔒 PASO 5: CONFIGURAR FIREWALL DEL SERVIDOR

### 5.1 Permitir tráfico HTTP/HTTPS
```powershell
# Permitir HTTP (puerto 80)
New-NetFirewallRule -DisplayName "Allow HTTP Inbound" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

# Permitir HTTPS (puerto 443) si usas SSL
New-NetFirewallRule -DisplayName "Allow HTTPS Inbound" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

# Verificar reglas
Get-NetFirewallRule -DisplayName "*HTTP*"
```

### 5.2 Configurar Windows Defender (si está activo)
```powershell
# Agregar exclusión para la carpeta web
Add-MpPreference -ExclusionPath "C:\inetpub\wwwroot\diris-lima-norte"
```

---

## 🌐 PASO 6: CONFIGURAR DNS Y DOMINIO (OPCIONAL)

### 6.1 Si tienes un dominio propio:
1. En tu proveedor de DNS, crear un registro A:
   - **Name:** `diris` (o subdominio deseado)
   - **Type:** `A`
   - **Value:** `[IP-publica-del-servidor]`

### 6.2 Configurar SSL Certificate (OPCIONAL):
```powershell
# Instalar Let's Encrypt para IIS (win-acme)
# Descargar desde: https://github.com/win-acme/win-acme
# Ejecutar setup automático
```

---

## 🧪 PASO 7: PROBAR LA INSTALACIÓN

### 7.1 Verificar en el servidor local
```bash
# En el servidor, abrir navegador y ir a:
http://localhost
# o
http://localhost:80
```

### 7.2 Verificar desde internet
```bash
# Desde tu máquina local:
http://[IP-publica-del-servidor]
# o si configuraste dominio:
http://diris.tudominio.com
```

### 7.3 Verificar logs de IIS
```powershell
# Ver logs de IIS
Get-Content "C:\inetpub\logs\LogFiles\W3SVC1\*.log" | Select-Object -Last 20
```

---

## 🚨 SOLUCIÓN DE PROBLEMAS COMUNES

### Error 403 - Forbidden
```powershell
# Verificar permisos
icacls "C:\inetpub\wwwroot\diris-lima-norte"

# Resetear permisos
icacls "C:\inetpub\wwwroot\diris-lima-norte" /reset /T
icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS AppPool\DirisLimaNorte:(OI)(CI)F" /T
```

### Error 404 - Rutas no encontradas
1. Verificar que existe `web.config` en la carpeta raíz
2. Verificar configuración de URL Rewrite en `web.config`

### Error 500 - Internal Server Error
```powershell
# Habilitar mensajes de error detallados
# En web.config, agregar:
<system.web>
    <customErrors mode="Off"/>
    <compilation debug="true" tempDirectory="~/App_Data/Temp/"/>
</system.web>
```

### El sitio no es accesible desde internet
1. Verificar firewall del servidor
2. Verificar router/firewall de red
3. Verificar que el puerto está abierto:
```powershell
# Probar conectividad al puerto
Test-NetConnection -ComputerName "localhost" -Port 80
```

---

## 🔄 PASO 8: AUTOMATIZAR FUTURAS ACTUALIZACIONES

### 8.1 Script de despliegue automático
Crear archivo `deploy-remote.bat` en tu máquina local:

```batch
@echo off
echo ========================================
echo    DESPLIEGUE AUTOMATICO A SERVIDOR REMOTO
echo ========================================

REM Configurar variables
set SERVER_IP=192.168.1.100
set SERVER_USER=Administrator
set SERVER_PASS=TuPassword
set REMOTE_PATH=C:\inetpub\wwwroot\diris-lima-norte

echo [1/4] Generando build...
call npm run build

echo [2/4] Comprimiendo archivos...
powershell Compress-Archive -Path "out\*" -DestinationPath "deploy.zip" -Force

echo [3/4] Subiendo al servidor...
scp deploy.zip %SERVER_USER%@%SERVER_IP%:%REMOTE_PATH%

echo [4/4] Descomprimiendo en servidor...
ssh %SERVER_USER%@%SERVER_IP% "cd %REMOTE_PATH% && powershell Expand-Archive -Path deploy.zip -DestinationPath . -Force"

echo ¡Despliegue completado!
pause
```

### 8.2 PowerShell script para el servidor
Crear `update-site.ps1` en el servidor:

```powershell
param(
    [string]$SourcePath = "C:\temp\deploy",
    [string]$TargetPath = "C:\inetpub\wwwroot\diris-lima-norte"
)

Write-Host "Iniciando actualización del sitio..." -ForegroundColor Green

# Detener Application Pool
Import-Module WebAdministration
Stop-WebAppPool -Name "DirisLimaNorte"

# Hacer backup
$BackupPath = "C:\backups\diris-" + (Get-Date -Format "yyyyMMdd-HHmmss")
Copy-Item -Path $TargetPath -Destination $BackupPath -Recurse

# Copiar nuevos archivos
Remove-Item -Path "$TargetPath\*" -Recurse -Force
Copy-Item -Path "$SourcePath\*" -Destination $TargetPath -Recurse

# Iniciar Application Pool
Start-WebAppPool -Name "DirisLimaNorte"

Write-Host "Actualización completada!" -ForegroundColor Green
```

---

## 📊 MONITOREO Y MANTENIMIENTO

### Verificar estado del sitio
```powershell
# Verificar Application Pool
Get-IISAppPool -Name "DirisLimaNorte"

# Verificar sitio web
Get-IISSite -Name "DIRIS Lima Norte"

# Verificar logs
Get-EventLog -LogName System -Source "IIS*" -Newest 10
```

### Configurar monitoreo automático
```powershell
# Script para verificar estado cada 5 minutos
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-File "C:\scripts\check-site.ps1"'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Monitor DIRIS Site"
```

---

## ✅ CHECKLIST FINAL

- [ ] Build generado correctamente (`out/` folder)
- [ ] Archivos transferidos al servidor
- [ ] IIS instalado y configurado
- [ ] Application Pool creado y configurado
- [ ] Sitio web creado en IIS
- [ ] Permisos de carpeta configurados
- [ ] Firewall configurado
- [ ] Sitio accesible desde localhost en el servidor
- [ ] Sitio accesible desde internet
- [ ] DNS configurado (si aplica)
- [ ] SSL configurado (si aplica)
- [ ] Monitoring configurado

---

## 📞 CONTACTO Y SOPORTE

Si encuentras problemas durante el despliegue:

1. **Verificar logs de IIS:** `C:\inetpub\logs\LogFiles\`
2. **Verificar Event Viewer:** Windows Logs → Application
3. **Verificar permisos de carpeta**
4. **Verificar firewall y conectividad**

**¡Tu aplicación DIRIS Lima Norte estará lista para servir a la comunidad! 🏥✨**
