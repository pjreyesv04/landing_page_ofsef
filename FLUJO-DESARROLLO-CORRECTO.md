# 🔄 FLUJO DE DESARROLLO CORRECTO
## Local → GitHub → Staging → Producción

## 📍 **ESTADO ACTUAL - PROBLEMA IDENTIFICADO**

**ACTUALMENTE ESTAMOS TRABAJANDO DIRECTAMENTE EN EL SERVIDOR DE STAGING/PRODUCCIÓN**

Esto no es la práctica recomendada. Necesitamos establecer el flujo correcto:

```
🏠 LOCAL (Desarrollo)  →  📚 GITHUB (Repositorio)  →  🧪 STAGING (Pruebas)  →  🚀 PRODUCCIÓN (Live)
```

## 🎯 **FLUJO CORRECTO QUE DEBEMOS IMPLEMENTAR**

### **🏠 AMBIENTE LOCAL (Tu máquina de desarrollo)**
```bash
Ubicación: Tu computadora personal
Propósito: Desarrollo y pruebas locales
URL: http://localhost:3000 (desarrollo) o http://localhost/page_ofseg_dirisln (local IIS)
```

### **📚 GITHUB (Repositorio central)**
```bash
Repositorio: https://github.com/pjreyesv04/landing_page_ofsef
Propósito: Control de versiones y código fuente
Branch: master (principal)
```

### **🧪 STAGING (Servidor de pruebas)**
```bash
Ubicación: C:\inetpub\wwwroot\page_ofseg_dirisln (donde estamos ahora)
Propósito: Pruebas en ambiente similar a producción
URL: http://staging.diris.local/page_ofseg_dirisln/ (o URL de staging)
```

### **🚀 PRODUCCIÓN (Servidor en vivo)**
```bash
Ubicación: Servidor principal de DIRIS
Propósito: Sitio web público
URL: https://oficinaseguros.diris.gob.pe (o URL final)
```

## 🔧 **CONFIGURACIÓN NECESARIA POR AMBIENTE**

### **🏠 LOCAL - next.config.local.ts**
```typescript
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Sin basePath para desarrollo local
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  }
}
```

### **🧪 STAGING - next.config.staging.ts**
```typescript
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  basePath: '/page_ofseg_dirisln',
  assetPrefix: '/page_ofseg_dirisln',
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  }
}
```

### **🚀 PRODUCCIÓN - next.config.production.ts**
```typescript
const nextConfig: NextConfig = {
  output: 'export',
  trailingSlash: true,
  // Configuración específica para producción
  basePath: '', // Sin basePath si está en raíz
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  }
}
```

## 🔄 **PROCESO CORRECTO PASO A PASO**

### **1. 🏠 DESARROLLO LOCAL**
```bash
# En tu máquina local:
git clone https://github.com/pjreyesv04/landing_page_ofsef.git
cd landing_page_ofsef
cp next.config.local.ts next.config.ts
npm install
npm run dev  # Desarrollo en http://localhost:3000
```

### **2. 📚 PUSH A GITHUB**
```bash
# Hacer cambios al código
git add .
git commit -m "feat: nueva funcionalidad"
git push origin master
```

### **3. 🧪 DEPLOY A STAGING**
```bash
# En servidor de staging (donde estamos ahora):
update-from-staging.bat  # Script que usará next.config.staging.ts
```

### **4. 🚀 DEPLOY A PRODUCCIÓN**
```bash
# En servidor de producción:
update-from-production.bat  # Script que usará next.config.production.ts
```

## 📋 **ACCIONES NECESARIAS AHORA**

### **PASO 1: Sincronizar cambios actuales con GitHub**
Todos los cambios y mejoras que hemos hecho necesitan subirse a GitHub:

### **PASO 2: Crear configuraciones por ambiente**
- `next.config.local.ts` (desarrollo)
- `next.config.staging.ts` (staging - actual)
- `next.config.production.ts` (producción)

### **PASO 3: Crear scripts específicos por ambiente**
- `update-from-staging.bat`
- `update-from-production.bat`

### **PASO 4: Establecer ambiente de desarrollo local**
En tu máquina personal para futuras modificaciones

## ⚠️ **SITUACIÓN ACTUAL**

**Estamos trabajando directamente en STAGING**, lo cual no es óptimo pero es funcional.

**¿Qué quieres hacer ahora?**

1. **🔄 Sincronizar todo con GitHub** (subir cambios actuales)
2. **🏗️ Configurar ambiente local** para desarrollo futuro
3. **📁 Crear configuraciones por ambiente**
4. **✅ Mantener el estado actual** y solo usar el flujo simplificado

**Recomendación:** Primero sincronizar con GitHub, luego configurar ambientes.
