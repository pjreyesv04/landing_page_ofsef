import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight, CalendarDays, UserCircle } from 'lucide-react';
import { getImagePath } from '@/lib/image-paths';

const announcements = [
  {
    date: '14 de julio, 2025',
    author: 'DIRIS Lima Norte',
    title: 'DIRIS Lima Norte revoluciona la gestión operativa de monitoreo clínico con aplicativo informático "Sígueme"',
    category: 'Tecnología',
    image: getImagePath('images/announcements/technology-app.jpg'),
    hint: 'health technology app',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1208790-diris-lima-norte-revoluciona-la-gestion-operativa-de-monitoreo-clinico-con-aplicativo-informatico-sigueme'
  },
  {
    date: '13 de julio, 2025',
    author: 'DIRIS Lima Norte',
    title: '¿Lluvia y tristeza?: Cómo abordar la depresión estacional',
    category: 'Salud Mental',
    image: getImagePath('images/announcements/mental-health.jpg'),
    hint: 'mental health support',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1209691-lluvia-y-tristeza-como-abordar-la-depresion-estacional'
  },
  {
    date: '30 de junio, 2025',
    author: 'DIRIS Lima Norte',
    title: '¿Qué es la influenza y por qué es importante vacunarse en temporada de invierno?',
    category: 'Prevención',
    image: getImagePath('images/announcements/vaccination-campaign.jpg'),
    hint: 'influenza vaccination campaign',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1199401-que-es-la-influenza-y-por-que-es-importante-vacunarse-en-temporada-de-invierno'
  },
  {
    date: '19 de junio, 2025',
    author: 'DIRIS Lima Norte',
    title: 'Independencia: Ministro de Salud y Diris Lima Norte inauguran Centro de Salud Mental Comunitario "Papa León XIV"',
    category: 'Inauguración',
    image: getImagePath('images/announcements/health-center-inauguration.jpg'),
    hint: 'mental health center inauguration',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1192642-independencia-ministro-de-salud-y-diris-lima-norte-inauguran-centro-de-salud-mental-comunitario-papa-leon-xiv'
  },
  {
    date: '20 de junio, 2025',
    author: 'DIRIS Lima Norte',
    title: 'Comas: Centro Materno Infantil Santa Luzmila II cuenta con nuevo módulo de atención de diabetes tipo 1',
    category: 'Servicios',
    image: getImagePath('images/announcements/diabetes-care.jpg'),
    hint: 'diabetes care module',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1192645-comas-centro-materno-infantil-santa-luzmila-ii-cuenta-con-nuevo-modulo-de-atencion-de-diabetes-tipo-1'
  },
  {
    date: '23 de junio, 2025',
    author: 'DIRIS Lima Norte',
    title: '¡Atención! Protégete de dengue ante las bajas temperaturas',
    category: 'Prevención',
    image: getImagePath('images/announcements/dengue-prevention.jpg'),
    hint: 'dengue prevention campaign',
    link: 'https://www.gob.pe/institucion/dirislimanorte/noticias/1192649-atencion-protegete-de-dengue-ante-las-bajas-temperaturas'
  }
];

const Announcements = () => {
  return (
    <section id="anuncios" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">ANUNCIOS Y NOVEDADES</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">Manténgase Informado</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Noticias, eventos y actualizaciones importantes de la Oficina de Seguros de la DIRIS Lima Norte.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {announcements.map((item) => (
            <Card key={item.title} className="flex flex-col overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300 group">
              <div className="relative h-56 overflow-hidden">
                <Image 
                  src={item.image}
                  alt={item.title}
                  fill
                  className="object-cover group-hover:scale-105 transition-transform duration-300"
                  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                  data-ai-hint={item.hint}
                />
              </div>
              <CardContent className="p-6 flex-grow flex flex-col">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <div className="flex items-center gap-1.5">
                          <CalendarDays className="h-4 w-4" />
                          <span>{item.date}</span>
                      </div>
                      <div className="flex items-center gap-1.5">
                          <UserCircle className="h-4 w-4" />
                          <span>Por {item.author}</span>
                      </div>
                  </div>
                  <Badge variant="secondary" className="text-xs">
                    {item.category}
                  </Badge>
                </div>
                <h3 className="text-xl font-bold leading-snug mb-3 flex-grow">{item.title}</h3>
                <Link 
                  href={item.link || "#"} 
                  target={item.link ? "_blank" : undefined}
                  rel={item.link ? "noopener noreferrer" : undefined}
                  className="font-semibold text-primary hover:text-accent transition-colors flex items-center gap-2"
                >
                  Leer más <ArrowRight className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
                </Link>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Announcements;



