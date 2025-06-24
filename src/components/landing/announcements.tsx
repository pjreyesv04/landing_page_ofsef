import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import Image from 'next/image';
import Link from 'next/link';
import { ArrowRight } from 'lucide-react';

const announcements = [
  {
    date: '15 de Julio, 2024',
    title: 'Nueva campaña de vacunación contra la influenza estacional.',
    category: 'Campaña',
    image: 'https://placehold.co/600x400.png',
    hint: 'vaccination campaign'
  },
  {
    date: '01 de Julio, 2024',
    title: 'Actualización de la red de clínicas afiliadas en Comas y Puente Piedra.',
    category: 'Actualización',
    image: 'https://placehold.co/600x400.png',
    hint: 'clinic building'
  },
  {
    date: '20 de Junio, 2024',
    title: 'Charla informativa sobre prevención de enfermedades crónicas.',
    category: 'Evento',
    image: 'https://placehold.co/600x400.png',
    hint: 'health talk'
  }
];

const Announcements = () => {
  return (
    <section id="anuncios" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary">Anuncios y Novedades</h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Manténgase informado sobre nuestras últimas noticias y eventos importantes.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {announcements.map((item) => (
            <Card key={item.title} className="flex flex-col overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300">
              <Image 
                src={item.image}
                alt={item.title}
                width={600}
                height={400}
                className="w-full h-48 object-cover"
                data-ai-hint={item.hint}
              />
              <CardHeader>
                <div className="flex justify-between items-center text-sm text-muted-foreground">
                  <span>{item.date}</span>
                  <Badge variant="secondary">{item.category}</Badge>
                </div>
                <CardTitle className="text-xl font-semibold leading-snug !mt-2">{item.title}</CardTitle>
              </CardHeader>
              <CardContent className="flex-grow">
              </CardContent>
              <div className="p-6 pt-0">
                <Link href="#" className="font-semibold text-primary hover:text-accent transition-colors flex items-center gap-2">
                  Leer más <ArrowRight className="h-4 w-4" />
                </Link>
              </div>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Announcements;
