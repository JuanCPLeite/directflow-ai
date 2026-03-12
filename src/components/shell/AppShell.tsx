import type { PropsWithChildren } from 'react'

type AppShellProps = PropsWithChildren<{
  eyebrow: string
  title: string
  description: string
}>

export function AppShell({ eyebrow, title, description, children }: AppShellProps) {
  return (
    <div className="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(32,197,177,0.16),_transparent_34%),linear-gradient(180deg,_#06131a_0%,_#091b23_48%,_#0f2531_100%)] text-slate-100">
      <div className="mx-auto flex min-h-screen max-w-7xl flex-col px-6 py-8 sm:px-8 lg:px-10">
        <header className="flex flex-col gap-6 border-b border-white/10 pb-8 lg:flex-row lg:items-end lg:justify-between">
          <div className="max-w-3xl space-y-4">
            <div className="inline-flex items-center rounded-full border border-emerald-300/30 bg-emerald-300/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.24em] text-emerald-200">
              {eyebrow}
            </div>
            <div className="space-y-3">
              <h1 className="max-w-4xl text-4xl font-semibold tracking-tight text-white sm:text-5xl">
                {title}
              </h1>
              <p className="max-w-2xl text-sm leading-7 text-slate-300 sm:text-base">{description}</p>
            </div>
          </div>
          <div className="grid gap-3 text-sm text-slate-300 sm:grid-cols-2 lg:min-w-[320px]">
            <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
              <div className="text-[11px] uppercase tracking-[0.22em] text-slate-400">Workspace</div>
              <div className="mt-2 font-medium text-white">Phase 1 em execucao</div>
              <div className="mt-1 text-slate-400">Foundation and Platform Setup</div>
            </div>
            <div className="rounded-2xl border border-white/10 bg-white/5 p-4">
              <div className="text-[11px] uppercase tracking-[0.22em] text-slate-400">Servidor</div>
              <div className="mt-2 font-medium text-white">localhost:8081</div>
              <div className="mt-1 text-slate-400">Ambiente de desenvolvimento</div>
            </div>
          </div>
        </header>

        <main className="flex-1 py-8">{children}</main>
      </div>
    </div>
  )
}
