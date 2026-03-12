import { useState } from 'react'
import { Link, Navigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Chrome } from 'lucide-react'
import { z } from 'zod'

import { hasSupabaseEnv } from '@/config/env'
import { AuthLayout } from '@/features/auth/components/AuthLayout'
import { signInWithOAuth, signUpWithPassword } from '@/features/auth/lib/auth'
import { useAuth } from '@/features/auth/providers/useAuth'

const registerSchema = z
  .object({
    fullName: z.string().min(3, 'Informe seu nome completo'),
    email: z.email('Informe um email valido'),
    password: z.string().min(6, 'A senha precisa ter pelo menos 6 caracteres'),
    confirmPassword: z.string().min(6, 'Confirme sua senha'),
  })
  .refine((data) => data.password === data.confirmPassword, {
    path: ['confirmPassword'],
    message: 'As senhas precisam ser iguais',
  })

type RegisterFormData = z.infer<typeof registerSchema>

export function RegisterPage() {
  const { user, isLoading } = useAuth()
  const [errorMessage, setErrorMessage] = useState<string | null>(null)
  const [successMessage, setSuccessMessage] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [isGoogleLoading, setIsGoogleLoading] = useState(false)

  const form = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      fullName: '',
      email: '',
      password: '',
      confirmPassword: '',
    },
  })

  if (!isLoading && user) {
    return <Navigate to="/app" replace />
  }

  const disabled = !hasSupabaseEnv

  const onSubmit = form.handleSubmit(async ({ confirmPassword, ...values }) => {
    setErrorMessage(null)
    setSuccessMessage(null)
    setIsSubmitting(true)

    void confirmPassword

    try {
      await signUpWithPassword(values)
      setSuccessMessage('Conta criada. Verifique seu email para concluir o acesso.')
      form.reset()
    } catch (error) {
      setErrorMessage(error instanceof Error ? error.message : 'Nao foi possivel criar a conta.')
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

  return (
    <AuthLayout
      title="Criar sua conta"
      subtitle="Comece com email e senha ou use seu Google para entrar no microsaas."
    >
      <div className="space-y-5">
        <button
          type="button"
          onClick={handleGoogle}
          disabled={disabled || isGoogleLoading}
          className="flex w-full items-center justify-center gap-3 rounded-2xl border border-slate-200 px-4 py-3 text-sm font-medium transition hover:border-slate-300 hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-60"
        >
          <Chrome className="size-4" />
          {isGoogleLoading ? 'Redirecionando...' : 'Cadastrar com Google'}
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
            <label className="text-sm font-medium text-slate-700" htmlFor="fullName">
              Nome completo
            </label>
            <input
              id="fullName"
              type="text"
              autoComplete="name"
              {...form.register('fullName')}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
            />
            {form.formState.errors.fullName ? (
              <p className="text-sm text-rose-600">{form.formState.errors.fullName.message}</p>
            ) : null}
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-slate-700" htmlFor="registerEmail">
              Email
            </label>
            <input
              id="registerEmail"
              type="email"
              autoComplete="email"
              {...form.register('email')}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
            />
            {form.formState.errors.email ? (
              <p className="text-sm text-rose-600">{form.formState.errors.email.message}</p>
            ) : null}
          </div>

          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-2">
              <label className="text-sm font-medium text-slate-700" htmlFor="registerPassword">
                Senha
              </label>
              <input
                id="registerPassword"
                type="password"
                autoComplete="new-password"
                {...form.register('password')}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
              />
              {form.formState.errors.password ? (
                <p className="text-sm text-rose-600">{form.formState.errors.password.message}</p>
              ) : null}
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium text-slate-700" htmlFor="confirmPassword">
                Confirmar senha
              </label>
              <input
                id="confirmPassword"
                type="password"
                autoComplete="new-password"
                {...form.register('confirmPassword')}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-emerald-400"
              />
              {form.formState.errors.confirmPassword ? (
                <p className="text-sm text-rose-600">{form.formState.errors.confirmPassword.message}</p>
              ) : null}
            </div>
          </div>

          {successMessage ? (
            <div className="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-700">
              {successMessage}
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
            {isSubmitting ? 'Criando conta...' : 'Criar conta com email'}
          </button>
        </form>

        <p className="text-sm text-slate-500">
          Ja tem conta?{' '}
          <Link to="/login" className="font-medium text-emerald-700 hover:text-emerald-800">
            Entrar agora
          </Link>
        </p>
      </div>
    </AuthLayout>
  )
}
