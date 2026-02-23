// ===========================================
// Header.tsx — Barra superior do app
// ===========================================

import { useState } from 'react'
import { Bell, ChevronDown, User, Settings, LogOut, Clock } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { cn } from '../../lib/utils'
import { useAuthStore } from '../../store/authStore'
import { supabase } from '../../lib/supabase'
import { formatDate } from '../../lib/utils'

// Badge colorido que mostra o plano atual do usuário
const planLabels: Record<string, { label: string; className: string }> = {
  trial:        { label: 'Trial',        className: 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400' },
  starter:      { label: 'Starter',      className: 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400' },
  professional: { label: 'Pro',          className: 'bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400' },
  business:     { label: 'Business',     className: 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400' },
  enterprise:   { label: 'Enterprise',   className: 'bg-primary/10 text-primary' },
}

interface HeaderProps {
  // Título da página atual (ex: "Dashboard", "CRM", etc.)
  title: string
}

export default function Header({ title }: HeaderProps) {
  const [userMenuOpen, setUserMenuOpen] = useState(false)
  const { profile, user, clear } = useAuthStore()
  const navigate = useNavigate()

  const plan = planLabels[profile?.plan ?? 'trial']
  const displayName = profile?.full_name ?? user?.email ?? 'Usuário'

  // Calcula quantos dias faltam no trial
  const trialDaysLeft = profile?.trial_ends_at
    ? Math.max(0, Math.ceil((new Date(profile.trial_ends_at).getTime() - Date.now()) / 86400000))
    : null

  async function handleSignOut() {
    await supabase.auth.signOut()
    clear()
    navigate('/login')
  }

  return (
    <header className="h-14 border-b border-border bg-card flex items-center justify-between px-6">
      {/* Título da página */}
      <h1 className="text-lg font-semibold text-foreground">{title}</h1>

      <div className="flex items-center gap-3">
        {/* Aviso de trial expirando (aparece apenas nos últimos 3 dias) */}
        {profile?.plan === 'trial' && trialDaysLeft !== null && trialDaysLeft <= 3 && (
          <div className="flex items-center gap-1.5 text-xs bg-amber-50 dark:bg-amber-900/20 text-amber-700 dark:text-amber-400 border border-amber-200 dark:border-amber-800 px-3 py-1.5 rounded-full">
            <Clock size={12} />
            <span>
              {trialDaysLeft === 0
                ? 'Trial expira hoje!'
                : `Trial expira em ${trialDaysLeft} dia${trialDaysLeft > 1 ? 's' : ''}`}
            </span>
          </div>
        )}

        {/* Notificações (placeholder por enquanto) */}
        <button className="relative p-2 text-muted-foreground hover:text-foreground rounded-lg hover:bg-accent transition-colors">
          <Bell size={18} />
          {/* Badge de notificações não lidas */}
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-primary rounded-full" />
        </button>

        {/* Menu do usuário */}
        <div className="relative">
          <button
            onClick={() => setUserMenuOpen(!userMenuOpen)}
            className="flex items-center gap-2 px-3 py-1.5 rounded-lg hover:bg-accent transition-colors"
          >
            {/* Avatar (iniciais do nome) */}
            <div className="w-7 h-7 rounded-full bg-primary flex items-center justify-center">
              <span className="text-xs font-semibold text-primary-foreground">
                {displayName.charAt(0).toUpperCase()}
              </span>
            </div>

            {/* Nome e plano */}
            <div className="text-left hidden sm:block">
              <p className="text-sm font-medium text-foreground leading-none">{displayName}</p>
              <span className={cn('text-xs px-1.5 py-0.5 rounded font-medium', plan.className)}>
                {plan.label}
              </span>
            </div>

            <ChevronDown size={14} className="text-muted-foreground" />
          </button>

          {/* Dropdown menu */}
          {userMenuOpen && (
            <>
              {/* Overlay invisível para fechar ao clicar fora */}
              <div
                className="fixed inset-0 z-10"
                onClick={() => setUserMenuOpen(false)}
              />

              <div className="absolute right-0 mt-2 w-56 bg-card border border-border rounded-xl shadow-lg z-20 overflow-hidden">
                {/* Info do usuário */}
                <div className="px-4 py-3 border-b border-border">
                  <p className="text-sm font-medium text-foreground">{displayName}</p>
                  <p className="text-xs text-muted-foreground truncate">{user?.email}</p>
                  {profile?.plan === 'trial' && profile.trial_ends_at && (
                    <p className="text-xs text-amber-600 mt-0.5">
                      Trial até {formatDate(profile.trial_ends_at)}
                    </p>
                  )}
                </div>

                {/* Opções */}
                <div className="py-1">
                  <button
                    onClick={() => { navigate('/settings'); setUserMenuOpen(false) }}
                    className="flex items-center gap-2 w-full px-4 py-2 text-sm text-foreground hover:bg-accent transition-colors"
                  >
                    <User size={15} />
                    Meu perfil
                  </button>
                  <button
                    onClick={() => { navigate('/settings'); setUserMenuOpen(false) }}
                    className="flex items-center gap-2 w-full px-4 py-2 text-sm text-foreground hover:bg-accent transition-colors"
                  >
                    <Settings size={15} />
                    Configurações
                  </button>
                </div>

                <div className="py-1 border-t border-border">
                  <button
                    onClick={handleSignOut}
                    className="flex items-center gap-2 w-full px-4 py-2 text-sm text-destructive hover:bg-destructive/10 transition-colors"
                  >
                    <LogOut size={15} />
                    Sair
                  </button>
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  )
}
