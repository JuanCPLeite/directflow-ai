import { CheckCircle2, CircleDashed, ExternalLink, Layers3, ShieldCheck, Sparkles } from 'lucide-react'

import { env, envReadiness, hasSupabaseEnv } from '@/config/env'
import {
  foundationPhases,
  phaseOneTracks,
  preservedReferences,
} from '@/features/foundation/data/phase-roadmap'
import { cn } from '@/lib/utils'

const statusTone = {
  current: 'border-emerald-300/40 bg-emerald-300/10 text-emerald-100',
  next: 'border-sky-300/30 bg-sky-300/10 text-sky-100',
  planned: 'border-white/10 bg-white/5 text-slate-200',
} as const

export function FoundationPage() {
  return (
    <div className="grid gap-6 lg:grid-cols-[1.35fr_0.95fr]">
      <section className="grid gap-6">
        <article className="overflow-hidden rounded-[28px] border border-white/10 bg-white/5">
          <div className="flex flex-col gap-8 p-6 sm:p-8">
            <div className="flex flex-wrap items-center gap-3 text-xs uppercase tracking-[0.24em] text-slate-400">
              <span>InstaFlow AI</span>
              <span className="h-1 w-1 rounded-full bg-slate-500" />
              <span>Rebuild 2026</span>
            </div>

            <div className="grid gap-6 md:grid-cols-[1.2fr_0.8fr]">
              <div className="space-y-4">
                <h2 className="text-3xl font-semibold tracking-tight text-white">
                  A fundacao nova ja substituiu a casca antiga.
                </h2>
                <p className="max-w-2xl text-sm leading-7 text-slate-300 sm:text-base">
                  Este workspace existe para manter o projeto operacional enquanto a plataforma e
                  reconstruida fase por fase a partir dos documentos em `docs/`. A base anterior
                  era um prototipo parcial; a partir daqui, o repositorio passa a refletir o produto
                  que realmente sera entregue.
                </p>
              </div>

              <div className="rounded-[24px] border border-white/10 bg-slate-950/35 p-5">
                <div className="flex items-center gap-3 text-sm font-medium text-white">
                  <Layers3 className="size-4 text-emerald-300" />
                  Phase 1 build tracks
                </div>
                <div className="mt-4 space-y-4">
                  {phaseOneTracks.map((track) => (
                    <div key={track.title} className="space-y-1">
                      <div className="text-sm font-medium text-slate-100">{track.title}</div>
                      <div className="text-sm leading-6 text-slate-400">{track.body}</div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </article>

        <article className="rounded-[28px] border border-white/10 bg-white/5 p-6 sm:p-8">
          <div className="flex items-center justify-between gap-4">
            <div>
              <div className="text-xs uppercase tracking-[0.24em] text-slate-400">Execution map</div>
              <h3 className="mt-2 text-2xl font-semibold text-white">Primeiras fases do produto</h3>
            </div>
            <div className="inline-flex items-center gap-2 rounded-full border border-amber-300/30 bg-amber-300/10 px-3 py-1 text-xs font-semibold text-amber-100">
              <Sparkles className="size-3.5" />
              Roadmap carregado de `.planning`
            </div>
          </div>

          <div className="mt-6 grid gap-4">
            {foundationPhases.map((phase) => (
              <div
                key={phase.number}
                className={cn(
                  'rounded-[22px] border p-5 transition-colors',
                  statusTone[phase.status],
                )}
              >
                <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                  <div>
                    <div className="text-xs uppercase tracking-[0.22em] opacity-75">
                      Phase {phase.number}
                    </div>
                    <h4 className="mt-2 text-lg font-semibold">{phase.name}</h4>
                    <p className="mt-2 text-sm leading-6 opacity-85">{phase.focus}</p>
                  </div>
                  <div className="inline-flex h-fit items-center rounded-full border border-current/20 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.18em]">
                    {phase.status}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </article>
      </section>

      <aside className="grid gap-6">
        <article className="rounded-[28px] border border-white/10 bg-slate-950/35 p-6">
          <div className="flex items-center gap-3 text-sm font-medium text-white">
            <ShieldCheck className="size-4 text-emerald-300" />
            Environment readiness
          </div>
          <div className="mt-5 space-y-3">
            {envReadiness.map((item) => (
              <div
                key={item.label}
                className="flex items-center justify-between rounded-2xl border border-white/10 bg-white/5 px-4 py-3"
              >
                <span className="text-sm text-slate-200">{item.label}</span>
                <span className="inline-flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.18em] text-slate-300">
                  {item.ready ? (
                    <CheckCircle2 className="size-4 text-emerald-300" />
                  ) : (
                    <CircleDashed className="size-4 text-amber-300" />
                  )}
                  {item.ready ? 'ready' : 'missing'}
                </span>
              </div>
            ))}
          </div>

          <div className="mt-5 rounded-2xl border border-white/10 bg-[#071923] p-4 text-sm leading-6 text-slate-300">
            <div className="font-medium text-white">Supabase bootstrap</div>
            <div className="mt-2">
              {hasSupabaseEnv
                ? 'Frontend contract is present. The app can start consuming Supabase on the next implementation steps.'
                : 'Supabase envs are intentionally optional during Phase 1 so the shell can evolve before production credentials are wired.'}
            </div>
          </div>
        </article>

        <article className="rounded-[28px] border border-white/10 bg-white/5 p-6">
          <div className="text-xs uppercase tracking-[0.24em] text-slate-400">Repository hygiene</div>
          <h3 className="mt-2 text-xl font-semibold text-white">O que fica preservado</h3>
          <ul className="mt-5 space-y-3 text-sm text-slate-300">
            {preservedReferences.map((item) => (
              <li key={item} className="rounded-2xl border border-white/10 bg-white/5 px-4 py-3">
                {item}
              </li>
            ))}
          </ul>
        </article>

        <article className="rounded-[28px] border border-white/10 bg-white/5 p-6">
          <div className="text-xs uppercase tracking-[0.24em] text-slate-400">Live contract</div>
          <h3 className="mt-2 text-xl font-semibold text-white">Current app identity</h3>
          <div className="mt-4 space-y-3 text-sm leading-6 text-slate-300">
            <p>
              <span className="font-medium text-white">App name:</span> {env.appName}
            </p>
            <p>
              <span className="font-medium text-white">Local URL:</span> {env.appUrl ?? 'not set yet'}
            </p>
            <a
              href="https://github.com/JuanCPLeite/directflow-ai"
              target="_blank"
              rel="noreferrer"
              className="inline-flex items-center gap-2 text-emerald-200 transition hover:text-emerald-100"
            >
              Repositorio GitHub
              <ExternalLink className="size-4" />
            </a>
          </div>
        </article>
      </aside>
    </div>
  )
}
