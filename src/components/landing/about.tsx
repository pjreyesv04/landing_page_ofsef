import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { CheckCircle2, ShieldCheck } from 'lucide-react';
import Link from 'next/link';
import { getImagePath } from '@/lib/image-paths';

const features = [
  "Gestionamos tu afiliación al Seguro Integral de Salud (SIS).",
  "Brindamos soporte para las coberturas de alto costo de FISSAL.",
  "Somos el nexo oficial con las Instituciones Administradoras de Fondos de Aseguramiento en Salud (IAFAS).",
  "Comprometidos con el acceso universal a la salud, como parte del Ministerio de Salud."
];

const About = () => {
  return (
    <section className="py-20 bg-card">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div className="relative aspect-[6/7]">
            <Image
              src={getImagePath("images/backgrounds/medical-team.jpg")}
              alt="Equipo de la Oficina de Seguros de DIRIS Lima Norte"
              fill
              className="rounded-lg shadow-2xl object-cover"
              data-ai-hint="medical team discussion"
            />
            <div className="absolute -bottom-8 -left-8 bg-primary text-primary-foreground p-8 rounded-lg shadow-lg flex items-center gap-4">
              <ShieldCheck className="h-16 w-16" />
              <div>
                <p className="font-bold text-4xl">DIRIS LN</p>
                <p>Oficina de Seguros</p>
              </div>
            </div>
          </div>
          <div className="space-y-6">
            <p className="font-semibold text-primary">SOBRE NOSOTROS</p>
            <h2 className="text-3xl md:text-4xl font-bold font-headline">
              Tu Aliado hacia el Bienestar y la Salud
            </h2>
            <p className="text-muted-foreground text-lg">
              La Oficina de Seguros de la Dirección de Redes Integradas de Salud (DIRIS) de Lima Norte, es una entidad del Ministerio de Salud. Nuestra misión es garantizar el acceso de la población a la protección financiera en salud, gestionando la afiliación y el uso de las coberturas del Seguro Integral de Salud (SIS) y el Fondo Intangible Solidario en Salud (FISSAL).
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

