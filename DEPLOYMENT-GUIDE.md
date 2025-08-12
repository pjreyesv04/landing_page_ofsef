# 🚀 GUÍA DE DEPLOYMENT PARA DIRIS LIMA NORTE
# Proceso Automatizado para Actualizaciones

## 📁 ESTRUCTURA DE CONFIGURACIONES

### next.config.ts (Principal - IIS Production)
```typescript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  basePath: '/page_ofseg_dirisln',
  assetPrefix: '/page_ofseg_dirisln/',
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

module.exports = nextConfig
```

## 🔄 PROCESO DE ACTUALIZACIÓN PASO A PASO

### PASO 1: PREPARACIÓN LOCAL
```bash
# 1. Asegurar configuración correcta
cp next.config.iis.ts next.config.ts

# 2. Instalar dependencias
npm install

# 3. Build local para verificar
npm run build
```

### PASO 2: PUBLICAR A GITHUB
```bash
# 1. Commit cambios
git add .
git commit -m "feat: actualización [descripción del cambio]"

# 2. Push a GitHub
git push origin master
```

### PASO 3: ACTUALIZAR SERVIDOR (AUTOMÁTICO)
```powershell
# Este script se ejecutará en el servidor
# Ubicación: C:\inetpub\wwwroot\page_ofseg_dirisln\update-from-github.ps1
```

### PASO 4: VERIFICACIÓN
```bash
# 1. Chrome: http://localhost/page_ofseg_dirisln/
# 2. Firefox: http://localhost/page_ofseg_dirisln/
# 3. Diagnóstico: http://localhost/page_ofseg_dirisln/browser-test.html
```

## ⚠️ PROBLEMAS COMUNES Y SOLUCIONES

### Problema 1: "Error 500.19 - XML inválido"
**Causa**: Sintaxis incorrecta en web.config
**Solución**: Usar el web.config estándar (nunca editar manualmente)

### Problema 2: "Archivos 404 después de build"
**Causa**: Inconsistencia entre basePath y archivos generados
**Solución**: Siempre usar el mismo next.config.ts para IIS

### Problema 3: "CSS/JS no cargan en Firefox"
**Causa**: Headers MIME incorrectos
**Solución**: web.config con configuraciones específicas

### Problema 4: "Imágenes no cargan"
**Causa**: Rutas hardcodeadas o basePath incorrecto
**Solución**: Usar rutas relativas y image-paths.ts

## 🛠️ ARCHIVOS CRÍTICOS (NUNCA MODIFICAR MANUALMENTE)

### 1. web.config
- ✅ Usar versión estándar
- ❌ NO editar manualmente
- 🔄 Regenerar con script si es necesario

### 2. next.config.ts
- ✅ Usar configuración IIS estándar
- ❌ NO cambiar basePath sin plan completo
- 🔄 Mantener consistencia en todas las actualizaciones

### 3. Archivos en _next/static/
- ✅ Generados automáticamente por Next.js
- ❌ NO copiar manualmente
- 🔄 Siempre regenerar con npm run build

## 📊 CHECKLIST PRE-DEPLOYMENT

- [ ] next.config.ts configurado para IIS
- [ ] Build local exitoso (npm run build)
- [ ] Archivos en /out/ generados correctamente
- [ ] Imágenes en ruta correcta (/page_ofseg_dirisln/images/)
- [ ] web.config válido y sin modificaciones manuales
- [ ] Backup de versión actual

## 📊 CHECKLIST POST-DEPLOYMENT

- [ ] Sitio carga en Chrome sin errores
- [ ] Sitio carga en Firefox sin errores
- [ ] CSS aplicado correctamente
- [ ] JavaScript funcional (contadores, stats)
- [ ] Imágenes se muestran
- [ ] Sin errores 404 en DevTools

## 🎯 PRÓXIMOS PASOS RECOMENDADOS

1. **Crear script de automatización**
2. **Standardizar proceso de update**
3. **Implementar validaciones automáticas**
4. **Documentar configuraciones específicas**
