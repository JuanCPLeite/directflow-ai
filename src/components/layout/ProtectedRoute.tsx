// ===========================================
// ProtectedRoute.tsx — Proteção de rotas
// ===========================================
// Envolve qualquer página que exige login.
// Se o usuário não estiver autenticado, redireciona para /login.
// Se ainda estiver carregando, exibe um spinner.

import { Navigate } from 'react-router-dom'
import { useAuthStore } from '../../store/authStore'
import { Loader2 } from 'lucide-react'

interface ProtectedRouteProps {
  children: React.ReactNode
}

export default function ProtectedRoute({ children }: ProtectedRouteProps) {
  const { user, isLoading } = useAuthStore()

  // Ainda verificando se o usuário está logado
  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-screen bg-background">
        <div className="flex flex-col items-center gap-3">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-muted-foreground">Carregando...</p>
        </div>
      </div>
    )
  }

  // Não está logado → vai para /login
  if (!user) {
    return <Navigate to="/login" replace />
  }

  // Está logado → exibe a página normalmente
  return <>{children}</>
}
