"use client"

import * as React from "react"

import { cn } from "@/lib/utils"

// This component is a placeholder and is not meant to be used, as charts were removed.
// It is kept to avoid breaking the build if it were imported somewhere.

export type ChartConfig = {
  [k in string]: {
    label?: React.ReactNode
    icon?: React.ComponentType
  } & (
    | { color?: string; theme?: never }
    | { color?: never; theme: Record<string, string> }
  )
}

const ChartContainer = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & {
    config: ChartConfig
    children: React.ReactNode
  }
>(({ className, children, ...props }, ref) => (
  <div ref={ref} className={cn("flex aspect-video justify-center text-xs", className)} {...props}>
    {children}
  </div>
))
ChartContainer.displayName = "ChartContainer"

const ChartTooltip = () => null
ChartTooltip.displayName = "ChartTooltip"

const ChartTooltipContent = () => null
ChartTooltipContent.displayName = "ChartTooltipContent"

const ChartLegend = () => null
ChartLegend.displayName = "ChartLegend"

const ChartLegendContent = () => null
ChartLegendContent.displayName = "ChartLegendContent"

const ChartStyle = () => null
ChartStyle.displayName = "ChartStyle"

export {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
  ChartLegend,
  ChartLegendContent,
  ChartStyle,
}
