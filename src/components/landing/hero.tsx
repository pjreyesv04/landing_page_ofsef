import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import Link from 'next/link';

const Hero = () => {
  return (
    <section className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-20 sm:py-28">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
        <div className="space-y-6 text-center md:text-left">
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold tracking-tighter text-primary font-headline">
            Oficina de Seguros DIRIS Lima Norte
          </h1>
          <p className="text-lg text-muted-foreground max-w-xl mx-auto md:mx-0">
            Su bienestar, nuestra prioridad. Acceda a la mejor cobertura de salud integral para usted y su familia.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center md:justify-start">
            <Button asChild size="lg" className="font-semibold">
              <Link href="#planes">Ver Planes de Seguro</Link>
            </Button>
            <Button asChild size="lg" variant="outline" className="font-semibold">
              <Link href="#contacto">Contáctenos</Link>
            </Button>
          </div>
        </div>
        <div className="flex justify-center">
          <Card className="overflow-hidden rounded-2xl shadow-2xl transform hover:scale-105 transition-transform duration-300 ease-in-out">
            <Image 
              src="https://placehold.co/600x400.png"
              alt="Familia feliz asegurada"
              width={600}
              height={400}
              className="object-cover"
              data-ai-hint="happy family"
            />
          </Card>
        </div>
      </div>
    </section>
  );
};

export default Hero;
