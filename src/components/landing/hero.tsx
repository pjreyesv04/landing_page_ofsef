import Image from 'next/image';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Goal, Eye, Gem, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import { Button } from '../ui/button';

const featureCards = [
  {
    icon: <Goal className="h-10 w-10 text-primary" />,
    title: "Nuestra Misión",
    description: "Garantizar el acceso universal y equitativo a los seguros de salud para toda la población de Lima Norte."
  },
  {
    icon: <Eye className="h-10 w-10 text-primary" />,
    title: "Nuestra Visión",
    description: "Ser la oficina líder y referente en la gestión de seguros de salud, reconocida por su eficiencia y compromiso."
  },
  {
    icon: <Gem className="h-10 w-10 text-primary" />,
    title: "Nuestros Valores",
    description: "Actuamos con Integridad, Transparencia, Compromiso, Equidad y vocación de Servicio hacia la comunidad."
  }
];

const Hero = () => {
  return (
    <>
      <section className="relative pt-24 pb-32">
        <Image
          src="https://placehold.co/1920x1080.png"
          alt="Familia unida y protegida"
          fill
          className="object-cover"
          data-ai-hint="protected family"
          priority
        />
        <div className="absolute inset-0 bg-primary/80"></div>

        <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="grid md:grid-cols-2 gap-16 items-center">
            <div className="text-white space-y-6">
              <p className="font-semibold text-accent bg-accent/20 px-4 py-1 rounded-full inline-block">TU BIENESTAR, NUESTRA PRIORIDAD</p>
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold tracking-tight font-headline">
                Garantizando tu Acceso al Seguro Integral de Salud en Lima Norte
              </h1>
              <p className="text-lg text-primary-foreground/80">
                Somos la Oficina de Seguros de la DIRIS Lima Norte, tu nexo con el SIS y FISSAL. Facilitamos tu afiliación y te brindamos el soporte que necesitas.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <Button asChild size="lg" className="font-semibold bg-accent text-accent-foreground hover:bg-accent/90">
                  <Link href="#planes">Conoce los Planes SIS <ArrowRight className="ml-2 h-5 w-5"/></Link>
                </Button>
                <Button asChild size="lg" variant="outline" className="font-semibold text-white border-white hover:bg-white hover:text-primary">
                  <Link href="#sobre-nosotros">Saber Más</Link>
                </Button>
              </div>
            </div>
            <div className="hidden md:block">
              {/* This space can be used for an illustration or form preview in the future */}
            </div>
          </div>
        </div>
      </section>

      <section className="bg-background relative -mt-20 z-20 pb-20">
        <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {featureCards.map(card => (
              <Card key={card.title} className="shadow-lg hover:shadow-xl hover:-translate-y-2 transition-transform duration-300 border-t-4 border-primary">
                <CardHeader className="flex-row items-center gap-4 space-y-0 pb-4">
                  <div className="bg-primary/10 p-4 rounded-lg">{card.icon}</div>
                </CardHeader>
                <CardContent>
                  <h3 className="text-xl font-bold mb-2">{card.title}</h3>
                  <p className="text-muted-foreground">{card.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>
    </>
  );
};

export default Hero;
