# 🚀 Guía de Deployment para IIS en Servidor Remoto

## 📁 **CARPETA A COPIAR: `deployment-iis`**

La carpeta **`deployment-iis`** contiene todos los archivos necesarios para el deployment en IIS.

### 📊 **Información de la Carpeta:**
- **Ubicación**: `d:\proyecto\deployment-iis\`
- **Total de archivos**: 64 archivos
- **Tamaño total**: 2.12 MB
- **Contenido**: Sitio web estático completo + configuración IIS

## 📋 **Contenido de deployment-iis:**

### 🌐 **Archivos Web Principales:**
- `index.html` - Página principal del sitio
- `404.html` - Página de error 404
- `site.webmanifest` - Configuración PWA

### 🖼️ **Assets Estáticos:**
- `images/` - Todas las imágenes del sitio
- `_next/` - Archivos CSS, JS y otros assets de Next.js
- `favicon.ico`, `apple-touch-icon.png`, etc. - Iconos

### ⚙️ **Configuración IIS:**
- `web.config` - Configuración principal para IIS
- `web.config.iis` - Configuración específica adicional
- `.nojekyll` - Archivo para compatibilidad

## 🖥️ **Pasos para Deployment en Servidor Remoto:**

### 1️⃣ **Preparar Archivos (Ya Completado)**
```powershell
# Ya ejecutado - carpeta deployment-iis lista
npm run build
# Archivos copiados a deployment-iis
```

### 2️⃣ **Copiar al Servidor Remoto**
1. **Comprimir la carpeta** (opcional para transferencia más rápida):
   - Hacer clic derecho en `deployment-iis`
   - Seleccionar "Enviar a > Carpeta comprimida"

2. **Conectar por Escritorio Remoto** al servidor IIS

3. **Transferir archivos** usando uno de estos métodos:
   - **Copiar/Pegar**: A través de escritorio remoto
   - **Unidad compartida**: Si está configurada
   - **FTP/SFTP**: Si está disponible

### 3️⃣ **Configurar en IIS del Servidor Remoto**

#### **Opción A: Default Web Site (Puerto 80)**
1. Abrir **IIS Manager**
2. Expandir servidor → Sites → Default Web Site
3. **Eliminar contenido actual** de `C:\inetpub\wwwroot\`
4. **Copiar todo el contenido** de `deployment-iis` a `C:\inetpub\wwwroot\`
5. Verificar que `web.config` esté en la raíz

#### **Opción B: Nuevo Sitio Web**
1. En IIS Manager, clic derecho en **Sites**
2. Seleccionar **Add Website**
3. Configurar:
   - **Site name**: `DIRIS-Lima-Norte`
   - **Physical path**: Ruta donde copiaste `deployment-iis`
   - **Port**: 80 (o el puerto deseado)
4. Hacer clic **OK**

### 4️⃣ **Verificar Configuración**
1. **Application Pool**: Debe usar **.NET CLR Version** = "No Managed Code"
2. **Authentication**: Anonymous Authentication habilitada
3. **Default Document**: Verificar que `index.html` esté listado
4. **Static Content**: Verificar que esté habilitado

### 5️⃣ **Solucionar Problema de Tildes y Ñ**
1. **Opción A - Script Automático** (Recomendado):
   - Ejecutar PowerShell como **Administrador**
   - Navegar a la carpeta del sitio
   - Ejecutar: `.\configure-utf8-iis.ps1`

2. **Opción B - Manual**:
   - Renombrar `web.config.utf8` a `web.config`
   - En IIS Manager → Default Web Site → Features View
   - Abrir **MIME Types** → Verificar que HTML, CSS, JS tengan "; charset=utf-8"
   - Ejecutar en PowerShell: `iisreset`

### 6️⃣ **Probar el Sitio**
- Abrir navegador en el servidor
- Ir a `http://localhost` (o puerto configurado)
- Verificar que las tildes y Ñ se muestren correctamente

## 🔧 **Configuraciones Importantes:**

### **Problema con Tildes y Ñ - SOLUCIONADO:**
Se han agregado archivos específicos para solucionar problemas de caracteres especiales:

- `web.config` - Configuración principal con UTF-8
- `web.config.utf8` - Configuración específica para caracteres especiales
- `configure-utf8-iis.ps1` - Script automatizado para configurar UTF-8 en IIS

### **web.config Principal:**
- Redirecciones para SPA (Single Page Application)
- Configuración de tipos MIME con UTF-8
- Reglas de URL rewriting
- Compresión GZIP
- **Headers UTF-8 para tildes y Ñ**

### **Permisos Requeridos:**
- **IIS_IUSRS**: Lectura y ejecución en la carpeta del sitio
- **Application Pool Identity**: Acceso a la carpeta

## ✅ **Verificación Post-Deployment:**

1. **Página principal** carga correctamente
2. **Imágenes** se muestran sin errores
3. **CSS y JavaScript** se aplican correctamente
4. **Navegación** funciona entre secciones
5. **Enlaces externos** funcionan (redes sociales, etc.)
6. **🆕 Tildes y Ñ** se muestran correctamente (Ñiños, dirección, etc.)

## 📞 **URLs de Prueba:**
- Página principal: `http://[IP-SERVIDOR]/`
- Imagen de prueba: `http://[IP-SERVIDOR]/images/backgrounds/family-hero.jpg`
- CSS: `http://[IP-SERVIDOR]/_next/static/css/[archivo].css`

---

**🎯 RESUMEN: Copiar carpeta `deployment-iis` completa al servidor IIS y configurar como sitio web.**
