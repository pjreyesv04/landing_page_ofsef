# 🌐 Guía Paso a Paso: Publicar en IIS Default Web Site (Puerto 80)

## 📋 INTRODUCCIÓN

Esta guía te mostrará cómo publicar tu proyecto **DIRIS Lima Norte** en IIS utilizando el **Default Web Site** existente en el **puerto 80**, creando una aplicación virtual dentro del sitio principal.

---

## 🎯 PASO 1: PREPARAR LOS ARCHIVOS

### 1.1 Generar el Build de Producción

Abre **PowerShell** en la carpeta de tu proyecto y ejecuta:

```powershell
# Instalar dependencias (si no lo has hecho)
npm install

# Generar build de producción
npm run build
```

Esto creará la carpeta `out/` con todos los archivos necesarios.

### 1.2 Archivos que DEBES tener en la carpeta final

Después del build, verifica que tengas estos archivos en la carpeta `out/`:

```
out/
├── index.html                 ← Página principal
├── _next/
│   ├── static/
│   │   ├── css/              ← Archivos CSS
│   │   ├── js/               ← Archivos JavaScript
│   │   └── media/            ← Imágenes y recursos
├── favicon.ico               ← Icono del sitio
├── images/                   ← Carpeta de imágenes
├── 404.html                  ← Página de error (si existe)
└── otros archivos HTML
```

### 1.3 Copiar web.config (IMPORTANTE)

**OBLIGATORIO:** Copia el archivo `web.config` a la carpeta `out/`:

```powershell
copy web.config out/web.config
```

El archivo `web.config` es **ESENCIAL** para que IIS funcione correctamente con tu aplicación Next.js.

---

## 🖥️ PASO 2: CONFIGURAR IIS MANAGER

### 2.1 Abrir IIS Manager

1. Presiona `Windows + R`
2. Escribe: `inetmgr`
3. Presiona `Enter`
4. Se abrirá **Internet Information Services (IIS) Manager**

### 2.2 Ubicar Default Web Site

En el panel izquierdo:
1. Expande tu servidor (nombre de tu computadora)
2. Expande **"Sites"**
3. Verás **"Default Web Site"** - este es tu sitio principal

### 2.3 Verificar que Default Web Site esté funcionando

1. Haz clic derecho en **"Default Web Site"**
2. Si ves **"Start"**, haz clic para iniciarlo
3. Si ves **"Stop"**, significa que ya está ejecutándose ✅

---

## 📁 PASO 3: CREAR CARPETA EN WWWROOT

### 3.1 Ubicar la carpeta wwwroot

La ruta típica es: `C:\inetpub\wwwroot\`

### 3.2 Crear carpeta para tu aplicación

1. Abre **Explorador de Windows**
2. Navega a: `C:\inetpub\wwwroot\`
3. Crea una nueva carpeta llamada: **`diris-lima-norte`**

**Ruta final:** `C:\inetpub\wwwroot\diris-lima-norte\`

### 3.3 Copiar archivos del build

1. Abre la carpeta `out/` de tu proyecto
2. **Selecciona TODO el contenido** de la carpeta `out/`
3. **Copia todo** a: `C:\inetpub\wwwroot\diris-lima-norte\`

**Resultado esperado:**
```
C:\inetpub\wwwroot\diris-lima-norte\
├── index.html
├── web.config                 ← IMPORTANTE
├── _next/
├── favicon.ico
├── images/
└── otros archivos...
```

---

## ⚙️ PASO 4: CONFIGURAR APPLICATION POOL

### 4.1 Crear Application Pool

1. En **IIS Manager**, en el panel izquierdo, haz clic en **"Application Pools"**
2. En el panel derecho, haz clic en **"Add Application Pool..."**
3. Configura:
   - **Name:** `DirisLimaNorte`
   - **.NET CLR version:** `No Managed Code` ⚠️ **IMPORTANTE**
   - **Managed pipeline mode:** `Integrated`
4. Haz clic **"OK"**

### 4.2 Configurar Application Pool

1. Haz clic derecho en **"DirisLimaNorte"**
2. Selecciona **"Advanced Settings..."**
3. Configura:
   - **Process Model → Identity:** `ApplicationPoolIdentity`
   - **Process Model → Idle Time-out (minutes):** `20`
   - **Recycling → Regular Time Interval (minutes):** `1740`
4. Haz clic **"OK"**

---

## 🌐 PASO 5: CREAR APLICACIÓN VIRTUAL

### 5.1 Crear la aplicación dentro de Default Web Site

1. En **IIS Manager**, expande **"Sites"**
2. Haz clic derecho en **"Default Web Site"**
3. Selecciona **"Add Application..."**

### 5.2 Configurar la aplicación

**Configuración:**
- **Alias:** `diris-lima-norte` ← Este será tu URL
- **Application pool:** `DirisLimaNorte` (selecciona el que creaste)
- **Physical path:** `C:\inetpub\wwwroot\diris-lima-norte`

**⚠️ IMPORTANTE:** Asegúrate de hacer clic en el botón **"..."** para seleccionar la carpeta correcta.

4. Haz clic **"OK"**

### 5.3 Verificar la estructura resultante

En IIS Manager deberías ver:
```
📁 Sites
  └── 🌐 Default Web Site
      └── 📱 diris-lima-norte (Application)
