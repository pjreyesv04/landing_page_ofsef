import { ShieldCheck, Twitter, Facebook, Instagram, Mail, MapPin, Phone } from 'lucide-react';
import Link from 'next/link';

const Footer = () => {
  const year = new Date().getFullYear();

  return (
    <footer className="bg-slate-900 text-slate-300" id="footer-contact">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-12 mb-8">
          <div className="space-y-4">
            <Link href="/" className="flex items-center gap-2">
              <ShieldCheck className="h-8 w-8 text-accent" />
              <span className="font-bold text-xl text-white font-headline">Oficina de Seguros</span>
            </Link>
            <p className="text-sm">
              Gestionando el acceso al Seguro Integral de Salud (SIS) y otras coberturas para la comunidad de Lima Norte, bajo el respaldo del Ministerio de Salud.
            </p>
             <div className="flex gap-4 pt-2">
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Twitter">
                <Twitter className="h-5 w-5" />
              </Link>
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Facebook">
                <Facebook className="h-5 w-5" />
              </Link>
              <Link href="#" className="text-slate-400 hover:text-white transition-colors" aria-label="Instagram">
                <Instagram className="h-5 w-5" />
              </Link>
            </div>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-white">Enlaces Rápidos</h3>
            <ul className="space-y-2 text-sm">
              <li><Link href="#sobre-nosotros" className="hover:text-white">Sobre Nosotros</Link></li>
              <li><Link href="#estadisticas" className="hover:text-white">Nuestras Cifras</Link></li>
              <li><Link href="#servicios" className="hover:text-white">Nuestros Servicios</Link></li>
              <li><Link href="#porque-elegirnos" className="hover:text-white">Nuestro Compromiso</Link></li>
              <li><Link href="#planes" className="hover:text-white">Planes SIS</Link></li>
              <li><Link href="#recursos" className="hover:text-white">Recursos</Link></li>
              <li><Link href="#anuncios" className="hover:text-white">Anuncios</Link></li>
              <li><Link href="#contacto" className="hover:text-white">Contáctenos</Link></li>
            </ul>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg text-white">Contacto</h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-start gap-3">
                <MapPin className="h-4 w-4 text-accent mt-1 shrink-0" />
                <span>Calle A Mz. 02 Lt. 03 Asoc. Víctor Raúl Haya de la Torre - Distrito Independencia - Lima - Perú</span>
              </li>
              <li className="flex items-start gap-3">
                <Mail className="h-4 w-4 text-accent mt-1 shrink-0" />
                <a href="mailto:seguros@dirislimanorte.gob.pe" className="hover:text-white break-all">seguros@dirislimanorte.gob.pe</a>
              </li>
               <li className="flex items-start gap-3">
                <Phone className="h-4 w-4 text-accent mt-1 shrink-0" />
                <div className="space-y-1">
                  <a href="tel:+515213400" className="hover:text-white block">(01) 521-3401</a>
                  <span className="text-xs text-slate-400">Lun-Vie: 8:00-16:30</span>
                  <a href="tel:+515213401" className="hover:text-white block text-accent">Telefono: (01) 521-3400</a>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div className="bg-slate-950 py-4">
         <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 text-center text-sm text-slate-400">
             © {year} Oficina de Seguros - Dirección de Redes Integradas de Salud Lima Norte. Todos los derechos reservados.
        </div>
      </div>
    </footer>
  );
};

export default Footer;
