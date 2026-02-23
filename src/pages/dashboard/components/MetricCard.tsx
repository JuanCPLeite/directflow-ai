// ===========================================
// MetricCard.tsx — Card de métrica individual
// ===========================================

import { TrendingUp, TrendingDown, type LucideIcon } from 'lucide-react'
import { cn } from '../../../lib/utils'

interface MetricCardProps {
  title: string
  value: string
  change: string
  trend: 'up' | 'down'
  icon: LucideIcon
  iconColor: string
  iconBg: string
}

export default function MetricCard({
  title,
  value,
  change,
  trend,
  icon: Icon,
  iconColor,
  iconBg,
}: MetricCardProps) {
  return (
    <div className="bg-card border border-border rounded-xl p-5 flex items-start justify-between">
      {/* Texto da métrica */}
      <div>
        <p className="text-sm text-muted-foreground">{title}</p>
        <p className="text-2xl font-bold text-foreground mt-1">{value}</p>

        {/* Variação vs período anterior */}
        <div className={cn(
          'flex items-center gap-1 mt-1.5 text-xs font-medium',
          trend === 'up' ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'
        )}>
          {trend === 'up'
            ? <TrendingUp size={12} />
            : <TrendingDown size={12} />
          }
          <span>{change} vs mês anterior</span>
        </div>
      </div>

      {/* Ícone */}
      <div className={cn('p-3 rounded-xl', iconBg)}>
        <Icon size={20} className={iconColor} />
      </div>
    </div>
  )
}
