import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'

import { AppShell } from '@/components/shell/AppShell'
import { AppHomePage } from '@/features/app/pages/AppHomePage'
import { ProtectedRoute } from '@/features/auth/components/ProtectedRoute'
import { AuthCallbackPage } from '@/features/auth/pages/AuthCallbackPage'
import { LoginPage } from '@/features/auth/pages/LoginPage'
import { RegisterPage } from '@/features/auth/pages/RegisterPage'
import { AuthProvider } from '@/features/auth/providers/AuthProvider'
import { FoundationPage } from '@/features/foundation/pages/FoundationPage'

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route
            path="/"
            element={
              <AppShell
                eyebrow="foundation reset"
                title="InstaFlow AI esta em construcao sobre uma base nova."
                description="A antiga shell foi removida para abrir caminho a uma arquitetura coerente com o produto definido em `docs/`. O foco agora e montar a fundacao tecnica, limpar o legado e deixar o repositorio pronto para as fases de autenticacao, dashboard, IA e operacao."
              >
                <FoundationPage />
              </AppShell>
            }
          />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/auth/callback" element={<AuthCallbackPage />} />
          <Route
            path="/app"
            element={
              <ProtectedRoute>
                <AppHomePage />
              </ProtectedRoute>
            }
          />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}
