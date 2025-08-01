# 🚀 Despliegue Rápido - IIS Windows Server Remoto

## 📋 Resumen Ejecutivo

Esta guía te permitirá desplegar la Landing Page de **DIRIS Lima Norte** en un servidor Windows Server remoto con IIS en menos de 15 minutos.

## ⚡ Despliegue Rápido (Método Recomendado)

### Paso 1: Preparar Configuración
```powershell
# 1. Copia el archivo de configuración
copy config.template.ps1 config.ps1

# 2. Edita config.ps1 con los datos de tu servidor
notepad config.ps1
```

### Paso 2: Ejecutar Despliegue Automático
```batch
# Método A: Script Batch (Fácil)
deploy-remote.bat

# Método B: PowerShell (Avanzado)
powershell -ExecutionPolicy Bypass -File "scripts\deploy-to-remote-iis.ps1" -ServerIP "192.168.1.100" -Username "Administrator" -Password "TuPassword"
```

### Paso 3: Verificar
- Abrir navegador: `http://[IP-del-servidor]`
- Verificar que el sitio carga correctamente
- ✅ ¡Listo!

---

## 🔧 Requisitos Previos

### En tu Máquina (Desarrollo)
- ✅ Windows 10/11 o Windows Server
- ✅ Node.js 18+ ([Descargar](https://nodejs.org))
- ✅ PowerShell 5.1+ (incluido en Windows)
- ✅ Acceso RDP al servidor remoto

### En el Servidor Remoto
- ✅ Windows Server 2016+ o Windows 10/11
- ✅ IIS instalado y configurado
- ✅ PowerShell Remoting habilitado
- ✅ Firewall configurado (puertos 80/443)

---

## 🛠️ Configuración Inicial del Servidor (Una sola vez)

### 1. Instalar IIS en el Servidor
```powershell
# Conectarse al servidor vía RDP y ejecutar:
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpRedirect, IIS-ApplicationDevelopment, IIS-HealthAndDiagnostics, IIS-HttpLogging, IIS-Security, IIS-RequestFiltering, IIS-Performance, IIS-WebServerManagementTools, IIS-ManagementConsole, IIS-StaticContent, IIS-DefaultDocument, IIS-DirectoryBrowsing
```

### 2. Habilitar PowerShell Remoting
```powershell
# En el servidor, ejecutar como Administrador:
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Restart-Service WinRM
```

### 3. Configurar Firewall
```powershell
# Permitir tráfico web:
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
New-NetFirewallRule -DisplayName "Allow PowerShell Remoting" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
```

---

## 📊 Scripts Disponibles

| Script | Descripción | Uso |
|--------|-------------|-----|
| `deploy-remote.bat` | Despliegue interactivo fácil | Doble clic o `.\deploy-remote.bat` |
| `scripts\deploy-to-remote-iis.ps1` | Despliegue PowerShell avanzado | `.\scripts\deploy-to-remote-iis.ps1 -ServerIP "..." -Username "..." -Password "..."` |
| `config.template.ps1` | Plantilla de configuración | Copiar a `config.ps1` y personalizar |

---

## 🔍 Verificación Post-Despliegue

### Checklist Automático
Los scripts incluyen verificaciones automáticas:
- ✅ Conectividad al servidor
- ✅ Transferencia de archivos exitosa
- ✅ Configuración IIS correcta
- ✅ Application Pool iniciado
- ✅ Sitio web funcionando
- ✅ Respuesta HTTP 200

### Verificación Manual
1. **En el servidor:** Abrir `http://localhost`
2. **Desde internet:** Abrir `http://[IP-publica-servidor]`
3. **IIS Manager:** Verificar sitio "DIRIS Lima Norte" está iniciado
4. **Logs:** Revisar `C:\inetpub\logs\LogFiles\W3SVC1\`

---

## 🚨 Solución de Problemas

### Error: "No se puede conectar al servidor"
```powershell
# Verificar conectividad:
Test-Connection -ComputerName [IP-servidor] -Count 4
ping [IP-servidor]

# Verificar PowerShell Remoting:
Test-WSMan -ComputerName [IP-servidor]
```

### Error: "Credenciales inválidas"
- Verificar usuario/contraseña
- Usar formato: `Servidor\Usuario` o `Usuario@dominio.com`
- Verificar que el usuario tenga permisos de administrador

### Error: "IIS no responde"
```powershell
# En el servidor, verificar servicios:
Get-Service -Name W3SVC
Get-Service -Name WAS

# Reiniciar IIS:
iisreset
```

### Error 403 - Forbidden
```powershell
# En el servidor, configurar permisos:
icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS AppPool\DirisLimaNorte:(OI)(CI)F" /T
icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS_IUSRS:(OI)(CI)R" /T
```

---

## 🔄 Actualizaciones Futuras

### Despliegue Rápido de Actualizaciones
```batch
# Solo ejecutar cuando tengas cambios:
deploy-remote.bat
```
El script automáticamente:
1. Crea backup del sitio actual
2. Genera nuevo build
3. Actualiza archivos en el servidor
4. Reinicia servicios si es necesario

### Rollback a Versión Anterior
```powershell
# En el servidor, si algo sale mal:
$backupPath = "C:\backups\diris-[fecha-hora]"
$sitePath = "C:\inetpub\wwwroot\diris-lima-norte"

Stop-WebAppPool -Name "DirisLimaNorte"
Remove-Item -Path "$sitePath\*" -Recurse -Force
Copy-Item -Path "$backupPath\*" -Destination $sitePath -Recurse
Start-WebAppPool -Name "DirisLimaNorte"
```

---

## 📈 Monitoreo y Mantenimiento

### Script de Monitoreo Automático
```powershell
# Crear tarea programada para verificar sitio cada 5 minutos:
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-File "C:\scripts\monitor-diris.ps1"'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Monitor DIRIS Site" -User "System"
```

### Logs Importantes
- **IIS Logs:** `C:\inetpub\logs\LogFiles\W3SVC1\`
- **Windows Event Log:** `Event Viewer > Windows Logs > Application`
- **Application Pool Logs:** `Event Viewer > Applications and Services Logs > Microsoft > Windows > IIS-W3SVC`

---

## 🌐 Configuración de Dominio (Opcional)

### Paso 1: Configurar DNS
En tu proveedor de dominio, crear registro A:
- **Nombre:** `diris` (o subdominio deseado)
- **Tipo:** `A`
- **Valor:** `[IP-publica-del-servidor]`

### Paso 2: Configurar IIS para el dominio
```powershell
# En el servidor:
Set-WebBinding -Name "DIRIS Lima Norte" -BindingInformation "*:80:" -PropertyName HostHeader -Value "diris.tudominio.com"
```

### Paso 3: Configurar SSL (Recomendado)
```powershell
# Instalar Let's Encrypt para IIS:
# Descargar: https://github.com/win-acme/win-acme
# Ejecutar setup automático para certificado gratuito
```

---

## 📞 Soporte

### Documentación Adicional
- 📖 [Guía Completa](docs/guia-despliegue-iis-servidor-remoto.md)
- 📖 [Guía IIS Local](docs/guia-despliegue-iis.md)
- 🔧 [Configuración Avanzada](config.template.ps1)

### Contacto
Si encuentras problemas durante el despliegue:
1. Revisar logs de IIS y Windows Event Viewer
2. Verificar configuración de firewall y permisos
3. Consultar la documentación completa
4. Contactar al equipo de desarrollo

---

## ✅ Checklist Final

Antes de considerar el despliegue completo:

- [ ] ✅ Sitio accesible desde el servidor local (`http://localhost`)
- [ ] ✅ Sitio accesible desde internet (`http://[IP-servidor]`)
- [ ] ✅ Application Pool "DirisLimaNorte" está iniciado
- [ ] ✅ Sitio web "DIRIS Lima Norte" está iniciado
- [ ] ✅ Permisos de carpeta configurados correctamente
- [ ] ✅ Firewall configurado para puertos 80/443
- [ ] ✅ Backup automático configurado
- [ ] ✅ Monitoreo configurado (opcional)
- [ ] ✅ Dominio configurado (opcional)
- [ ] ✅ SSL configurado (opcional)

**🎉 ¡Tu aplicación DIRIS Lima Norte está lista para servir a la comunidad!**
