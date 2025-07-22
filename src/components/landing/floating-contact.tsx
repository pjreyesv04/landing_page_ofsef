"use client";

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Phone, MessageCircle, Mail, X, HeadphonesIcon } from 'lucide-react';
import Link from 'next/link';

const FloatingContactButton = () => {
  const [isOpen, setIsOpen] = useState(false);

  const contactOptions = [
    {
      icon: Phone,
      label: 'Llamar',
      href: 'tel:+515213400',
      color: 'bg-blue-600 hover:bg-blue-700',
      description: '(01) 2011340'
    },
    {
      icon: MessageCircle,
      label: 'WhatsApp',
      href: 'https://wa.me/51987654321',
      color: 'bg-green-600 hover:bg-green-700',
      description: 'Chat directo'
    },
    {
      icon: Mail,
      label: 'Email',
      href: 'mailto:seguros@dirislimanorte.gob.pe',
      color: 'bg-purple-600 hover:bg-purple-700',
      description: 'Enviar mensaje'
    }
  ];

  return (
    <div className="fixed bottom-6 right-6 z-40">
      {/* Contact Options */}
      {isOpen && (
        <div className="mb-4 space-y-3">
          {contactOptions.map((option, index) => {
            const Icon = option.icon;
            return (
              <Card key={index} className="shadow-lg border-0 animate-in slide-in-from-bottom-2 duration-200" style={{
                animationDelay: `${index * 100}ms`
              }}>
                <CardContent className="p-0">
                  <Button
                    asChild
                    className={`w-full justify-start gap-3 h-auto p-4 ${option.color} text-white rounded-lg`}
                  >
                    <Link href={option.href} target={option.href.startsWith('http') ? '_blank' : undefined}>
                      <Icon className="h-5 w-5 shrink-0" />
                      <div className="text-left">
                        <div className="font-medium">{option.label}</div>
                        <div className="text-xs opacity-90">{option.description}</div>
                      </div>
                    </Link>
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}

      {/* Main FAB Button */}
      <Button
        onClick={() => setIsOpen(!isOpen)}
        size="lg"
        className={`w-14 h-14 rounded-full shadow-lg transition-all duration-300 ${
          isOpen 
            ? 'bg-red-600 hover:bg-red-700 rotate-45' 
            : 'bg-primary hover:bg-primary/90'
        }`}
      >
        {isOpen ? (
          <X className="h-6 w-6" />
        ) : (
          <HeadphonesIcon className="h-6 w-6" />
        )}
      </Button>

      {/* Badge for emergency */}
      {!isOpen && (
        <div className="absolute -top-2 -left-2 bg-red-600 text-white text-xs px-2 py-1 rounded-full animate-pulse">
          24/7
        </div>
      )}
    </div>
  );
};

export default FloatingContactButton;
