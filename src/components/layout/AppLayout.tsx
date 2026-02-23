// ===========================================
// AppLayout.tsx — Layout principal do app
// ===========================================
// Combina Sidebar + Header + conteúdo da página.
// Todas as páginas autenticadas usam este layout.
//
// Uso:
//   <AppLayout title="Dashboard">
//     <DashboardPage />
//   </AppLayout>

import Sidebar from './Sidebar'
import Header from './Header'

interface AppLayoutProps {
  title: string
  children: React.ReactNode
}

export default function AppLayout({ title, children }: AppLayoutProps) {
  return (
    <div className="flex h-screen bg-background overflow-hidden">
      {/* Sidebar fixo à esquerda */}
      <Sidebar />

      {/* Área principal (header + conteúdo) */}
      <div className="flex flex-col flex-1 min-w-0">
        <Header title={title} />

        {/* Conteúdo da página com scroll */}
        <main className="flex-1 overflow-y-auto p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
