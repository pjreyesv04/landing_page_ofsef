"use client"

import { useEffect, useState, useRef } from 'react';
import { Users, Stethoscope, Hospital, ClipboardCheck } from "lucide-react";

const AnimatedCounter = ({
  value,
  suffix = '',
}: {
  value: number
  suffix?: string
}) => {
  const [count, setCount] = useState(0)
  const ref = useRef<HTMLSpanElement>(null)
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
  }, []);

  useEffect(() => {
    if (!isMounted) return;

    const node = ref.current
    if (!node) return

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          const duration = 2000
          let start = 0
          const end = value
          const range = end - start
          let startTime: number | null = null

          const step = (timestamp: number) => {
            if (!startTime) startTime = timestamp
            const progress = Math.min((timestamp - startTime) / duration, 1)
            const current = Math.floor(progress * range + start)
            setCount(current)
            if (progress < 1) {
              requestAnimationFrame(step)
            }
          }
          requestAnimationFrame(step)

          observer.disconnect()
        }
      },
      {
        threshold: 0.1,
      }
    )

    observer.observe(node)

    return () => {
      observer.disconnect()
    }
  }, [value, isMounted])

  return (
    <span ref={ref} className="text-4xl md:text-5xl font-bold text-primary">
      {isMounted ? new Intl.NumberFormat('es-PE').format(count) : 0}
      {suffix}
    </span>
  )
}

const statsData = [
  { icon: <Users className="h-10 w-10 text-accent" />, value: 148750, label: 'Afiliados SIS' },
  { icon: <Stethoscope className="h-10 w-10 text-accent" />, value: 489300, label: 'Atenciones Anuales' },
  { icon: <Hospital className="h-10 w-10 text-accent" />, value: 310, label: 'Establecimientos en Red' },
  { icon: <ClipboardCheck className="h-10 w-10 text-accent" />, value: 98, label: 'Avance de Producción', suffix: '%' },
];

const Stats = () => {
  return (
    <section id="estadisticas" className="py-20 bg-background">
      <div className="container mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center space-y-4 mb-12">
          <p className="font-semibold text-primary">NUESTRO IMPACTO EN CIFRAS</p>
          <h2 className="text-3xl md:text-4xl font-bold font-headline">
            Resultados que Hablan por Sí Mismos
          </h2>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            Estamos orgullosos de nuestro trabajo y del impacto positivo que
            generamos en la salud de la comunidad de Lima Norte.
          </p>
        </div>
        <div className="bg-card rounded-lg shadow-lg p-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 text-center">
            {statsData.map((stat) => (
              <div key={stat.label} className="flex flex-col items-center justify-center space-y-3">
                <div className="bg-accent/10 p-4 rounded-full">
                    {stat.icon}
                </div>
                <AnimatedCounter value={stat.value} suffix={stat.suffix} />
                <p className="text-muted-foreground font-medium">{stat.label}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}

export default Stats