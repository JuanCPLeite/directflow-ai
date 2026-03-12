import { useState } from 'react'
import { Link, Navigate, useLocation } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Chrome } from 'lucide-react'
import { z } from 'zod'

import { hasSupabaseEnv } from '@/config/env'
import { AuthLayout } from '@/features/auth/components/AuthLayout'
import { signInWithOAuth, signInWithPassword } from '@/features/auth/lib/auth'
import { useAuth } from '@/features/auth/providers/useAuth'

const loginSchema = z.object({
  email: z.email('Informe um email valido'),
  password: z.string().min(6, 'A senha precisa ter pelo menos 6 caracteres'),
})

type LoginFormData = z.infer<typeof loginSchema>

export function LoginPage() {
  const location = useLocation()
  const { user, isLoading } = useAuth()
  const [errorMessage, setErrorMessage] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [isGoogleLoading, setIsGoogleLoading] = useState(false)

  const form = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: '',
      password: '',
    },
  })

  if (!isLoading && user) {
    return <Navigate to="/app" replace />
  }

  const disabled = !hasSupabaseEnv

  const onSubmit = form.handleSubmit(async (values) => {
    setErrorMessage(null)
    setIsSubmitting(true)

    try {
      await signInWithPassword(values)
    } catch (error) {
      setErrorMessage(error instanceof Error ? error.message : 'Nao foi possivel entrar.')
    } finally {
      setIsSubmitting(false)
    }
  })

  const handleGoogle = async () => {
    setErrorMessage(null)
    setIsGoogleLoading(true)

    try {
      await signInWithOAuth('google')
    } catch (error) {
      setErrorMessage(error instanceof Error ? error.message : 'Nao foi possivel iniciar o Google.')
      setIsGoogleLoading(false)
    }
  }

  const missingConfigMessage =
    location.state && typeof location.state === 'object' && 'reason' in location.state
      ? 'Configure VITE_SUPABASE_URL e VITE_SUPABASE_ANON_KEY para habilitar o acesso real.'
      : null

  return (
    <AuthLayout
      title="Entrar no workspace"
      subtitle="Acesse sua operacao do InstaFlow AI com email ou Google."
    >
      <div className="space-y-5">
        <button
          type="button"
          onClick={handleGoogle}
          disabled={disabled || isGoogleLoading}
          className="flex w-full items-center justify-center gap-3 rounded-2xl border border-slate-200 px-4 py-3 text-sm font-medium transition hover:border-slate-300 hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-60"
        >
          <Chrome className="size-4" />
          {isGoogleLoading ? 'Redirecionando...' : 'Continuar com Google'}
        </button>

        <div className="relative py-1">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-slate-200" />
          </div>
          <div className="relative flex justify-center text-xs uppercase tracking-[0.22em] text-slate-400">
            <span className="bg-white px-3">ou com email</span>
          </div>
        </div>

        <form className="space-y-4" onSubmit={onSubmit}>
          <div className="space-y-2">
            <label className="text-sm font-medium text-slate-700" htmlFor="email">
              Email
            </label>
            <input
              id="email"
              type="email"
              autoComplete="email"
              {...form.register('email')}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
            />
            {form.formState.errors.email ? (
              <p className="text-sm text-rose-600">{form.formState.errors.email.message}</p>
            ) : null}
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-slate-700" htmlFor="password">
              Senha
            </label>
            <input
              id="password"
              type="password"
              autoComplete="current-password"
              {...form.register('password')}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
            />
            {form.formState.errors.password ? (
              <p className="text-sm text-rose-600">{form.formState.errors.password.message}</p>
            ) : null}
          </div>

          {missingConfigMessage ? (
            <div className="rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800">
              {missingConfigMessage}
            </div>
          ) : null}

          {errorMessage ? (
            <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700">
              {errorMessage}
            </div>
          ) : null}

          <button
            type="submit"
            disabled={disabled || isSubmitting}
            className="w-full rounded-2xl bg-slate-950 px-4 py-3 text-sm font-medium text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isSubmitting ? 'Entrando...' : 'Entrar com email'}
          </button>
        </form>

        <p className="text-sm text-slate-500">
          Ainda nao tem conta?{' '}
          <Link to="/register" className="font-medium text-emerald-700 hover:text-emerald-800">
            Criar acesso agora
          </Link>
        </p>
      </div>
    </AuthLayout>
  )
}
