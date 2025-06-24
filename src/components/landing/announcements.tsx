import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight, CalendarDays, UserCircle } from 'lucide-react';

const announcements = [
  {
    date: '15 de Julio, 2024',
    author: 'DIRIS LN',
    title: 'Nueva campaña de vacunación contra la influenza estacional.',
    category: 'Campaña',
    image: 'https://images.unsplash.com/photo-1606359599882-936c3403a55c?q=80&w=400&h=224&fit=crop',
    hint: 'vaccination campaign'
  },
  {
    date: '01 de Julio, 2024',
    author: 'Oficina de Seguros',
    title: 'Actualización de la red de Establecimientos de salud afiliados en Comas.',
    category: 'Actualización',
    image: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?q=80&w=400&h=224&fit=crop',
    hint: 'health facility'
  },
  {
    date: '20 de Junio, 2024',
    author: 'Prevención',
    title: 'Charla informativa sobre prevención de enfermedades crónicas.',
    category: 'Evento',
    image: 'https://images.unsplash.com/photo-1543269865-cbf427effbad?q=80&w=400&h=224&fit=crop',
    hint: 'health talk'
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
                <div className="flex items-center gap-4 text-xs text-muted-foreground mb-3">
                    <div className="flex items-center gap-1.5">
                        <CalendarDays className="h-4 w-4" />
                        <span>{item.date}</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                        <UserCircle className="h-4 w-4" />
                        <span>Por {item.author}</span>
                    </div>
                </div>
                <h3 className="text-xl font-bold leading-snug mb-3 flex-grow">{item.title}</h3>
                <Link href="#" className="font-semibold text-primary hover:text-accent transition-colors flex items-center gap-2">
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
