// ===========================================
// ConversionsChart.tsx — Gráfico de conversões
// ===========================================

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from 'recharts'

// Dados de exemplo (serão substituídos por dados reais do Supabase)
const data = [
  { dia: 'Seg', mensagens: 320, leads: 45, conversoes: 12 },
  { dia: 'Ter', mensagens: 280, leads: 38, conversoes: 9  },
  { dia: 'Qua', mensagens: 410, leads: 62, conversoes: 18 },
  { dia: 'Qui', mensagens: 390, leads: 55, conversoes: 15 },
  { dia: 'Sex', mensagens: 480, leads: 71, conversoes: 22 },
  { dia: 'Sab', mensagens: 210, leads: 29, conversoes: 7  },
  { dia: 'Dom', mensagens: 190, leads: 24, conversoes: 6  },
]

export default function ConversionsChart() {
  return (
    <div className="bg-card border border-border rounded-xl p-5">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-semibold text-foreground">Conversões por Dia</h3>
          <p className="text-xs text-muted-foreground mt-0.5">Últimos 7 dias</p>
        </div>
      </div>

      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={data} margin={{ top: 5, right: 10, left: -20, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" className="stroke-border" />
          <XAxis
            dataKey="dia"
            tick={{ fontSize: 12, fill: 'hsl(var(--muted-foreground))' }}
            axisLine={false}
            tickLine={false}
          />
          <YAxis
            tick={{ fontSize: 12, fill: 'hsl(var(--muted-foreground))' }}
            axisLine={false}
            tickLine={false}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: 'hsl(var(--card))',
              border: '1px solid hsl(var(--border))',
              borderRadius: '8px',
              fontSize: '12px',
            }}
          />
          <Legend
            wrapperStyle={{ fontSize: '12px', paddingTop: '16px' }}
          />
          <Line
            type="monotone"
            dataKey="mensagens"
            name="Mensagens"
            stroke="#6366f1"
            strokeWidth={2}
            dot={false}
            activeDot={{ r: 4 }}
          />
          <Line
            type="monotone"
            dataKey="leads"
            name="Leads"
            stroke="#8b5cf6"
            strokeWidth={2}
            dot={false}
            activeDot={{ r: 4 }}
          />
          <Line
            type="monotone"
            dataKey="conversoes"
            name="Conversões"
            stroke="#10b981"
            strokeWidth={2}
            dot={false}
            activeDot={{ r: 4 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
