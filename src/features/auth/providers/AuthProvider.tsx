import {
  useEffect,
  useMemo,
  useState,
  type PropsWithChildren,
} from 'react'
import type { Session, User } from '@supabase/supabase-js'

import { AuthContext, type AuthContextValue } from '@/features/auth/providers/AuthContext'
import { supabase } from '@/lib/supabase'

export function AuthProvider({ children }: PropsWithChildren) {
  const [session, setSession] = useState<Session | null>(null)
  const [user, setUser] = useState<User | null>(null)
  const [isLoading, setIsLoading] = useState(() => Boolean(supabase))

  useEffect(() => {
    if (!supabase) {
      return
    }

    let isActive = true

    supabase.auth
      .getSession()
      .then(({ data, error }) => {
        if (!isActive) return

        if (error) {
          console.error('Failed to load auth session', error)
        }

        setSession(data.session)
        setUser(data.session?.user ?? null)
        setIsLoading(false)
      })
      .catch((error) => {
        if (!isActive) return
        console.error('Failed to bootstrap auth session', error)
        setIsLoading(false)
      })

    const { data } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      if (!isActive) return
      setSession(nextSession)
      setUser(nextSession?.user ?? null)
      setIsLoading(false)
    })

    return () => {
      isActive = false
      data.subscription.unsubscribe()
    }
  }, [])

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      session,
      isLoading,
      isConfigured: Boolean(supabase),
    }),
    [isLoading, session, user],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