```

---

## 🔐 PASO 6: CONFIGURAR PERMISOS

### 6.1 Configurar permisos de carpeta

1. Abre **Explorador de Windows**
2. Navega a: `C:\inetpub\wwwroot\diris-lima-norte`
3. Haz clic derecho en la carpeta → **"Properties"**
4. Ve a la pestaña **"Security"**
5. Haz clic en **"Edit..."**

### 6.2 Agregar permisos necesarios

**Agregar usuario IIS_IUSRS:**
1. Haz clic **"Add..."**
2. Escribe: `IIS_IUSRS`
3. Haz clic **"Check Names"** → **"OK"**
4. Selecciona **"Read & execute"** y **"Read"**
5. Haz clic **"OK"**

**Agregar Application Pool Identity:**
1. Haz clic **"Add..."**
2. Escribe: `IIS AppPool\DirisLimaNorte`
3. Haz clic **"Check Names"** → **"OK"**
4. Selecciona **"Read & execute"** y **"Read"**
5. Haz clic **"OK"**

---

## 🚀 PASO 7: INICIAR LA APLICACIÓN

### 7.1 Iniciar Application Pool

1. En **IIS Manager**, ve a **"Application Pools"**
2. Haz clic derecho en **"DirisLimaNorte"**
3. Selecciona **"Start"** (si no está ya iniciado)

### 7.2 Verificar Default Web Site

1. Ve a **"Sites"**
2. Verifica que **"Default Web Site"** esté **"Started"**
3. Si no, haz clic derecho → **"Start"**

---

## 🧪 PASO 8: PROBAR LA APLICACIÓN

### 8.1 Probar desde el servidor local

Abre tu navegador y ve a:
```
http://localhost/diris-lima-norte
```

**✅ Deberías ver tu página de DIRIS Lima Norte cargando correctamente.**

### 8.2 Probar desde otra computadora en la red

Desde otra computadora, abre el navegador y ve a:
```
http://[IP-DE-TU-SERVIDOR]/diris-lima-norte
```

**Ejemplo:** `http://192.168.1.100/diris-lima-norte`

---

## 🔍 VERIFICACIÓN COMPLETA

### ✅ Checklist de Verificación

Marca cada elemento cuando esté completo:

