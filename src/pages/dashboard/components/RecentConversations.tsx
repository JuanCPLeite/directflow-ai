// ===========================================
// RecentConversations.tsx — Conversas recentes
// ===========================================

import { MessageSquare, Bot, User } from 'lucide-react'
import { timeAgo } from '../../../lib/utils'

// Dados de exemplo (serão substituídos por dados reais)
const conversations = [
  {
    id: '1',
    lead: 'Maria Silva',
    username: '@mariasilva',
    lastMessage: 'Olá, gostaria de saber mais sobre os produtos...',
    time: new Date(Date.now() - 2 * 60 * 1000).toISOString(),
    type: 'agent' as const,
    status: 'active' as const,
  },
  {
    id: '2',
    lead: 'João Santos',
    username: '@joaosantos',
    lastMessage: 'Qual o preço do kit premium?',
    time: new Date(Date.now() - 5 * 60 * 1000).toISOString(),
    type: 'agent' as const,
    status: 'active' as const,
  },
  {
    id: '3',
    lead: 'Ana Costa',
    username: '@anacosta',
    lastMessage: 'Vocês fazem entrega para Curitiba?',
    time: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
    type: 'human' as const,
    status: 'active' as const,
  },
  {
    id: '4',
    lead: 'Pedro Lima',
    username: '@pedrolima',
    lastMessage: 'Obrigado! Vou pensar e volto logo.',
    time: new Date(Date.now() - 32 * 60 * 1000).toISOString(),
    type: 'agent' as const,
    status: 'resolved' as const,
  },
  {
    id: '5',
    lead: 'Carla Souza',
    username: '@carlasouza',
    lastMessage: 'Quero fazer um pedido de 3 kits!',
    time: new Date(Date.now() - 48 * 60 * 1000).toISOString(),
    type: 'agent' as const,
    status: 'active' as const,
  },
]

const statusConfig = {
  active:   { label: 'Ativo',    className: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' },
  resolved: { label: 'Resolvido', className: 'bg-muted text-muted-foreground' },
  transferred: { label: 'Transferido', className: 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400' },
}

export default function RecentConversations() {
  return (
    <div className="bg-card border border-border rounded-xl p-5">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-semibold text-foreground">Conversas Recentes</h3>
          <p className="text-xs text-muted-foreground mt-0.5">Últimas interações</p>
        </div>
        <button className="text-xs text-primary hover:underline font-medium">
          Ver todas →
        </button>
      </div>

      <div className="divide-y divide-border">
        {conversations.map((conv) => {
          const status = statusConfig[conv.status]
          return (
            <div
              key={conv.id}
              className="flex items-start gap-3 py-3 hover:bg-muted/50 -mx-2 px-2 rounded-lg cursor-pointer transition-colors"
            >
              {/* Avatar com inicial */}
              <div className="w-9 h-9 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0 mt-0.5">
                <span className="text-sm font-semibold text-primary">
                  {conv.lead.charAt(0)}
                </span>
              </div>

              {/* Conteúdo */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between gap-2">
                  <div className="flex items-center gap-2 min-w-0">
                    <span className="text-sm font-medium text-foreground truncate">
                      {conv.lead}
                    </span>
                    <span className="text-xs text-muted-foreground hidden sm:block">
                      {conv.username}
                    </span>
                  </div>
                  <span className="text-xs text-muted-foreground flex-shrink-0">
                    {timeAgo(conv.time)}
                  </span>
                </div>

                <p className="text-xs text-muted-foreground truncate mt-0.5">
                  {conv.lastMessage}
                </p>

                <div className="flex items-center gap-2 mt-1.5">
                  {/* Tipo: bot ou humano */}
                  <span className="flex items-center gap-1 text-xs text-muted-foreground">
                    {conv.type === 'agent'
                      ? <><Bot size={11} /> Bot</>
                      : <><User size={11} /> Humano</>
                    }
                  </span>

                  {/* Status */}
                  <span className={`text-xs px-1.5 py-0.5 rounded font-medium ${status.className}`}>
                    {status.label}
                  </span>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
