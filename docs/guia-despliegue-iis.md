# 🚀 Guía Completa de Despliegue en IIS Windows Server

## 📋 REQUISITOS PREVIOS

### En el Servidor Windows:
- [x] Windows Server 2016+ o Windows 10/11
- [x] IIS (Internet Information Services) instalado
- [x] Node.js 18+ instalado (para el build)
- [x] Permisos de administrador

### Verificar IIS instalado:
```powershell
Get-WindowsFeature -Name IIS-*
```

### Instalar IIS si no está disponible:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpRedirect, IIS-ApplicationDevelopment, IIS-NetFxExtensibility45, IIS-HealthAndDiagnostics, IIS-HttpLogging, IIS-Security, IIS-RequestFiltering, IIS-Performance, IIS-WebServerManagementTools, IIS-ManagementConsole, IIS-IIS6ManagementCompatibility, IIS-Metabase, IIS-ASPNET45
```

---

## 🛠️ PASO 1: PREPARAR LA APLICACIÓN

### Generar build de producción:
```bash
npm run build
npx next export
```

---

## 🖥️ PASO 2: CONFIGURAR IIS

### A. Crear Sitio Web en IIS Manager:

1. **Abrir IIS Manager** (`inetmgr`)
2. **Clic derecho en "Sites"** → "Add Website"
3. **Configurar:**
   - **Site name:** `DIRIS Lima Norte`
   - **Physical path:** `C:\inetpub\wwwroot\diris-lima-norte`
   - **Port:** `80` (o el puerto deseado)
   - **Host name:** (opcional) `diris-lima-norte.local`

### B. Configurar Application Pool:

1. **En Application Pools**, clic derecho en el pool del sitio
2. **"Advanced Settings"**
3. **Configurar:**
   - **Process Model → Identity:** `ApplicationPoolIdentity`
   - **Process Model → Idle Time-out:** `0` (sin timeout)
   - **.NET CLR Version:** `No Managed Code`

---

## 📁 PASO 3: DESPLEGAR ARCHIVOS

### Opción A: Usando el script automático
```bash
# Ejecutar como administrador
deploy-to-iis.bat
```

### Opción B: Manual

1. **Copiar archivos del build:**
   ```bash
   xcopy "out\*" "C:\inetpub\wwwroot\diris-lima-norte\" /E /I /Y
   ```

2. **Copiar web.config:**
   ```bash
   copy "web.config" "C:\inetpub\wwwroot\diris-lima-norte\"
   ```

3. **Configurar permisos:**
   ```bash
   icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IIS_IUSRS:(OI)(CI)F" /T
   icacls "C:\inetpub\wwwroot\diris-lima-norte" /grant "IUSR:(OI)(CI)F" /T
   ```

---

## 🔧 PASO 4: CONFIGURACIÓN AVANZADA DE IIS

### A. Habilitar Compresión:
1. **IIS Manager** → **Server level** → **Compression**
2. **Habilitar:**
   - ✅ Enable dynamic content compression
   - ✅ Enable static content compression

### B. Configurar MIME Types (si es necesario):
```
.woff2 → font/woff2
.woff  → application/font-woff
.json  → application/json
.webp  → image/webp
```

### C. URL Rewrite Module:
Si no está instalado, descargar de: https://www.iis.net/downloads/microsoft/url-rewrite

---

## 🌐 PASO 5: CONFIGURAR DOMINIO (OPCIONAL)

### Para acceso por dominio:
1. **DNS:** Configurar registro A apuntando al servidor
2. **IIS Manager:** Editar bindings del sitio
3. **Agregar binding:**
   - **Type:** `http` (o `https` con certificado)
   - **Host name:** `tu-dominio.com`

---

## 🔒 PASO 6: CONFIGURAR HTTPS (RECOMENDADO)

### Con certificado SSL:
1. **Instalar certificado** en el servidor
2. **IIS Manager** → **Site** → **Bindings**
3. **Add Binding:**
   - **Type:** `https`
   - **Port:** `443`
   - **SSL Certificate:** [Seleccionar certificado]

---

## ✅ PASO 7: VERIFICACIÓN

### Verificar que el sitio funciona:
- **Local:** `http://localhost/`
- **Red:** `http://[IP-del-servidor]/`
- **Dominio:** `http://tu-dominio.com/`

### Verificar funcionalidades:
- [x] Página principal carga correctamente
- [x] Contador de visitas funciona
- [x] Favicon se muestra correctamente
- [x] Navegación entre secciones
- [x] Formularios (si los hay)

---

## 🛠️ TROUBLESHOOTING

### Error 500.19:
- **Causa:** web.config mal configurado
- **Solución:** Verificar sintaxis XML del web.config

### Error 403:
- **Causa:** Permisos incorrectos
- **Solución:** Verificar permisos IIS_IUSRS e IUSR

### Error 404 en rutas:
- **Causa:** URL Rewrite no configurado
- **Solución:** Instalar URL Rewrite Module

### Contador no funciona:
- **Causa:** localStorage bloqueado
- **Solución:** Verificar configuración de seguridad del navegador

---

## 🔄 ACTUALIZACIÓN DEL SITIO

### Para futuras actualizaciones:
```bash
# 1. Generar nuevo build
npm run build
npx next export

# 2. Ejecutar script de despliegue
deploy-to-iis.bat
```

---

## 📞 CONTACTO Y SOPORTE

- **Desarrollador:** GitHub Copilot
- **Proyecto:** DIRIS Lima Norte Landing Page
- **Fecha:** Julio 2025

---

## 📝 NOTAS IMPORTANTES

1. **Backup:** Siempre respaldar el sitio actual antes de actualizar
2. **Testing:** Probar en un entorno de desarrollo antes de producción
3. **Monitoreo:** Verificar logs de IIS regularmente
4. **Performance:** Considerar CDN para mejor rendimiento
5. **Seguridad:** Mantener certificados SSL actualizados
