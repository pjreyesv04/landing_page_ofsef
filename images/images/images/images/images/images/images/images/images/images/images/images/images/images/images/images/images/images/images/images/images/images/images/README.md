# Imágenes a reemplazar manualmente

Las siguientes imágenes están siendo cargadas desde URLs externas y deben ser reemplazadas por versiones locales:

## Hero Section
- **Actual**: https://cdn.pixabay.com/photo/2022/08/17/15/46/family-7392843_960_720.jpg
- **Local**: /images/backgrounds/family-hero.jpg
- **Descripción**: Familia unida y protegida
- **Estado**: ✅ Descargada

## Anuncios
1. **Campaña de vacunación**
   - **Actual**: https://images.unsplash.com/photo-1606359599882-936c3403a55c?q=80&w=400&h=224&fit=crop
   - **Local**: /images/announcements/vaccination-campaign.jpg
   - **Descripción**: Campaña de vacunación
   - **Estado**: ⏳ Pendiente (requiere descarga manual)

2. **Centro de salud**
   - **Actual**: https://images.unsplash.com/photo-1586773860418-d37222d8fce3?q=80&w=400&h=224&fit=crop
   - **Local**: /images/announcements/health-facility.jpg
   - **Descripción**: Establecimiento de salud
   - **Estado**: ⏳ Pendiente (requiere descarga manual)

3. **Charla informativa**
   - **Actual**: https://images.unsplash.com/photo-1543269865-cbf427effbad?q=80&w=400&h=224&fit=crop
   - **Local**: /images/announcements/health-talk.jpg
   - **Descripción**: Charla sobre prevención
   - **Estado**: ⏳ Pendiente (requiere descarga manual)

## Instrucciones para completar la migración

### 1. Descargar imágenes de anuncios manualmente
Visite las URLs de Unsplash y descargue las imágenes:
- Guárdelas en `public/images/announcements/` con los nombres especificados
- Tamaño recomendado: 400x224 píxeles

### 2. Alternativas gratuitas recomendadas
Si no puede acceder a Unsplash, puede usar:
- [Pixabay](https://pixabay.com/) - Imágenes gratuitas
- [Pexels](https://pexels.com/) - Imágenes gratuitas
- [Unsplash](https://unsplash.com/) - Crear cuenta gratuita

### 3. Buscar términos relacionados:
- "vaccination", "healthcare", "medical"
- "hospital", "clinic", "health facility"
- "health education", "prevention", "wellness"

### 4. Ejecutar script de actualización
Una vez descargadas todas las imágenes, ejecute:
```bash
.\scripts\update-image-references.ps1
```