- [ ] Carpeta `out/` generada con `npm run build`
- [ ] Archivo `web.config` copiado a la carpeta `out/`
- [ ] Carpeta `C:\inetpub\wwwroot\diris-lima-norte\` creada
- [ ] Todos los archivos de `out/` copiados a wwwroot
- [ ] Application Pool "DirisLimaNorte" creado
- [ ] Application Pool configurado con "No Managed Code"
- [ ] Aplicación virtual "diris-lima-norte" creada en Default Web Site
- [ ] Permisos configurados (IIS_IUSRS y Application Pool Identity)
- [ ] Application Pool iniciado (Started)
- [ ] Default Web Site iniciado (Started)
- [ ] Página carga en `http://localhost/diris-lima-norte`
- [ ] Página accesible desde otras computadoras

### 📊 Estado Esperado en IIS Manager

**Application Pools:**
- DirisLimaNorte: **Started** ✅

**Sites:**
- Default Web Site: **Started** ✅
  - diris-lima-norte: (Application) ✅

---

## 🚨 SOLUCIÓN DE PROBLEMAS COMUNES

### Error 403 - Forbidden

**Causa:** Permisos incorrectos
**Solución:**
1. Verificar permisos de carpeta (Paso 6)
2. Asegurar que `IIS_IUSRS` tiene permisos de lectura
3. Verificar que el Application Pool Identity tiene permisos

### Error 404 - Page Not Found

**Causa:** Ruta incorrecta o aplicación no configurada
**Solución:**
1. Verificar que la URL sea: `http://localhost/diris-lima-norte`
2. Verificar que la aplicación virtual esté creada correctamente
3. Verificar que el archivo `index.html` esté en la carpeta

### Error 500 - Internal Server Error

**Causa:** Problema con `web.config` o configuración de Application Pool
**Solución:**
1. Verificar que `web.config` esté en la carpeta raíz
2. Verificar que Application Pool esté configurado con "No Managed Code"
3. Revisar Event Viewer para detalles del error

### La página carga pero sin estilos CSS/JS

**Causa:** Rutas incorrectas o archivos faltantes
**Solución:**
1. Verificar que la carpeta `_next/` esté completa
2. Verificar que `web.config` esté configurado correctamente
3. Verificar que no haya errores en la consola del navegador (F12)

### No puedo acceder desde otras computadoras

**Causa:** Firewall bloqueando el puerto 80
**Solución:**
```powershell
# Ejecutar como Administrador
New-NetFirewallRule -DisplayName "Allow HTTP Port 80" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
```

---

## 📁 ESTRUCTURA FINAL ESPERADA

### En el servidor de archivos:
```
C:\inetpub\wwwroot\diris-lima-norte\
├── index.html                    ← Página principal
├── web.config                    ← Configuración IIS (OBLIGATORIO)
├── favicon.ico                   ← Icono del sitio
├── _next/                        ← Archivos de Next.js
│   ├── static/
│   │   ├── css/
│   │   ├── js/
│   │   └── media/
├── images/                       ← Imágenes del proyecto
│   ├── announcements/
│   └── backgrounds/
└── [otros archivos HTML]
```

### En IIS Manager:
```
🖥️ Tu Servidor
├── 📁 Application Pools
│   ├── DefaultAppPool
│   └── DirisLimaNorte ✅ (Started, No Managed Code)
└── 📁 Sites
    └── 🌐 Default Web Site ✅ (Started, Port 80)
        └── 📱 diris-lima-norte ✅ (Application)
```

---

## 🎯 URLs FINALES

### Acceso Local (en el servidor):
```
http://localhost/diris-lima-norte
```

### Acceso Remoto (desde otra computadora):
```
http://[IP-DEL-SERVIDOR]/diris-lima-norte
```

**Ejemplo:** `http://192.168.1.100/diris-lima-norte`

---

## ✅ CONFIRMACIÓN FINAL

Tu aplicación **DIRIS Lima Norte** estará disponible en:

🌐 **URL Principal:** `http://localhost/diris-lima-norte`
📱 **Puerto:** 80 (Default Web Site)
📁 **Ubicación:** Default Web Site > diris-lima-norte (Application)
⚙️ **Application Pool:** DirisLimaNorte (No Managed Code)

**¡Tu landing page de DIRIS Lima Norte está lista para servir a la comunidad! 🏥✨**
