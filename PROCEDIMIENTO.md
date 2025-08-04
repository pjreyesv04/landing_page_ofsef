# PROCEDIMIENTO PARA SINCRONIZACIÓN

## SITUACIÓN ACTUAL:
- Servidor IIS: Tiene las modificaciones más recientes (rutas corregidas)
- GitHub: Versión original sin las correcciones
- PC Local: Sincronizado con GitHub

## PROCEDIMIENTO PASO A PASO:

### AHORA (Primera sincronización):

1. **Preparar archivos para GitHub (revertir rutas)**
```powershell
# Copiar contenido actual
$content = Get-Content "index.html" -Raw

# Cambiar rutas de IIS a GitHub
$content = $content -replace '/page_ofseg_dirisln/', '/landing_page_ofsef/'
$content = $content -replace '"/page_ofseg_dirisln"', '"/landing_page_ofsef"'

# Guardar versión para GitHub
Set-Content "index.html" $content -Encoding UTF8
```

2. **Subir a GitHub**
```powershell
git add .
git commit -m "Sync from IIS server with all updates"
git push origin master
```

3. **Restaurar rutas para IIS**
```powershell
# Restaurar desde backup
Copy-Item "index.html.iis.backup" "index.html" -Force
```

### EN EL FUTURO:

#### Cambios desde PC Local → GitHub → IIS:
1. En PC local: Hacer cambios y subir a GitHub
2. En servidor IIS: `git pull origin master`
3. En servidor IIS: Aplicar conversión de rutas

#### Cambios desde IIS → GitHub → PC Local:
1. En servidor IIS: Revertir rutas y subir a GitHub
2. En servidor IIS: Restaurar rutas locales
3. En PC local: `git pull origin master`
