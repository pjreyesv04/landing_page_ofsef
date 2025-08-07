# 🔄 ESTRATEGIA DE SINCRONIZACIÓN - 4 ENTORNOS

## 📍 **ENTORNOS IDENTIFICADOS:**

### 1️⃣ **MÁQUINA LOCAL** (Desarrollo)
- **📁 Ubicación**: `d:\proyecto\`
- **🎯 Propósito**: Desarrollo y modificaciones
- **🌟 Estado**: Archivo original/principal
- **🔧 Comandos**: `npm run dev`, `npm run build`

### 2️⃣ **GITHUB** (Repositorio)
- **📁 Ubicación**: `https://github.com/pjreyesv04/landing_page_ofsef`
- **🎯 Propósito**: Control de versiones y GitHub Pages
- **🌐 URL Pública**: `https://pjreyesv04.github.io/landing_page_ofsef/`
- **🔧 Deploy**: GitHub Actions automático

### 3️⃣ **SERVIDOR IIS - STAGING** (Pruebas)
- **📁 Ubicación**: `C:\inetpub\wwwroot\page_ofseg_dirisln` (Staging)
- **🎯 Propósito**: Ambiente de pruebas
- **🌐 URL**: `http://[IP-SERVIDOR]/page_ofseg_dirisln/`
- **⚠️ Estado**: Para testing antes de producción

### 4️⃣ **SERVIDOR IIS - PRODUCCIÓN** (Público)
- **📁 Ubicación**: `C:\inetpub\wwwroot\page_ofseg_dirisln` (Producción)
- **🎯 Propósito**: Sitio web público oficial
- **🌐 URL**: `http://[IP-SERVIDOR]/page_ofseg_dirisln/`
- **🔒 Estado**: Versión final para usuarios

---

## 🔄 **FLUJO DE SINCRONIZACIÓN PROPUESTO:**

```
[1] LOCAL → [2] GITHUB → [3] STAGING → [4] PRODUCCIÓN
    ↓           ↓           ↓           ↓
  Desarrollo  Git Push   Testing    Go Live
```

### **Proceso Paso a Paso:**

1. **DESARROLLO** → Hacer cambios en máquina local
2. **BUILD** → Generar versión para deployment
3. **GITHUB** → Subir cambios al repositorio
4. **STAGING** → Copiar a ambiente de pruebas
5. **TESTING** → Validar funcionamiento
6. **PRODUCCIÓN** → Promover a ambiente público

---

## 📋 **ARCHIVOS DE CONFIGURACIÓN POR ENTORNO:**

### **LOCAL (Desarrollo):**
- `next.config.ts` - Configuración para desarrollo
- `package.json` - Scripts de build
- `src/` - Código fuente

### **GITHUB (Repositorio):**
- `.github/workflows/` - GitHub Actions
- `next.config.ts` - Con basePath para GitHub Pages
- Build automático en push

### **STAGING (Pruebas IIS):**
- `deployment-iis/` - Archivos estáticos
- `web.config` - Configuración IIS
- `test-utf8.html` - Pruebas UTF-8

### **PRODUCCIÓN (IIS Final):**
- Archivos idénticos a STAGING
- `web.config` optimizado
- Sin archivos de prueba

---

## 🛠️ **COMANDOS DE SINCRONIZACIÓN:**

### **1. LOCAL → GITHUB:**
```bash
# En máquina local
git add .
git commit -m "Actualización [descripción]"
git push origin master
```

### **2. LOCAL → IIS (STAGING/PRODUCCIÓN):**
```bash
# Generar build
npm run build

# Copiar a deployment-iis (ya configurado)
# Transferir vía Remote Desktop al servidor
```

### **3. GITHUB → LOCAL (Sincronizar):**
```bash
# En máquina local
git pull origin master
npm install  # Si hay cambios en package.json
```

---

## 📂 **ESTRUCTURA ORGANIZADA PROPUESTA:**

```
d:\proyecto\
├── src/                     # Código fuente
├── deployment-iis/          # Build para IIS (STAGING/PROD)
├── deployment-github/       # Build para GitHub Pages  
├── scripts/                 # Scripts de deployment
├── docs/                    # Documentación
├── sync/                    # Scripts de sincronización
│   ├── sync-to-github.ps1
│   ├── sync-to-staging.ps1
│   └── sync-to-production.ps1
├── config/                  # Configuraciones por entorno
│   ├── local.config.js
│   ├── github.config.js
│   ├── staging.config.js
│   └── production.config.js
└── README-SYNC.md          # Esta guía
```

---

## ⚡ **PRÓXIMOS PASOS:**

1. **Crear scripts de sincronización automática**
2. **Configurar entornos específicos**
3. **Validar estado actual de cada entorno**
4. **Establecer protocolo de deployment**

¿Quieres que proceda a crear los scripts de sincronización y organización?
