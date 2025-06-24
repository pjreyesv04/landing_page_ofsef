import { Button } from '@/components/ui/button';
import Link from 'next/link';

const Contact = () => {
  return (
    <section 
      id="contacto" 
      className="py-24 bg-cover bg-center relative"
      style={{ backgroundImage: "url('https://placehold.co/1920x500.png')" }}
    >
      <div className="absolute inset-0 bg-primary/80" data-ai-hint="call center"></div>
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center space-y-6 max-w-3xl mx-auto">
          <h2 className="text-3xl md:text-4xl font-bold font-headline text-primary-foreground">
            ¿Listo para proteger a su familia?
          </h2>
          <p className="text-lg text-primary-foreground/80">
            Nuestro equipo de asesores está listo para ayudarlo a encontrar el plan de seguro perfecto.
            Póngase en contacto hoy mismo para una cotización gratuita y sin compromisos.
          </p>
          <div className="flex gap-4 justify-center">
            <Button asChild size="lg" className="bg-accent text-accent-foreground hover:bg-accent/90 font-semibold">
              <Link href="#planes">Obtener una Cotización</Link>
            </Button>
            <Button asChild size="lg" variant="outline" className="font-semibold text-primary-foreground border-primary-foreground hover:bg-primary-foreground hover:text-primary">
              <Link href="#footer-contact">Ver Canales de Contacto</Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;
