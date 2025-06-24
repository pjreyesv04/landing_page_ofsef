import Image from 'next/image';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { HeartHandshake, BookUser, ShieldPlus, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import { Button } from '../ui/button';

const featureCards = [
  {
    icon: <HeartHandshake className="h-10 w-10 text-primary" />,
    title: "Coberturas Gratuitas",
    description: "Acceso a seguros de salud financiados por el estado para tu tranquilidad."
  },
  {
    icon: <BookUser className="h-10 w-10 text-primary" />,
    title: "Asesoría Experta",
    description: "Te guiamos en cada paso del proceso de afiliación y uso de tu seguro."
  },
  {
    icon: <ShieldPlus className="h-10 w-10 text-primary" />,
    title: "Soporte Continuo",
    description: "Estamos contigo para resolver tus dudas y facilitar tus trámites."
  }
];

const Hero = () => {
  return (
    <>
      <section className="relative bg-background pt-24 pb-32">
        <Image
          src="https://images.unsplash.com/photo-1541019623835-9515934a3628?q=80&w=2070&auto=format&fit=crop"
          alt="Familia feliz"
          fill
          className="object-cover"
          data-ai-hint="happy family"
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
                Somos la Oficina de Seguros de la DIRIS Lima Norte, tu nexo con el SIS, FISSAL y el SOAT. Facilitamos tu afiliación y te brindamos el soporte que necesitas.
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
