// ===========================================
// App.tsx — Componente raiz da aplicação
// ===========================================
// Define as rotas e a estrutura principal do app.
// Cada rota corresponde a uma página/módulo.

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'

// Páginas de autenticação
import LoginPage from './pages/auth/LoginPage'
import RegisterPage from './pages/auth/RegisterPage'

// Placeholder temporário para páginas ainda não implementadas
function ComingSoon({ name }: { name: string }) {
  return (
    <div className="flex items-center justify-center h-screen bg-background">
      <div className="text-center">
        <h1 className="text-2xl font-bold text-foreground mb-2">{name}</h1>
        <p className="text-muted-foreground">Em desenvolvimento...</p>
      </div>
    </div>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Rota raiz → redireciona para login */}
        <Route path="/" element={<Navigate to="/login" replace />} />

        {/* Autenticação */}
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={<RegisterPage />} />

        {/* Dashboard principal */}
        <Route path="/dashboard" element={<ComingSoon name="Dashboard" />} />

        {/* Agentes de IA */}
        <Route path="/agents" element={<ComingSoon name="Agentes de IA" />} />

        {/* CRM */}
        <Route path="/crm" element={<ComingSoon name="CRM" />} />

        {/* Fluxos visuais */}
        <Route path="/flows" element={<ComingSoon name="Editor de Fluxos" />} />

        {/* Keywords */}
        <Route path="/keywords" element={<ComingSoon name="Palavras-chave" />} />

        {/* Broadcasts */}
        <Route path="/broadcasts" element={<ComingSoon name="Broadcasts" />} />

        {/* Analytics */}
        <Route path="/analytics" element={<ComingSoon name="Analytics" />} />

        {/* Configurações */}
        <Route path="/settings" element={<ComingSoon name="Configurações" />} />

        {/* 404 → redireciona para login */}
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
