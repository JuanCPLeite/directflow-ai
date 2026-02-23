// ===========================================
// useAuth.ts — Hook de autenticação
// ===========================================
// Este hook é o "coração" da autenticação.
// Ele escuta mudanças na sessão do Supabase em tempo real
// e mantém o estado global atualizado.
//
// Como usar em qualquer componente:
//   const { user, profile, isLoading, signOut } = useAuth()

import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuthStore } from '../store/authStore'
import type { Profile } from '../types/database'

export function useAuth() {
  const { user, session, profile, isLoading, setUser, setSession, setProfile, setLoading, clear } =
    useAuthStore()
  const navigate = useNavigate()

  useEffect(() => {
    // 1. Busca a sessão atual ao carregar o app
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setUser(session?.user ?? null)

      if (session?.user) {
        loadProfile(session.user.id)
      } else {
        setLoading(false)
      }
    })

    // 2. Escuta mudanças de autenticação em tempo real
    // (login, logout, refresh de token, etc.)
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (_event, session) => {
        setSession(session)
        setUser(session?.user ?? null)

        if (session?.user) {
          await loadProfile(session.user.id)
        } else {
          setProfile(null)
          setLoading(false)
        }
      }
    )

    // Limpa o listener quando o componente desmonta
    return () => subscription.unsubscribe()
  }, []) // eslint-disable-line react-hooks/exhaustive-deps

  // Busca o perfil completo do usuário no banco
  async function loadProfile(userId: string) {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()

    if (!error && data) {
      setProfile(data as Profile)
    }

    setLoading(false)
  }

  // Faz logout e redireciona para login
  async function signOut() {
    await supabase.auth.signOut()
    clear()
    navigate('/login')
  }

  return {
    user,
    session,
    profile,
    isLoading,
    signOut,
    // Atalhos úteis
    isAuthenticated: !!user,
    userName: profile?.full_name ?? user?.email ?? 'Usuário',
    userPlan: profile?.plan ?? 'trial',
    trialEndsAt: profile?.trial_ends_at,
  }
}
