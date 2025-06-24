"use client"

import {
  Bar,
  BarChart,
  CartesianGrid,
  XAxis,
  YAxis,
  Area,
  AreaChart,
  Pie,
  PieChart,
} from "recharts"
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
  ChartLegend,
  ChartLegendContent,
  type ChartConfig,
} from "@/components/ui/chart"
import { Users, Stethoscope, Hospital, ClipboardCheck } from "lucide-react"

// Data for "Afiliados por Distrito"
const afiliadosData = [
  { distrito: "Independencia", afiliados: 42158 },
  { distrito: "Comas", afiliados: 38745 },
  { distrito: "Los Olivos", afiliados: 32500 },
  { distrito: "San Martín", afiliados: 20000 },
  { distrito: "Carabayllo", afiliados: 15000 },
]
const afiliadosChartConfig = {
  afiliados: { label: "Afiliados", color: "hsl(var(--chart-1))" },
} satisfies ChartConfig

// Data for "Atenciones Diarias"
const atencionesData = [
  { day: "Lun", atenciones: 1200 },
  { day: "Mar", atenciones: 1300 },
  { day: "Mié", atenciones: 1100 },
  { day: "Jue", atenciones: 1450 },
  { day: "Vie", atenciones: 1250 },
  { day: "Sáb", atenciones: 950 },
  { day: "Dom", atenciones: 800 },
]
const atencionesChartConfig = {
  atenciones: { label: "Atenciones", color: "hsl(var(--chart-2))" },
} satisfies ChartConfig

// Data for "Producción por Establecimiento"
const produccionData = [
  { name: "Hospital A", value: 3245, fill: "hsl(var(--chart-1))" },
  { name: "Hospital B", value: 2875, fill: "hsl(var(--chart-2))" },
  { name: "Clínica C", value: 2000, fill: "hsl(var(--chart-3))" },
  { name: "Centro D", value: 1500, fill: "hsl(var(--chart-4))" },
]
const produccionChartConfig = {
  produccion: { label: "Producción" },
  "Hospital A": { label: "Hospital A", color: "hsl(var(--chart-1))" },
  "Hospital B": { label: "Hospital B", color: "hsl(var(--chart-2))" },
  "Clínica C": { label: "Clínica C", color: "hsl(var(--chart-3))" },
  "Centro D": { label: "Centro D", color: "hsl(var(--chart-4))" },
} satisfies ChartConfig

// Data for "Avance de Digitación"
const digitacionData = [
  { month: "Ene", avance: 75 },
  { month: "Feb", avance: 82 },
  { month: "Mar", avance: 78 },
  { month: "Abr", avance: 85 },
  { month: "May", avance: 90 },
  { month: "Jun", avance: 92 },
]
const digitacionChartConfig = {
  avance: { label: "Avance (%)", color: "hsl(var(--chart-1))" },
} satisfies ChartConfig

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
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle>Afiliados por Distrito</CardTitle>
              <Users className="h-6 w-6 text-primary" />
            </CardHeader>
            <CardContent>
              <ChartContainer config={afiliadosChartConfig} className="h-64 w-full">
                <BarChart accessibilityLayer data={afiliadosData}>
                  <CartesianGrid vertical={false} />
                  <XAxis dataKey="distrito" tickLine={false} axisLine={false} tickMargin={8} fontSize={12} />
                  <YAxis />
                  <ChartTooltip content={<ChartTooltipContent />} />
                  <Bar dataKey="afiliados" fill="var(--color-afiliados)" radius={4} />
                </BarChart>
              </ChartContainer>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle>Atenciones Diarias</CardTitle>
              <Stethoscope className="h-6 w-6 text-primary" />
            </CardHeader>
            <CardContent>
              <ChartContainer config={atencionesChartConfig} className="h-64 w-full">
                <AreaChart accessibilityLayer data={atencionesData}>
                  <CartesianGrid vertical={false} />
                  <XAxis dataKey="day" tickLine={false} axisLine={false} tickMargin={8} fontSize={12} />
                  <YAxis />
                  <ChartTooltip content={<ChartTooltipContent />} />
                  <defs>
                    <linearGradient id="fillAtenciones" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="var(--color-atenciones)" stopOpacity={0.8} />
                      <stop offset="95%" stopColor="var(--color-atenciones)" stopOpacity={0.1} />
                    </linearGradient>
                  </defs>
                  <Area type="monotone" dataKey="atenciones" stroke="var(--color-atenciones)" fill="url(#fillAtenciones)" />
                </AreaChart>
              </ChartContainer>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle>Producción por Establecimiento</CardTitle>
              <Hospital className="h-6 w-6 text-primary" />
            </CardHeader>
            <CardContent className="flex justify-center">
              <ChartContainer config={produccionChartConfig} className="h-64 w-full">
                <PieChart accessibilityLayer>
                  <ChartTooltip content={<ChartTooltipContent hideLabel />} />
                  <Pie data={produccionData} dataKey="value" nameKey="name" innerRadius={50} strokeWidth={2}>
                  </Pie>
                  <ChartLegend content={<ChartLegendContent nameKey="name" />} />
                </PieChart>
              </ChartContainer>
            </CardContent>
          </Card>

          <Card className="md:col-span-2 lg:col-span-3">
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle>Avance de Digitación</CardTitle>
              <ClipboardCheck className="h-6 w-6 text-primary" />
            </CardHeader>
            <CardContent>
              <ChartContainer config={digitacionChartConfig} className="h-64 w-full">
                <BarChart accessibilityLayer data={digitacionData}>
                  <CartesianGrid vertical={false} />
                  <XAxis dataKey="month" tickLine={false} axisLine={false} tickMargin={8} fontSize={12} />
                  <YAxis tickFormatter={(value) => `${value}%`} />
                  <ChartTooltip content={<ChartTooltipContent />} />
                  <Bar dataKey="avance" fill="var(--color-avance)" radius={4} />
                </BarChart>
              </ChartContainer>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  )
}

export default Stats
