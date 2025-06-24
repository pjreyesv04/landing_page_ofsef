import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { CheckCircle2, ShieldCheck } from 'lucide-react';
import Link from 'next/link';

const features = [
  "Acceso a una amplia red de proveedores de salud.",
  "Planes de salud completos y asequibles.",
  "Equipo dedicado al servicio de la comunidad.",
  "Procesos de afiliación y reclamos simplificados.",
  "Compromiso con la atención preventiva y el bienestar."
];

const About = () => {
  return (
    <section id="sobre-nosotros" className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="relative">
            <Image
              src="https://placehold.co/600x700.png"
              alt="Equipo de la Oficina de Seguros de DIRIS Lima Norte"
              width={600}
              height={700}
              className="rounded-lg shadow-2xl object-cover w-full h-full"
              data-ai-hint="medical team discussion"
            />
            <div className="absolute -bottom-8 -left-8 bg-primary text-primary-foreground p-8 rounded-lg shadow-lg flex items-center gap-4">
              <ShieldCheck className="h-16 w-16" />
              <div>
                <p className="font-bold text-4xl">20+</p>
                <p>Años de Experiencia</p>
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <p className="font-semibold text-primary">SOBRE NOSOTROS</p>
            <h2 className="text-3xl md:text-4xl font-bold font-headline">
              Su Aliado Estratégico en Salud para Lima Norte
            </h2>
            <p className="text-muted-foreground text-lg">
              Somos la Oficina de Seguros de la Dirección de Redes Integradas de Salud de Lima Norte, una entidad pública dedicada a facilitar el acceso a servicios de salud de calidad para todos los residentes de nuestra jurisdicción.
            </p>
            <ul className="space-y-4">
              {features.map((feature, i) => (
                <li key={i} className="flex items-start gap-3">
                  <CheckCircle2 className="h-6 w-6 text-accent shrink-0 mt-1" />
                  <span className="text-foreground/80">{feature}</span>
                </li>
              ))}
            </ul>
            <Button asChild size="lg" variant="outline" className="border-primary text-primary hover:bg-primary hover:text-primary-foreground">
              <Link href="#contacto">Contáctenos</Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;
