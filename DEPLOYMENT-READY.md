# 📦 PAQUETE DE DEPLOYMENT LISTO

## ✅ **CARPETA PREPARADA: `deployment-iis`**

### 📊 **Información del Paquete:**
- **📁 Ubicación**: `d:\proyecto\deployment-iis\`
- **📋 Total archivos**: 51+ archivos
- **📏 Tamaño total**: 2.12 MB
- **🎯 Estado**: LISTO PARA COPIAR AL SERVIDOR IIS
- **🆕 UTF-8**: Configuración incluida para tildes y Ñ

### 🗂️ **Estructura del Paquete:**
```
deployment-iis/
├── index.html                 # Página principal
├── 404.html                   # Página de error
├── web.config                 # Configuración IIS principal
├── web.config.iis            # Configuración IIS adicional
├── web.config.utf8           # Configuración UTF-8 para tildes/Ñ
├── configure-utf8-iis.ps1    # Script automático UTF-8
├── test-utf8.html           # Página de prueba caracteres especiales
├── .nojekyll                 # Archivo de compatibilidad
├── site.webmanifest          # Configuración PWA
├── favicon.ico + iconos      # Iconos del sitio
├── images/                   # Todas las imágenes
│   ├── announcements/        # Imágenes de anuncios
│   └── backgrounds/          # Imágenes de fondo
├── _next/                    # Assets de Next.js
│   ├── static/css/           # Archivos CSS
│   └── static/chunks/        # JavaScript chunks
└── 404/                      # Carpeta de error 404
```

## 🚀 **INSTRUCCIONES RÁPIDAS:**

### 1. **Para Copiar al Servidor:**
1. Abrir **Escritorio Remoto** al servidor IIS
2. Copiar toda la carpeta `deployment-iis` al servidor
3. Pegar contenido en `C:\inetpub\wwwroot\` (Default Web Site)

### 2. **Verificar en IIS:**
- Verificar que `web.config` esté en la raíz
- Application Pool en "No Managed Code"
- Default Document incluye `index.html`

### 3. **Probar:**
- Navegar a `http://localhost` en el servidor
- Verificar que la página carga correctamente
- **🆕 Probar UTF-8**: Ir a `http://localhost/test-utf8.html`
- Verificar que tildes y Ñ se ven correctamente

### 4. **Si hay problemas con tildes/Ñ:**
- Ejecutar como Administrador: `.\configure-utf8-iis.ps1`
- O renombrar `web.config.utf8` a `web.config`
- Ejecutar: `iisreset`

---

**🎯 El paquete está listo para deployment inmediato en IIS Windows Server.**
