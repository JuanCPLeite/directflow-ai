// ===========================================
// Sidebar.tsx — Menu lateral de navegação
// ===========================================

import { useState } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import { cn } from '../../lib/utils'
import { useAuthStore } from '../../store/authStore'
import { supabase } from '../../lib/supabase'
import {
  LayoutDashboard,
  Bot,
  Users,
  Workflow,
  MessageSquare,
  Megaphone,
  BarChart3,
  Settings,
  ChevronLeft,
  ChevronRight,
  LogOut,
  Zap,
} from 'lucide-react'

// Itens do menu de navegação
const navItems = [
  { to: '/dashboard',  icon: LayoutDashboard, label: 'Dashboard'     },
  { to: '/agents',     icon: Bot,             label: 'Agentes de IA' },
  { to: '/crm',        icon: Users,           label: 'CRM'           },
  { to: '/flows',      icon: Workflow,        label: 'Fluxos'        },
  { to: '/keywords',   icon: Zap,             label: 'Keywords'      },
  { to: '/broadcasts', icon: Megaphone,       label: 'Broadcasts'    },
  { to: '/analytics',  icon: BarChart3,       label: 'Analytics'     },
  { to: '/settings',   icon: Settings,        label: 'Configurações' },
]

export default function Sidebar() {
  // Controla se o sidebar está recolhido (ícones apenas) ou expandido
  const [collapsed, setCollapsed] = useState(false)
  const { clear } = useAuthStore()
  const navigate = useNavigate()

  async function handleSignOut() {
    await supabase.auth.signOut()
    clear()
    navigate('/login')
  }

  return (
    <aside
      className={cn(
        'flex flex-col h-screen bg-card border-r border-border transition-all duration-300 relative',
        collapsed ? 'w-16' : 'w-60'
      )}
    >
      {/* Logo */}
      <div className="flex items-center gap-3 px-4 py-5 border-b border-border">
        <div className="flex-shrink-0 w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
          <span className="text-sm">🤖</span>
        </div>
        {!collapsed && (
          <div>
            <span className="font-bold text-sm text-foreground">DirectFlow AI</span>
          </div>
        )}
      </div>

      {/* Navegação principal */}
      <nav className="flex-1 px-2 py-4 space-y-1 overflow-y-auto">
        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              cn(
                'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors',
                'hover:bg-accent hover:text-accent-foreground',
                isActive
                  ? 'bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground'
                  : 'text-muted-foreground',
                collapsed && 'justify-center px-0'
              )
            }
            title={collapsed ? item.label : undefined}
          >
            <item.icon size={18} className="flex-shrink-0" />
            {!collapsed && <span>{item.label}</span>}
          </NavLink>
        ))}
      </nav>

      {/* Botão de logout */}
      <div className="px-2 py-4 border-t border-border">
        <button
          onClick={handleSignOut}
          className={cn(
            'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium w-full',
            'text-muted-foreground hover:bg-destructive/10 hover:text-destructive transition-colors',
            collapsed && 'justify-center px-0'
          )}
          title={collapsed ? 'Sair' : undefined}
        >
          <LogOut size={18} className="flex-shrink-0" />
          {!collapsed && <span>Sair</span>}
        </button>
      </div>

      {/* Botão de recolher/expandir */}
      <button
        onClick={() => setCollapsed(!collapsed)}
        className="absolute -right-3 top-20 w-6 h-6 rounded-full bg-card border border-border flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-accent transition-colors shadow-sm"
        title={collapsed ? 'Expandir menu' : 'Recolher menu'}
      >
        {collapsed ? <ChevronRight size={12} /> : <ChevronLeft size={12} />}
      </button>
    </aside>
  )
}
