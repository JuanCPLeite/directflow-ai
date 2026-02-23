// ===========================================
// SalesFunnel.tsx — Funil de vendas
// ===========================================

const stages = [
  { label: 'Novo Lead',   count: 245, color: 'bg-indigo-500',  pct: 100 },
  { label: 'Contato',     count: 123, color: 'bg-purple-500',  pct: 50  },
  { label: 'Negociação',  count: 67,  color: 'bg-blue-500',    pct: 27  },
  { label: 'Proposta',    count: 45,  color: 'bg-cyan-500',    pct: 18  },
  { label: 'Fechado',     count: 34,  color: 'bg-emerald-500', pct: 14  },
]

export default function SalesFunnel() {
  return (
    <div className="bg-card border border-border rounded-xl p-5 h-full">
      <div className="mb-4">
        <h3 className="font-semibold text-foreground">Funil de Vendas</h3>
        <p className="text-xs text-muted-foreground mt-0.5">Distribuição atual</p>
      </div>

      <div className="space-y-3">
        {stages.map((stage) => (
          <div key={stage.label}>
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs text-muted-foreground">{stage.label}</span>
              <span className="text-xs font-semibold text-foreground">{stage.count}</span>
            </div>
            <div className="h-2 bg-muted rounded-full overflow-hidden">
              <div
                className={`h-full rounded-full ${stage.color} transition-all duration-500`}
                style={{ width: `${stage.pct}%` }}
              />
            </div>
          </div>
        ))}
      </div>

      {/* Resumo */}
      <div className="mt-5 pt-4 border-t border-border">
        <div className="flex justify-between text-xs">
          <span className="text-muted-foreground">Taxa de conversão</span>
          <span className="font-semibold text-emerald-500">13.9%</span>
        </div>
        <div className="flex justify-between text-xs mt-1">
          <span className="text-muted-foreground">Valor total em negociação</span>
          <span className="font-semibold text-foreground">R$ 201k</span>
        </div>
      </div>
    </div>
  )
}
