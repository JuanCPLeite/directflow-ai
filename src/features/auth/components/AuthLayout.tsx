import type { PropsWithChildren } from 'react'
import { Link } from 'react-router-dom'

type AuthLayoutProps = PropsWithChildren<{
  title: string
  subtitle: string
}>

export function AuthLayout({ title, subtitle, children }: AuthLayoutProps) {
  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(56,189,248,0.12),_transparent_30%),linear-gradient(180deg,_#081117_0%,_#0d1d26_48%,_#132837_100%)] text-slate-100">
      <div className="mx-auto grid min-h-screen max-w-7xl gap-10 px-6 py-8 lg:grid-cols-[1.05fr_0.95fr] lg:px-10">
        <section className="flex flex-col justify-between rounded-[32px] border border-white/10 bg-white/5 p-8 backdrop-blur">
          <div className="space-y-6">
            <Link
              to="/"
              className="inline-flex items-center rounded-full border border-emerald-300/30 bg-emerald-300/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.24em] text-emerald-200"
            >
              InstaFlow AI
            </Link>
            <div className="space-y-4">
              <h1 className="max-w-xl text-4xl font-semibold tracking-tight text-white sm:text-5xl">
                Atendimento, automacao e vendas no Instagram em um unico workspace.
              </h1>
              <p className="max-w-2xl text-sm leading-7 text-slate-300 sm:text-base">
                Conecte sua operacao, configure agentes de IA, centralize leads e dispare campanhas
                com uma base feita para o Brasil. O acesso abaixo ja usa Supabase Auth e prepara o
                terreno para onboarding, trial e ligacao com Meta OAuth nas proximas fases.
              </p>
            </div>
          </div>

          <div className="grid gap-4 sm:grid-cols-3">
            <div className="rounded-2xl border border-white/10 bg-slate-950/35 p-4">
              <div className="text-[11px] uppercase tracking-[0.22em] text-slate-400">Google</div>
              <div className="mt-2 text-sm text-slate-200">Entrar ou cadastrar em um clique</div>
            </div>
            <div className="rounded-2xl border border-white/10 bg-slate-950/35 p-4">
              <div className="text-[11px] uppercase tracking-[0.22em] text-slate-400">Email</div>
              <div className="mt-2 text-sm text-slate-200">Fluxo classico para signup e login</div>
            </div>
            <div className="rounded-2xl border border-white/10 bg-slate-950/35 p-4">
              <div className="text-[11px] uppercase tracking-[0.22em] text-slate-400">Workspace</div>
              <div className="mt-2 text-sm text-slate-200">Area protegida pronta para crescer</div>
            </div>
          </div>
        </section>

        <section className="flex items-center">
          <div className="w-full rounded-[32px] border border-white/10 bg-white p-8 text-slate-900 shadow-2xl shadow-slate-950/30">
            <div className="mb-8 space-y-2">
              <h2 className="text-3xl font-semibold tracking-tight">{title}</h2>
              <p className="text-sm leading-6 text-slate-500">{subtitle}</p>
            </div>
            {children}
          </div>
        </section>
      </div>
    </div>
  )
}
