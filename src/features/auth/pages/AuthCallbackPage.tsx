import { useEffect, useState } from 'react'
import { Navigate } from 'react-router-dom'

import { supabase } from '@/lib/supabase'

export function AuthCallbackPage() {
  const [status, setStatus] = useState<'loading' | 'error' | 'done'>('loading')
  const [message, setMessage] = useState('Finalizando autenticacao...')

  useEffect(() => {
    let isActive = true

    const run = async () => {
      if (!supabase) {
        if (!isActive) return
        setMessage('Supabase nao esta configurado neste ambiente.')
        setStatus('error')
        return
      }

      const code = new URL(window.location.href).searchParams.get('code')

      try {
        if (code) {
          const { error } = await supabase.auth.exchangeCodeForSession(code)
          if (error) throw error
        }

        if (!isActive) return
        setStatus('done')
      } catch (error) {
        if (!isActive) return
        setMessage(error instanceof Error ? error.message : 'Falha ao concluir o login.')
        setStatus('error')
      }
    }

    void run()

    return () => {
      isActive = false
    }
  }, [])

  if (status === 'done') {
    return <Navigate to="/app" replace />
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-950 px-6 text-slate-100">
      <div className="w-full max-w-md rounded-3xl border border-white/10 bg-white/5 p-8 text-center">
        <div className="text-sm uppercase tracking-[0.24em] text-slate-400">Auth callback</div>
        <h1 className="mt-4 text-2xl font-semibold text-white">{message}</h1>
        <p className="mt-3 text-sm leading-6 text-slate-400">
          {status === 'loading'
            ? 'Aguarde alguns segundos enquanto a sessao e trocada com o Supabase.'
            : 'Revise as configuracoes do provedor OAuth no Supabase e tente novamente.'}
        </p>
      </div>
    </div>
  )
}
