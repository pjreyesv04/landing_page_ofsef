import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Newspaper } from 'lucide-react';

const announcements = [
  {
    date: '15 de Julio, 2024',
    title: 'Nueva campaña de vacunación contra la influenza estacional.',
    category: 'Campaña'
  },
  {
    date: '01 de Julio, 2024',
    title: 'Actualización de la red de clínicas afiliadas en Comas y Puente Piedra.',
    category: 'Actualización'
  },
  {
    date: '20 de Junio, 2024',
    title: 'Charla informativa sobre prevención de enfermedades crónicas.',
    category: 'Evento'
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
        <div className="max-w-3xl mx-auto">
          <Card className="shadow-lg">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Newspaper className="h-6 w-6 text-primary" />
                <span>Últimos Anuncios</span>
              </CardTitle>
            </CardHeader>
            <CardContent>
              <ul className="space-y-6">
                {announcements.map((item, index) => (
                  <li key={index} className="flex flex-col sm:flex-row gap-4 items-start border-b border-border pb-4 last:border-b-0 last:pb-0">
                    <div className="flex-grow">
                      <p className="font-semibold text-foreground">{item.title}</p>
                      <p className="text-sm text-muted-foreground">{item.date}</p>
                    </div>
                    <Badge variant="secondary" className="mt-1 sm:mt-0">{item.category}</Badge>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  );
};

export default Announcements;
