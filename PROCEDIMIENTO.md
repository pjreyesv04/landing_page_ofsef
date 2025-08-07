# PROCEDIMIENTO PARA SINCRONIZACIÓN

## SITUACIÓN ACTUAL:
- PC Local (original): Tu entorno de desarrollo principal
- GitHub Repository: landing_page_ofsef (sincronizado con PC local)
- **Servidor IIS Raíz: C:\inetpub\wwwroot (sitio principal - PRODUCCIÓN)**
- **Servidor IIS Subcarpeta: C:\inetpub\wwwroot\page_ofseg_dirisln (desarrollo - STAGING)**

## CONFIGURACIÓN ACTUAL - OPCIÓN 1 IMPLEMENTADA:

✅ **RAÍZ (C:\inetpub\wwwroot)**: SITIO EN PRODUCCIÓN
- URL: `http://localhost`
- Archivos: `index.html`, `_next/`, `images/`, `web.config`
- Rutas convertidas: `/` (sin prefijo)

🔧 **SUBCARPETA (C:\inetpub\wwwroot\page_ofseg_dirisln)**: DESARROLLO/STAGING  
- URL: `http://localhost/page_ofseg_dirisln`
- Repositorio Git conectado a GitHub
- Rutas originales: `/page_ofseg_dirisln/`

**⚠️ IMPORTANTE:** Los archivos de producción están en la RAÍZ. La subcarpeta es solo para desarrollo y sincronización con GitHub.

## DIFERENCIAS DE RUTAS:
- **GitHub/PC Local**: Rutas con `/landing_page_ofsef/`
- **Servidor IIS Subcarpeta**: Rutas con `/page_ofseg_dirisln/`
- **Servidor IIS Raíz**: Rutas con `/` (sin prefijo)

## PROCEDIMIENTO PASO A PASO:

### ✅ CONFIGURACIÓN COMPLETADA - VERIFICACIÓN:

**Ejecutar verificación completa:**
```powershell
cd C:\inetpub\wwwroot\page_ofseg_dirisln
powershell -ExecutionPolicy Bypass -File "verify-setup.ps1"
```

### PARA ACTUALIZAR DESDE PC LOCAL A SERVIDOR RAÍZ:

1. **En tu PC local**: Hacer cambios y subir a GitHub
```bash
git add .
git commit -m "Nuevos cambios"
git push origin master
```

2. **En el servidor (subcarpeta)**: Traer cambios desde GitHub
```powershell
cd c:\inetpub\wwwroot\page_ofseg_dirisln
git pull origin master
```

3. **Actualizar el sitio en la raíz**:
```powershell
# Convertir rutas para la raíz
$content = Get-Content "index.html" -Raw
$content = $content -replace '/landing_page_ofsef/', '/'
$content = $content -replace '"/landing_page_ofsef"', '"/"'
Set-Content "C:\inetpub\wwwroot\index.html.new" $content -Encoding UTF8

# Copiar recursos necesarios
Copy-Item "_next" "C:\inetpub\wwwroot\_next" -Recurse -Force
Copy-Item "images" "C:\inetpub\wwwroot\images" -Recurse -Force

# Activar el nuevo archivo
Copy-Item "C:\inetpub\wwwroot\index.html.new" "C:\inetpub\wwwroot\index.html" -Force
```

### PARA SUBIR CAMBIOS DESDE SERVIDOR A GITHUB:

1. **Hacer cambios en la subcarpeta de desarrollo**
2. **Convertir rutas para GitHub y subir**:
```powershell
cd c:\inetpub\wwwroot\page_ofseg_dirisln
# [Seguir proceso de conversión de rutas anterior]
```

3. **Actualizar sitio en la raíz**:
```powershell
# [Seguir proceso de actualización a raíz]
```
