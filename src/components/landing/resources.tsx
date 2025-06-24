import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { Check } from 'lucide-react';
import Link from 'next/link';

const features = [
  "Más de 20 años de experiencia.",
  "Equipo de profesionales altamente calificados.",
  "Compromiso con la salud de la comunidad.",
  "Procesos transparentes y eficientes."
];

const About = () => {
  return (
    <section id="sobre-nosotros" className="py-20">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="relative">
            <Image
              src="https://placehold.co/600x700.png"
              alt="Personal médico de DIRIS Lima Norte"
              width={600}
              height={700}
              className="rounded-lg shadow-2xl object-cover w-full h-full"
              data-ai-hint="medical staff"
            />
            <div className="absolute -bottom-4 -right-4 bg-primary text-primary-foreground p-6 rounded-lg shadow-lg max-w-xs">
              <p className="font-bold text-4xl">20+</p>
              <p className="text-sm">Años de experiencia sirviendo a Lima Norte</p>
            </div>
          </div>
          <div className="space-y-6">
            <p className="font-semibold text-primary">SOBRE NOSOTROS</p>
            <h2 className="text-3xl md:text-4xl font-bold font-headline">
              La Mejor Opción de Seguro en la Zona
            </h2>
            <p className="text-muted-foreground">
              Somos la Oficina de Seguros de la Dirección de Redes Integradas de Salud de Lima Norte, una entidad pública comprometida con garantizar el acceso a servicios de salud de calidad para todos los ciudadanos de nuestra jurisdicción.
            </p>
            <ul className="space-y-3">
              {features.map((feature, i) => (
                <li key={i} className="flex items-center gap-3">
                  <Check className="h-5 w-5 text-accent" />
                  <span className="text-foreground/80">{feature}</span>
                </li>
              ))}
            </ul>
            <Button asChild size="lg" variant="outline">
              <Link href="#contacto">Leer Más</Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;
