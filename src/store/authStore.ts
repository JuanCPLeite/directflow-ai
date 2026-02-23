// ===========================================
// authStore.ts — Estado global de autenticação
// ===========================================
// Zustand é uma biblioteca de estado global simples.
// Este store guarda os dados do usuário logado e
// disponibiliza para qualquer componente do app.

import { create } from 'zustand'
import type { User, Session } from '@supabase/supabase-js'
import type { Profile } from '../types/database'

interface AuthState {
  // Dados do Supabase Auth (email, id, metadata)
  user: User | null
  // Sessão atual (tokens de acesso)
  session: Session | null
  // Perfil completo do banco (nome, plano, instagram, etc.)
  profile: Profile | null
  // Se ainda está carregando o estado inicial
  isLoading: boolean

  // Ações para atualizar o estado
  setUser: (user: User | null) => void
  setSession: (session: Session | null) => void
  setProfile: (profile: Profile | null) => void
  setLoading: (isLoading: boolean) => void
  // Limpa tudo ao fazer logout
  clear: () => void
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  session: null,
  profile: null,
  isLoading: true,

  setUser: (user) => set({ user }),
  setSession: (session) => set({ session }),
  setProfile: (profile) => set({ profile }),
  setLoading: (isLoading) => set({ isLoading }),
  clear: () => set({ user: null, session: null, profile: null }),
}))
