// ===========================================
// DashboardPage.tsx — Dashboard principal
// ===========================================

import { useAuthStore } from '../../store/authStore'
import MetricCard from './components/MetricCard'
import ConversionsChart from './components/ConversionsChart'
import RecentConversations from './components/RecentConversations'
import SalesFunnel from './components/SalesFunnel'
import {
  MessageSquare,
  Users,
  TrendingUp,
  DollarSign,
} from 'lucide-react'

export default function DashboardPage() {
  const { profile } = useAuthStore()

  const firstName = profile?.full_name?.split(' ')[0] ?? 'usuário'

  return (
    <div className="space-y-6">

      {/* Saudação */}
      <div>
        <h2 className="text-2xl font-bold text-foreground">
          Olá, {firstName}! 👋
        </h2>
        <p className="text-muted-foreground mt-1">
          Aqui está um resumo dos seus últimos 30 dias.
        </p>
      </div>

      {/* Cards de métricas principais */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        <MetricCard
          title="Mensagens"
          value="2.847"
          change="+12%"
          trend="up"
          icon={MessageSquare}
          iconColor="text-blue-500"
          iconBg="bg-blue-50 dark:bg-blue-950/30"
        />
        <MetricCard
          title="Novos Leads"
          value="1.923"
          change="+8%"
          trend="up"
          icon={Users}
          iconColor="text-purple-500"
          iconBg="bg-purple-50 dark:bg-purple-950/30"
        />
        <MetricCard
          title="Taxa de Resposta"
          value="67.5%"
          change="+5%"
          trend="up"
          icon={TrendingUp}
          iconColor="text-green-500"
          iconBg="bg-green-50 dark:bg-green-950/30"
        />
        <MetricCard
          title="Vendas"
          value="R$ 12,4k"
          change="+15%"
          trend="up"
          icon={DollarSign}
          iconColor="text-amber-500"
          iconBg="bg-amber-50 dark:bg-amber-950/30"
        />
      </div>

      {/* Gráfico + Funil (linha do meio) */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-4">
        <div className="xl:col-span-2">
          <ConversionsChart />
        </div>
        <div>
          <SalesFunnel />
        </div>
      </div>

      {/* Conversas recentes */}
      <RecentConversations />

    </div>
  )
}
