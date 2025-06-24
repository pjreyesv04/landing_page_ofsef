import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import Link from 'next/link';
import { Hospital, Users, ShieldAlert } from 'lucide-react';

const featureCards = [
  {
    icon: <Hospital className="h-8 w-8 text-primary" />,
    title: "Seguro Esencial",
    description: "Cobertura médica ambulatoria y preventiva."
  },
  {
    icon: <Users className="h-8 w-8 text-primary" />,
    title: "Seguro Familiar",
    description: "Protección integral para todos los miembros de tu familia."
  },
  {
    icon: <ShieldAlert className="h-8 w-8 text-primary" />,
    title: "Seguro Premium",
    description: "Acceso exclusivo a la red más completa de especialistas."
  }
];

const Hero = () => {
  return (
    <section className="relative bg-background pt-20 pb-16 md:pb-32">
      <div 
        className="absolute inset-0 bg-cover bg-center bg-no-repeat opacity-10"
        style={{ backgroundImage: "url('https://placehold.co/1920x1080.png')" }}
        data-ai-hint="medical background"
      ></div>
      <div className="absolute inset-0 bg-gradient-to-t from-background via-background/80 to-transparent"></div>

      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center space-y-6 max-w-3xl mx-auto">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold tracking-tight text-primary font-headline">
              Estamos Listos Para Proteger a tu Familia
            </h1>
            <p className="text-lg text-muted-foreground">
              Su bienestar, nuestra prioridad. Acceda a la mejor cobertura de salud integral para usted y su familia en toda Lima Norte.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="font-semibold">
                <Link href="#servicios">Ver Servicios</Link>
              </Button>
              <Button asChild size="lg" variant="outline" className="font-semibold">
                <Link href="#contacto">Contáctenos</Link>
              </Button>
            </div>
        </div>
      </div>

      <div className="relative z-20 container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 -mt-16 md:-mt-24">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {featureCards.map(card => (
            <Card key={card.title} className="shadow-lg hover:shadow-xl hover:-translate-y-2 transition-transform duration-300">
              <CardHeader className="flex-row items-center gap-4 space-y-0 pb-2">
                <div className="bg-primary/10 p-3 rounded-lg">{card.icon}</div>
                <CardTitle className="text-xl font-semibold">{card.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-muted-foreground">{card.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Hero;
