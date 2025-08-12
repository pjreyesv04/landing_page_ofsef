# FLUJO DE DESARROLLO COMPLETO
## Local → GitHub → Staging → Producción

### 📋 RESUMEN
El flujo correcto de desarrollo para este proyecto Next.js es:
1. **DESARROLLO LOCAL** - Desarrollo en máquina del programador
2. **GITHUB** - Repositorio central de código
3. **STAGING** - Servidor de pruebas (actual: page_ofseg_dirisln)
4. **PRODUCCIÓN** - Servidor final para usuarios

---

## 🏠 1. DESARROLLO LOCAL

### Configuración Inicial (Una sola vez)
```powershell
# Ejecutar como administrador en PowerShell
cd C:\inetpub\wwwroot\page_ofseg_dirisln
powershell -ExecutionPolicy Bypass -File setup-local-dev.ps1
```

### Desarrollo Diario
```bash
# En directorio local: C:\Desarrollo\page_ofseg_dirisln
npm run dev                    # Iniciar servidor desarrollo
# Abrir: http://localhost:3000

# Hacer cambios en src/
# Probar en navegador
# Cuando esté listo:
git add .
git commit -m "Descripción del cambio"
git push origin master
```

### Configuración Local
- **next.config.ts**: Sin basePath (servidor en puerto 3000)
- **URL Local**: http://localhost:3000
- **Desarrollo**: Hot reload automático
- **Base de datos**: Local o desarrollo

---

## 📂 2. GITHUB (Repositorio Central)

### Información del Repositorio
- **URL**: https://github.com/pjreyesv04/landing_page_ofsef
- **Rama Principal**: master
- **Propósito**: Código fuente centralizado

### Comandos Git Esenciales
```bash
git status                     # Ver estado
git add .                      # Agregar todos los cambios
git commit -m "mensaje"        # Confirmar cambios
git push origin master         # Subir a GitHub
git pull origin master         # Descargar cambios
```

---

## 🧪 3. STAGING (Servidor de Pruebas)

### Ubicación Actual
- **Servidor**: C:\inetpub\wwwroot\page_ofseg_dirisln
- **URL**: http://localhost/page_ofseg_dirisln/
- **Propósito**: Pruebas antes de producción

### Deployment a Staging
```batch
# En servidor staging:
deploy-staging.bat
```

### Configuración Staging
- **next.config.ts**: Con basePath '/page_ofseg_dirisln'
- **URL Staging**: http://localhost/page_ofseg_dirisln/
- **IIS**: Virtual directory configurado
- **Base de datos**: Staging/Testing

### Verificaciones en Staging
✅ Funcionalidad completa
✅ Chrome compatibility
✅ Firefox compatibility
✅ Mobile responsiveness
✅ Performance
✅ Links internos/externos

---

## 🚀 4. PRODUCCIÓN (Servidor Final)

### Deployment a Producción
```batch
# En servidor producción:
deploy-production.bat
```

### Configuración Producción
- **next.config.ts**: Sin basePath (dominio raíz)
- **URL Producción**: http://tu-dominio.com/
- **IIS**: Sitio web principal
- **Base de datos**: Producción

### Checklist Pre-Producción
- [ ] ✅ Staging completamente funcional
- [ ] ✅ Todas las pruebas pasadas
- [ ] ✅ Performance optimizada
- [ ] ✅ SEO verificado
- [ ] ✅ Backup de producción actual
- [ ] ✅ Plan de rollback preparado

---

## 🔧 SCRIPTS DISPONIBLES

### Desarrollo Local
```powershell
setup-local-dev.ps1           # Configuración inicial local
```

### Servidor (Staging/Producción)
```batch
deploy-staging.bat            # Deploy a staging
deploy-production.bat         # Deploy a producción
update-quick.bat             # Actualización rápida
cleanup-project.ps1          # Limpieza de archivos
```

### Mantenimiento
```powershell
update-from-github.ps1       # Script base de actualización
```

---

## 📁 CONFIGURACIONES POR AMBIENTE

### Local (next.config.local.ts)
```typescript
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true },
  typescript: { ignoreBuildErrors: true },
  eslint: { ignoreDuringBuilds: true }
}
```

### Staging (next.config.staging.ts)
```typescript
const nextConfig = {
  output: 'export',
  basePath: '/page_ofseg_dirisln',
  assetPrefix: '/page_ofseg_dirisln',
  trailingSlash: true,
  images: { unoptimized: true },
  typescript: { ignoreBuildErrors: true },
  eslint: { ignoreDuringBuilds: true }
}
```

### Producción (next.config.production.ts)
```typescript
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true },
  typescript: { ignoreBuildErrors: true },
  eslint: { ignoreDuringBuilds: true }
}
```

---

## 🚨 CASOS DE EMERGENCIA

### Rollback Rápido
```batch
# Si hay problemas en producción:
# 1. El script hace backup automático
# 2. Restaurar backup si es necesario
# 3. Usar deploy-staging.bat para volver a versión anterior
```

### Debugging
```bash
# Ver logs de IIS
# Verificar web.config
# Comprobar permisos de archivos
# Revisar console de navegador
```

---

## 📊 VENTAJAS DE ESTE FLUJO

✅ **Separación de ambientes**: Desarrollo, staging, producción
✅ **Control de versiones**: Todo en GitHub
✅ **Automatización**: Scripts de deployment
✅ **Seguridad**: Confirmaciones antes de producción
✅ **Rollback**: Backup automático
✅ **Consistencia**: Misma base de código en todos los ambientes
✅ **Debugging**: Staging idéntico a producción

---

## 🎯 PRÓXIMOS PASOS

1. **Configurar desarrollo local**: Ejecutar setup-local-dev.ps1
2. **Sincronizar GitHub**: Subir todos los scripts y configuraciones
3. **Documentar URLs**: Actualizar URLs de producción
4. **Capacitar equipo**: Entrenar en el nuevo flujo
5. **Monitoreo**: Implementar logs y métricas

---

**ESTADO ACTUAL**: Estamos en STAGING con todo funcionando correctamente.
**SIGUIENTE PASO**: Configurar desarrollo local y sincronizar con GitHub.
