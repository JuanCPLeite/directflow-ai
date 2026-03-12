import { Link } from 'react-router-dom'

import { envReadiness } from '@/config/env'
import { signOut } from '@/features/auth/lib/auth'
import { useAuth } from '@/features/auth/providers/useAuth'

export function AppHomePage() {
  const { user } = useAuth()

  const handleSignOut = async () => {
    try {
      await signOut()
    } catch (error) {
      console.error('Failed to sign out', error)
    }
  }

  return (
    <div className="min-h-screen bg-[linear-gradient(180deg,_#081117_0%,_#10212c_48%,_#112938_100%)] px-6 py-8 text-slate-100">
      <div className="mx-auto max-w-7xl space-y-6">
        <header className="flex flex-col gap-4 rounded-[28px] border border-white/10 bg-white/5 p-6 lg:flex-row lg:items-center lg:justify-between">
          <div>
            <div className="text-xs uppercase tracking-[0.24em] text-emerald-200">workspace active</div>
            <h1 className="mt-3 text-3xl font-semibold tracking-tight text-white">
              Bem-vindo, {user?.user_metadata.full_name ?? user?.email ?? 'operador'}
            </h1>
            <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-300">
              O microsaas ja esta com autenticacao real via Supabase. Agora a proxima camada e ligar onboarding,
              trial e os modulos operacionais em cima desta sessao.
            </p>
          </div>

          <div className="flex flex-wrap gap-3">
            <Link
              to="/"
              className="rounded-2xl border border-white/10 px-4 py-3 text-sm font-medium text-slate-200 transition hover:bg-white/5"
            >
              Ver roadmap
            </Link>
            <button
              type="button"
              onClick={handleSignOut}
              className="rounded-2xl bg-emerald-400 px-4 py-3 text-sm font-semibold text-slate-950 transition hover:bg-emerald-300"
            >
              Sair
            </button>
          </div>
        </header>

        <section className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
          <article className="rounded-[28px] border border-white/10 bg-white/5 p-6">
            <div className="text-xs uppercase tracking-[0.24em] text-slate-400">Conta atual</div>
            <div className="mt-4 grid gap-4 sm:grid-cols-2">
              <div className="rounded-2xl border border-white/10 bg-slate-950/30 p-4">
                <div className="text-[11px] uppercase tracking-[0.2em] text-slate-400">Email</div>
                <div className="mt-2 text-sm text-slate-100">{user?.email ?? 'Nao informado'}</div>
              </div>
              <div className="rounded-2xl border border-white/10 bg-slate-950/30 p-4">
                <div className="text-[11px] uppercase tracking-[0.2em] text-slate-400">Provedor</div>
                <div className="mt-2 text-sm text-slate-100">
                  {user?.app_metadata.provider ?? 'email'}
                </div>
              </div>
            </div>
          </article>

          <article className="rounded-[28px] border border-white/10 bg-white/5 p-6">
            <div className="text-xs uppercase tracking-[0.24em] text-slate-400">Readiness</div>
            <div className="mt-4 space-y-3">
              {envReadiness.map((item) => (
                <div
                  key={item.label}
                  className="flex items-center justify-between rounded-2xl border border-white/10 bg-slate-950/30 px-4 py-3 text-sm"
                >
                  <span className="text-slate-200">{item.label}</span>
                  <span className={item.ready ? 'text-emerald-300' : 'text-amber-300'}>
                    {item.ready ? 'ok' : 'pendente'}
                  </span>
                </div>
              ))}
            </div>
          </article>
        </section>
      </div>
    </div>
  )
}
