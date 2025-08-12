# 🏠 CONFIGURACIÓN DESARROLLO LOCAL - GUÍA PASO A PASO

## 🎯 SITUACIÓN ACTUAL
- **Servidor Staging**: `C:\inetpub\wwwroot\page_ofseg_dirisln` (con todos los cambios)
- **GitHub**: Sincronizado con los últimos cambios
- **Desarrollo Local**: NO EXISTE AÚN

---

## 🚀 OPCIÓN 1: AUTOMÁTICA (RECOMENDADA)

### Paso 1: Descargar Script de Configuración
1. Ir a: https://github.com/pjreyesv04/landing_page_ofsef
2. Buscar archivo `setup-local-dev.ps1`
3. Clic en "Raw" y guardar como en `C:\Temp\setup-local-dev.ps1`

### Paso 2: Ejecutar Configuración Automática
```powershell
# Abrir PowerShell como Administrador
cd C:\Temp
powershell -ExecutionPolicy Bypass -File setup-local-dev.ps1
```

**Este script automáticamente:**
- ✅ Crea directorio `C:\Desarrollo\page_ofseg_dirisln`
- ✅ Clona repositorio desde GitHub
- ✅ Configura `next.config.ts` para desarrollo local
- ✅ Instala dependencias (`npm install`)
- ✅ Construye proyecto (`npm run build`)
- ✅ Deja todo listo para `npm run dev`

---

## 🔧 OPCIÓN 2: MANUAL (PASO A PASO)

### Paso 1: Crear Directorio de Desarrollo
```powershell
# Crear directorio
New-Item -ItemType Directory -Force -Path "C:\Desarrollo\page_ofseg_dirisln"
cd C:\Desarrollo\page_ofseg_dirisln
```

### Paso 2: Clonar Repositorio desde GitHub
```bash
# Clonar repositorio completo
git clone https://github.com/pjreyesv04/landing_page_ofsef.git .
```

### Paso 3: Configurar Ambiente Local
```bash
# Copiar configuración de desarrollo local
copy next.config.local.ts next.config.ts
```

### Paso 4: Instalar Dependencias
```bash
# Instalar paquetes Node.js
npm install
```

### Paso 5: Construir Proyecto
```bash
# Build inicial
npm run build
```

### Paso 6: Probar Desarrollo
```bash
# Iniciar servidor de desarrollo
npm run dev
# Abrir: http://localhost:3000
```

---

## 🔄 FLUJO DIARIO DESPUÉS DE CONFIGURACIÓN

### Cada Día de Trabajo:
```bash
# 1. IR AL DIRECTORIO LOCAL
cd C:\Desarrollo\page_ofseg_dirisln

# 2. SINCRONIZAR CON GITHUB (⚠️ IMPORTANTE)
git pull origin master

# 3. INICIAR DESARROLLO
npm run dev
# Sitio disponible en: http://localhost:3000

# 4. HACER CAMBIOS EN src/
# Editar archivos, el sitio se actualiza automáticamente

# 5. CUANDO ESTÉ LISTO, SUBIR CAMBIOS
git add .
git commit -m "Descripción de los cambios"
git push origin master
```

### En el Servidor (Staging/Producción):
```batch
# Después de subir a GitHub, en el servidor:
deploy-staging.bat      # Para staging
deploy-production.bat   # Para producción
```

---

## 📁 ESTRUCTURA ESPERADA DESPUÉS DE CONFIGURACIÓN

```
C:\Desarrollo\page_ofseg_dirisln\
├── src/                    # Código fuente para editar
├── public/                 # Archivos públicos
├── images/                 # Imágenes del sitio
├── next.config.ts          # Configuración local (sin basePath)
├── next.config.local.ts    # Configuración de desarrollo
├── next.config.staging.ts  # Configuración de staging
├── next.config.production.ts # Configuración de producción
├── package.json            # Dependencias
├── deploy-staging.bat      # Script para servidor staging
├── deploy-production.bat   # Script para servidor producción
├── setup-local-dev.ps1     # Script de configuración inicial
└── .git/                   # Control de versiones
```

---

## ⚠️ PUNTOS IMPORTANTES

### SIEMPRE Sincronizar Antes de Trabajar
```bash
git pull origin master  # ← NUNCA OLVIDAR ESTO
```

### Configuraciones Diferentes por Ambiente
- **Local**: `next.config.local.ts` (sin basePath) → `http://localhost:3000`
- **Staging**: `next.config.staging.ts` (con basePath) → `http://localhost/page_ofseg_dirisln/`
- **Producción**: `next.config.production.ts` (sin basePath) → `http://dominio.com/`

### No Editar Directamente en Servidor
- ❌ **MAL**: Editar archivos en `C:\inetpub\wwwroot\page_ofseg_dirisln`
- ✅ **BIEN**: Editar en `C:\Desarrollo\page_ofseg_dirisln` y usar deployment scripts

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### Si el script automático no funciona:
1. Verificar Node.js instalado: `node --version`
2. Verificar Git instalado: `git --version`
3. Ejecutar PowerShell como Administrador
4. Usar configuración manual

### Si git pull da conflictos:
```bash
git stash                    # Guardar cambios locales
git pull origin master      # Sincronizar
git stash pop               # Recuperar cambios locales
# Resolver conflictos manualmente
```

### Si npm install falla:
```bash
# Limpiar cache y reinstalar
npm cache clean --force
rm -rf node_modules
rm package-lock.json
npm install
```

---

**RESUMEN**: Después de la configuración inicial, el flujo es siempre:
`git pull` → `npm run dev` → Desarrollar → `git push` → `deploy-staging.bat`
