import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'

import { AppShell } from '@/components/shell/AppShell'
import { FoundationPage } from '@/features/foundation/pages/FoundationPage'

export default function App() {
  return (
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
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
