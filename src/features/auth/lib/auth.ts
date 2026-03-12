import type { Provider } from '@supabase/supabase-js'

import { env } from '@/config/env'
import { supabase } from '@/lib/supabase'

type AuthCredentials = {
  email: string
  password: string
}

type SignUpCredentials = AuthCredentials & {
  fullName: string
}

const ensureSupabase = () => {
  if (!supabase) {
    throw new Error('Supabase ainda nao foi configurado neste ambiente.')
  }

  return supabase
}

export async function signInWithPassword({ email, password }: AuthCredentials) {
  const client = ensureSupabase()
  const { error } = await client.auth.signInWithPassword({ email, password })

  if (error) {
    throw error
  }
}

export async function signUpWithPassword({ email, password, fullName }: SignUpCredentials) {
  const client = ensureSupabase()
  const redirectTo = env.appUrl ? `${env.appUrl}/auth/callback` : undefined

  const { error } = await client.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: redirectTo,
      data: {
        full_name: fullName,
      },
    },
  })

  if (error) {
    throw error
  }
}

export async function signInWithOAuth(provider: Provider) {
  const client = ensureSupabase()
  const redirectTo = env.appUrl ? `${env.appUrl}/auth/callback` : `${window.location.origin}/auth/callback`

  const { error } = await client.auth.signInWithOAuth({
    provider,
    options: { redirectTo },
  })

  if (error) {
    throw error
  }
}

export async function signOut() {
  const client = ensureSupabase()
  const { error } = await client.auth.signOut()

  if (error) {
    throw error
  }
}
