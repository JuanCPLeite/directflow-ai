import type { PropsWithChildren } from 'react'
import { Navigate, useLocation } from 'react-router-dom'

import { useAuth } from '@/features/auth/providers/useAuth'

export function ProtectedRoute({ children }: PropsWithChildren) {
  const location = useLocation()
  const { isLoading, user, isConfigured } = useAuth()

  if (!isConfigured) {
    return <Navigate to="/login" replace state={{ reason: 'supabase-missing' }} />
  }

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-950 text-slate-100">
        <div className="rounded-2xl border border-white/10 bg-white/5 px-6 py-4 text-sm">
          Validando sessao...
        </div>
      </div>
    )
  }

  if (!user) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />
  }

  return children
}
