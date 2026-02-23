// ===========================================
// App.tsx — Roteamento principal do app
// ===========================================

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'

// Componentes de layout e proteção
import ProtectedRoute from './components/layout/ProtectedRoute'
import AppLayout from './components/layout/AppLayout'

// Páginas de autenticação (sem layout)
import LoginPage from './pages/auth/LoginPage'
import RegisterPage from './pages/auth/RegisterPage'

// Páginas do app (com layout)
import DashboardPage from './pages/dashboard/DashboardPage'

// Placeholder para páginas ainda não implementadas
function ComingSoon({ name }: { name: string }) {
  return (
    <div className="flex items-center justify-center h-64">
      <div className="text-center">
        <div className="text-4xl mb-4">🚧</div>
        <h2 className="text-xl font-semibold text-foreground mb-2">{name}</h2>
        <p className="text-muted-foreground text-sm">Em desenvolvimento...</p>
      </div>
    </div>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Rota raiz */}
        <Route path="/" element={<Navigate to="/login" replace />} />

        {/* Páginas públicas (sem autenticação) */}
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />

        {/* Páginas protegidas (exigem login) */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <AppLayout title="Dashboard">
                <DashboardPage />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/agents"
          element={
            <ProtectedRoute>
              <AppLayout title="Agentes de IA">
                <ComingSoon name="Agentes de IA" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/crm"
          element={
            <ProtectedRoute>
              <AppLayout title="CRM">
                <ComingSoon name="CRM — Gestão de Leads" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/flows"
          element={
            <ProtectedRoute>
              <AppLayout title="Editor de Fluxos">
                <ComingSoon name="Editor Visual de Fluxos" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/keywords"
          element={
            <ProtectedRoute>
              <AppLayout title="Palavras-chave">
                <ComingSoon name="Keywords & Auto-input" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/broadcasts"
          element={
            <ProtectedRoute>
              <AppLayout title="Broadcasts">
                <ComingSoon name="Broadcasts & Campanhas" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/analytics"
          element={
            <ProtectedRoute>
              <AppLayout title="Analytics">
                <ComingSoon name="Analytics & Relatórios" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/settings"
          element={
            <ProtectedRoute>
              <AppLayout title="Configurações">
                <ComingSoon name="Configurações da Conta" />
              </AppLayout>
            </ProtectedRoute>
          }
        />

        {/* 404 */}
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
