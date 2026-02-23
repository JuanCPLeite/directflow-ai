// ===========================================
// RegisterPage.tsx — Tela de cadastro
// ===========================================

import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Eye, EyeOff, Loader2, Check } from 'lucide-react'
import { supabase } from '../../lib/supabase'

// Schema de validação
const registerSchema = z.object({
  fullName: z.string().min(3, 'Nome deve ter pelo menos 3 caracteres'),
  email: z.string().email('Email inválido'),
  password: z
    .string()
    .min(8, 'Senha deve ter pelo menos 8 caracteres')
    .regex(/[A-Z]/, 'Deve conter pelo menos uma letra maiúscula')
    .regex(/[0-9]/, 'Deve conter pelo menos um número'),
  companyName: z.string().min(2, 'Nome da empresa obrigatório'),
  acceptTerms: z.boolean().refine((v) => v === true, 'Você precisa aceitar os termos'),
})

type RegisterFormData = z.infer<typeof registerSchema>

// Critérios de senha para exibir visualmente
const passwordCriteria = [
  { label: 'Pelo menos 8 caracteres', test: (p: string) => p.length >= 8 },
  { label: 'Uma letra maiúscula', test: (p: string) => /[A-Z]/.test(p) },
  { label: 'Um número', test: (p: string) => /[0-9]/.test(p) },
]

export default function RegisterPage() {
  const navigate = useNavigate()
  const [showPassword, setShowPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [password, setPassword] = useState('')

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
  })

  async function onSubmit(data: RegisterFormData) {
    setIsLoading(true)
    setError(null)

    const { error: authError } = await supabase.auth.signUp({
      email: data.email,
      password: data.password,
      options: {
        data: {
          full_name: data.fullName,
          company_name: data.companyName,
        },
      },
    })

    if (authError) {
      if (authError.message.includes('already registered')) {
        setError('Este email já está cadastrado. Faça login ou recupere sua senha.')
      } else {
        setError('Erro ao criar conta. Tente novamente.')
      }
      setIsLoading(false)
      return
    }

    // Redireciona para o dashboard após cadastro
    navigate('/dashboard')
  }

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md">

        {/* Logo */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-primary mb-4">
            <span className="text-2xl">🤖</span>
          </div>
          <h1 className="text-2xl font-bold text-foreground">DirectFlow AI</h1>
          <p className="text-muted-foreground mt-1">Comece seu trial grátis de 14 dias</p>
        </div>

        {/* Card do formulário */}
        <div className="bg-card border border-border rounded-xl p-8 shadow-sm">
          <h2 className="text-xl font-semibold text-foreground mb-6">Criar conta</h2>

          {/* Erro */}
          {error && (
            <div className="bg-destructive/10 border border-destructive/20 text-destructive text-sm rounded-lg p-3 mb-4">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            {/* Nome completo */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">
                Nome completo
              </label>
              <input
                {...register('fullName')}
                type="text"
                placeholder="João Silva"
                className="w-full px-3 py-2.5 bg-background border border-input rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring text-sm"
              />
              {errors.fullName && (
                <p className="text-destructive text-xs mt-1">{errors.fullName.message}</p>
              )}
            </div>

            {/* Email */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Email</label>
              <input
                {...register('email')}
                type="email"
                placeholder="seu@email.com"
                className="w-full px-3 py-2.5 bg-background border border-input rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring text-sm"
              />
              {errors.email && (
                <p className="text-destructive text-xs mt-1">{errors.email.message}</p>
              )}
            </div>

            {/* Nome da empresa */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">
                Nome da empresa
              </label>
              <input
                {...register('companyName')}
                type="text"
                placeholder="Minha Empresa"
                className="w-full px-3 py-2.5 bg-background border border-input rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring text-sm"
              />
              {errors.companyName && (
                <p className="text-destructive text-xs mt-1">{errors.companyName.message}</p>
              )}
            </div>

            {/* Senha */}
            <div>
              <label className="block text-sm font-medium text-foreground mb-1.5">Senha</label>
              <div className="relative">
                <input
                  {...register('password')}
                  type={showPassword ? 'text' : 'password'}
                  placeholder="••••••••"
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-3 py-2.5 bg-background border border-input rounded-lg text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring text-sm pr-10"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                >
                  {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>

              {/* Critérios de força da senha */}
              {password.length > 0 && (
                <div className="mt-2 space-y-1">
                  {passwordCriteria.map((criterion) => (
                    <div key={criterion.label} className="flex items-center gap-1.5">
                      <Check
                        size={12}
                        className={criterion.test(password) ? 'text-green-500' : 'text-muted-foreground'}
                      />
                      <span className={`text-xs ${criterion.test(password) ? 'text-green-500' : 'text-muted-foreground'}`}>
                        {criterion.label}
                      </span>
                    </div>
                  ))}
                </div>
              )}

              {errors.password && (
                <p className="text-destructive text-xs mt-1">{errors.password.message}</p>
              )}
            </div>

            {/* Aceitar termos */}
            <div className="flex items-start gap-2">
              <input
                {...register('acceptTerms')}
                type="checkbox"
                id="acceptTerms"
                className="mt-0.5 rounded border-input"
              />
              <label htmlFor="acceptTerms" className="text-sm text-muted-foreground">
                Eu aceito os{' '}
                <a href="#" className="text-primary hover:underline">Termos de Uso</a>
                {' '}e a{' '}
                <a href="#" className="text-primary hover:underline">Política de Privacidade</a>
              </label>
            </div>
            {errors.acceptTerms && (
              <p className="text-destructive text-xs -mt-2">{errors.acceptTerms.message}</p>
            )}

            {/* Botão criar conta */}
            <button
              type="submit"
              disabled={isLoading}
              className="w-full py-2.5 px-4 bg-primary text-primary-foreground rounded-lg font-medium text-sm hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-ring disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 transition-colors"
            >
              {isLoading ? (
                <>
                  <Loader2 size={16} className="animate-spin" />
                  Criando conta...
                </>
              ) : (
                'Criar conta grátis'
              )}
            </button>
          </form>

          {/* Link para login */}
          <p className="text-center text-sm text-muted-foreground mt-6">
            Já tem conta?{' '}
            <Link to="/login" className="text-primary font-medium hover:underline">
              Fazer login
            </Link>
          </p>
        </div>

      </div>
    </div>
  )
}
