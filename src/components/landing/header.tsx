"use client";

import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { Menu, ShieldCheck, Phone, Mail, MapPin, Facebook, Twitter, Instagram } from 'lucide-react';
import { useState } from 'react';

const navLinks = [
  { href: '#sobre-nosotros', label: 'Sobre Nosotros' },
  { href: '#servicios', label: 'Servicios' },
  { href: '#coberturas', label: 'Coberturas' },
  { href: '#recursos', label: 'Recursos' },
  { href: '#anuncios', label: 'Anuncios' },
  { href: '#contacto', label: 'Contacto' },
];

const Header = () => {
  const [isMenuOpen, setMenuOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 w-full bg-background shadow-md">
      {/* Top Bar */}
      <div className="bg-primary text-primary-foreground py-2">
        <div className="container mx-auto flex max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8 text-xs">
          <div className="flex items-center gap-6">
            <div className="flex items-center gap-2">
              <Phone className="h-4 w-4" />
              <span>(01) 555-1234</span>
            </div>
            <div className="hidden md:flex items-center gap-2">
              <Mail className="h-4 w-4" />
              <span>seguros@dirislimanorte.gob.pe</span>
            </div>
            <div className="hidden lg:flex items-center gap-2">
                <MapPin className="h-4 w-4" />
                <span>Av. Túpac Amaru Km. 5.5, Independencia</span>
            </div>
          </div>
          <div className="flex gap-4">
            <Link href="#" className="hover:opacity-80 transition-opacity" aria-label="Facebook">
              <Facebook className="h-4 w-4" />
            </Link>
            <Link href="#" className="hover:opacity-80 transition-opacity" aria-label="Twitter">
              <Twitter className="h-4 w-4" />
            </Link>
            <Link href="#" className="hover:opacity-80 transition-opacity" aria-label="Instagram">
              <Instagram className="h-4 w-4" />
            </Link>
          </div>
        </div>
      </div>
      
      {/* Main Navigation */}
      <div className="container mx-auto flex h-20 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <Link href="/" className="flex items-center gap-2">
          <ShieldCheck className="h-8 w-8 text-primary" />
          <span className="font-bold text-xl text-primary font-headline">Redes Seguras</span>
        </Link>

        <nav className="hidden lg:flex items-center gap-8">
          {navLinks.map((link) => (
            <Link key={link.href} href={link.href} className="text-sm font-medium text-foreground hover:text-primary transition-colors">
              {link.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-4">
            <Button asChild className="hidden lg:flex bg-accent text-accent-foreground hover:bg-accent/90 font-semibold">
                <Link href="#contacto">Obtener Cotización</Link>
            </Button>
            <div className="lg:hidden">
            <Sheet open={isMenuOpen} onOpenChange={setMenuOpen}>
                <SheetTrigger asChild>
                <Button variant="ghost" size="icon">
                    <Menu className="h-6 w-6" />
                    <span className="sr-only">Abrir menú</span>
                </Button>
                </SheetTrigger>
                <SheetContent side="right">
                <div className="flex flex-col gap-6 p-6">
                    <Link href="/" className="flex items-center gap-2 mb-4" onClick={() => setMenuOpen(false)}>
                    <ShieldCheck className="h-8 w-8 text-primary" />
                    <span className="font-bold text-lg text-primary font-headline">Redes Seguras</span>
                    </Link>
                    {navLinks.map((link) => (
                    <Link key={link.href} href={link.href} className="text-lg font-medium" onClick={() => setMenuOpen(false)}>
                        {link.label}
                    </Link>
                    ))}
                    <Button asChild className="bg-accent text-accent-foreground hover:bg-accent/90 mt-4">
                    <Link href="#contacto" onClick={() => setMenuOpen(false)}>Obtener Cotización</Link>
                    </Button>
                </div>
                </SheetContent>
            </Sheet>
            </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
