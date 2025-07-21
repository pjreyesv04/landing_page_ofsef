"use client";

import { Button } from '@/components/ui/button';
import Link from 'next/link';
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { Form, FormControl, FormField, FormItem, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { getImagePath } from '@/lib/image-paths';
import Image from 'next/image';
import { useToast } from "@/hooks/use-toast";
import { ArrowRight } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

const formSchema = z.object({
  name: z.string().min(2, { message: "El nombre es requerido." }),
  email: z.string().email({ message: "Por favor ingrese un email válido." }),
  subject: z.string().min(3, { message: "El asunto es requerido." }),
  message: z.string().min(10, { message: "El mensaje debe tener al menos 10 caracteres." }),
});

const Contact = () => {
  const { toast } = useToast();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { name: "", email: "", subject: "", message: "" },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    console.log(values);
    toast({
      title: "Mensaje Enviado",
      description: "Gracias por contactarnos. Le responderemos a la brevedad.",
    });
    form.reset();
  }

  return (
    <section 
      id="contacto" 
      className="py-24 relative"
    >
      <Image
        src={getImagePath("images/backgrounds/call-center.jpg")}
        alt="Agentes de call center"
        fill
        className="object-cover"
        data-ai-hint="call center agents"
      />
      <div className="absolute inset-0 bg-background/90"></div>
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid lg:grid-cols-2 gap-12">
            <div className="space-y-6">
                <p className="font-semibold text-primary">CONTÁCTENOS</p>
                <h2 className="text-3xl md:text-4xl font-bold font-headline">
                    ¿Listo para proteger a su familia?
                </h2>
                <p className="text-lg text-muted-foreground">
                    Nuestro equipo de asesores está listo para ayudarlo a encontrar el plan de seguro perfecto.
                    Póngase en contacto hoy mismo para una cotización gratuita y sin compromisos.
                </p>
                <div className="border-l-4 border-primary pl-6 space-y-3">
                    <h3 className="font-semibold text-lg">Oficina Principal</h3>
                    <p className="text-muted-foreground">Calle A Mz. 02 Lt. 03 Asoc. Víctor Raúl Haya de la Torre - Distrito Independencia - Lima - Perú</p>
                    <p className="text-muted-foreground"><strong>Email:</strong> seguros@dirislimanorte.gob.pe</p>
                    <p className="text-muted-foreground"><strong>Teléfono:</strong> (01) 521-3400</p>
                    <div className="mt-4 pt-3 border-t border-muted">
                        <h4 className="font-semibold text-base text-primary">Horarios de Atención</h4>
                        <div className="mt-2 space-y-1">
                            <p className="text-sm text-muted-foreground"><strong>Lunes a Viernes:</strong> 8:00 AM - 16:30 PM</p>
                            <p className="text-sm text-muted-foreground"><strong>telefono:</strong>(01) 521-3401</p>
                        
                        </div>
                    </div>
                </div>
            </div>
            <div>
                 <Card className="p-8 shadow-2xl bg-card/80 backdrop-blur-sm">
                    <CardHeader className="p-0 mb-6">
                        <CardTitle className="text-2xl font-headline">Envíenos un Mensaje</CardTitle>
                    </CardHeader>
                    <CardContent className="p-0">
                        <Form {...form}>
                            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                                <div className="grid sm:grid-cols-2 gap-4">
                                <FormField control={form.control} name="name" render={({ field }) => (
                                    <FormItem><FormControl><Input placeholder="Su Nombre" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <FormField control={form.control} name="email" render={({ field }) => (
                                    <FormItem><FormControl><Input type="email" placeholder="Su Email" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                </div>
                                <FormField control={form.control} name="subject" render={({ field }) => (
                                    <FormItem><FormControl><Input placeholder="Asunto" {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <FormField control={form.control} name="message" render={({ field }) => (
                                    <FormItem><FormControl><Textarea placeholder="Su Mensaje" rows={5} {...field} /></FormControl><FormMessage /></FormItem>
                                )} />
                                <Button type="submit" size="lg" className="w-full bg-accent hover:bg-accent/90">
                                    Enviar Mensaje <ArrowRight className="ml-2 h-5 w-5"/>
                                </Button>
                            </form>
                        </Form>
                    </CardContent>
                 </Card>
            </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;

