// ===========================================
// Tipos do Banco de Dados (Database Types)
// ===========================================
// Este arquivo define os tipos TypeScript que espelham
// exatamente a estrutura das tabelas no Supabase.
// Quando o banco mudar, este arquivo deve ser atualizado.
//
// Futuramente este arquivo pode ser gerado automaticamente
// pelo comando: supabase gen types typescript --linked

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

// Interface principal que descreve todo o banco de dados
export interface Database {
  public: {
    Tables: {
      // -----------------------------------------------
      // profiles — Perfis de usuário
      // (complementa a tabela auth.users do Supabase)
      // -----------------------------------------------
      profiles: {
        Row: {
          id: string                        // UUID do usuário (vem do Supabase Auth)
          created_at: string
          updated_at: string
          full_name: string | null
          phone: string | null
          company_name: string | null
          industry: string | null
          timezone: string
          language: string
          plan: 'trial' | 'starter' | 'professional' | 'business' | 'enterprise'
          plan_status: 'active' | 'canceled' | 'expired'
          trial_ends_at: string | null
          subscription_id: string | null
          instagram_user_id: string | null
          instagram_username: string | null
          instagram_access_token: string | null
          instagram_token_expires_at: string | null
          instagram_connected: boolean
          business_hours: Json | null
          out_of_hours_message: string | null
          avatar_url: string | null
          is_active: boolean
          last_login_at: string | null
          login_count: number
        }
        Insert: Omit<Database['public']['Tables']['profiles']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['profiles']['Insert']>
      }

      // -----------------------------------------------
      // agents — Agentes de IA configurados pelo usuário
      // -----------------------------------------------
      agents: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          name: string
          description: string | null
          personality: string | null
          system_prompt: string
          ai_model: string
          temperature: number
          max_tokens: number
          response_delay_seconds: number
          max_messages_per_conversation: number
          tone: 'formal' | 'friendly' | 'casual' | null
          allow_human_handoff: boolean
          save_conversation_history: boolean
          debug_mode: boolean
          is_active: boolean
          is_default: boolean
          total_conversations: number
          total_messages_sent: number
          average_satisfaction_score: number | null
        }
        Insert: Omit<Database['public']['Tables']['agents']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['agents']['Insert']>
      }

      // -----------------------------------------------
      // knowledge_base — Base de conhecimento dos agentes
      // -----------------------------------------------
      knowledge_base: {
        Row: {
          id: string
          user_id: string
          agent_id: string
          created_at: string
          updated_at: string
          type: 'pdf' | 'url' | 'text' | 'video' | 'audio' | 'integration'
          name: string
          description: string | null
          source_url: string | null
          raw_content: string | null
          processed_content: string | null
          content_metadata: Json | null
          tokens_count: number | null
          status: 'pending' | 'processing' | 'active' | 'error'
          is_active: boolean
          last_synced_at: string | null
          sync_frequency: 'daily' | 'weekly' | 'manual' | null
          auto_sync: boolean
        }
        Insert: Omit<Database['public']['Tables']['knowledge_base']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['knowledge_base']['Insert']>
      }

      // -----------------------------------------------
      // pipeline_stages — Etapas do funil de vendas (Kanban)
      // -----------------------------------------------
      pipeline_stages: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          name: string
          color: string | null
          order_position: number
          is_won_stage: boolean
          is_lost_stage: boolean
          automation_on_enter: Json | null
          automation_on_exit: Json | null
        }
        Insert: Omit<Database['public']['Tables']['pipeline_stages']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['pipeline_stages']['Insert']>
      }

      // -----------------------------------------------
      // leads — Contatos/leads do CRM
      // -----------------------------------------------
      leads: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          name: string | null
          email: string | null
          phone: string | null
          instagram_id: string | null
          instagram_username: string | null
          instagram_profile_pic: string | null
          instagram_follower_count: number | null
          is_follower: boolean | null
          deal_value: number | null
          currency: string
          pipeline_stage_id: string | null
          source: 'instagram_dm' | 'comment' | 'story' | 'website' | 'manual' | null
          source_detail: string | null
          utm_source: string | null
          utm_campaign: string | null
          last_message: string | null
          last_response: string | null
          last_interaction_at: string | null
          last_response_at: string | null
          interaction_type: 'dm' | 'comment' | 'story' | null
          is_qualified: boolean
          is_customer: boolean
          custom_fields: Json | null
          preferred_contact_method: string | null
          best_time_to_contact: string | null
          notes: string | null
        }
        Insert: Omit<Database['public']['Tables']['leads']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['leads']['Insert']>
      }

      // -----------------------------------------------
      // tags — Etiquetas para organizar leads
      // -----------------------------------------------
      tags: {
        Row: {
          id: string
          user_id: string
          created_at: string
          name: string
          color: string | null
          is_active: boolean
        }
        Insert: Omit<Database['public']['Tables']['tags']['Row'], 'created_at'>
        Update: Partial<Database['public']['Tables']['tags']['Insert']>
      }

      // -----------------------------------------------
      // lead_tags — Relação N:N entre leads e tags
      // -----------------------------------------------
      lead_tags: {
        Row: {
          lead_id: string
          tag_id: string
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['lead_tags']['Row'], 'created_at'>
        Update: never
      }

      // -----------------------------------------------
      // flows — Fluxos de automação visuais
      // -----------------------------------------------
      flows: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          name: string
          description: string | null
          category: 'sales' | 'support' | 'lead_qualification' | 'other' | null
          flow_data: Json
          trigger_type: 'new_message' | 'comment' | 'story_reply' | 'keyword' | 'schedule' | null
          trigger_config: Json | null
          is_active: boolean
          is_template: boolean
          total_executions: number
          completion_rate: number | null
          average_completion_time: number | null
          version: number
          parent_flow_id: string | null
        }
        Insert: Omit<Database['public']['Tables']['flows']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['flows']['Insert']>
      }

      // -----------------------------------------------
      // keywords — Palavras-chave para auto-resposta
      // -----------------------------------------------
      keywords: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          keywords: Json                      // array de strings
          match_type: 'exact' | 'contains' | 'starts_with' | 'ends_with'
          apply_to_dm: boolean
          apply_to_comments: boolean
          apply_to_stories: boolean
          response_type: 'message' | 'trigger_flow' | 'webhook' | null
          response_message: string | null
          response_media_url: string | null
          response_buttons: Json | null
          flow_id: string | null
          add_tags: Json | null
          move_to_stage_id: string | null
          notify_user: boolean
          priority: number
          is_active: boolean
          apply_only_to_new_leads: boolean
          apply_only_with_tags: Json | null
          max_uses_per_lead: number | null
          active_hours: Json | null
          total_triggers: number
          conversion_rate: number | null
        }
        Insert: Omit<Database['public']['Tables']['keywords']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['keywords']['Insert']>
      }

      // -----------------------------------------------
      // conversations — Histórico de conversas
      // -----------------------------------------------
      conversations: {
        Row: {
          id: string
          user_id: string
          lead_id: string
          agent_id: string | null
          flow_id: string | null
          started_at: string
          ended_at: string | null
          type: 'agent' | 'flow' | 'human' | null
          channel: 'dm' | 'comment' | 'story' | null
          status: 'active' | 'resolved' | 'transferred'
          transferred_to_human: boolean
          transferred_at: string | null
          satisfaction_score: number | null
          resolved: boolean | null
          total_messages: number
          response_time_avg: number | null
          duration_seconds: number | null
        }
        Insert: Omit<Database['public']['Tables']['conversations']['Row'], 'started_at'>
        Update: Partial<Database['public']['Tables']['conversations']['Insert']>
      }

      // -----------------------------------------------
      // messages — Mensagens individuais de conversas
      // -----------------------------------------------
      messages: {
        Row: {
          id: string
          conversation_id: string
          created_at: string
          from_type: 'lead' | 'agent' | 'human'
          from_user_id: string | null
          content: string | null
          media_type: 'text' | 'image' | 'video' | 'audio' | 'file' | null
          media_url: string | null
          instagram_message_id: string | null
          is_read: boolean
          read_at: string | null
          ai_confidence: number | null
          intent: string | null
          sentiment: 'positive' | 'neutral' | 'negative' | null
          entities: Json | null
        }
        Insert: Omit<Database['public']['Tables']['messages']['Row'], 'created_at'>
        Update: Partial<Database['public']['Tables']['messages']['Insert']>
      }

      // -----------------------------------------------
      // broadcasts — Campanhas de envio em massa
      // -----------------------------------------------
      broadcasts: {
        Row: {
          id: string
          user_id: string
          created_at: string
          scheduled_at: string | null
          sent_at: string | null
          name: string
          target_type: 'all' | 'segment' | 'tags' | 'custom'
          target_segment_id: string | null
          target_tags: Json | null
          target_custom_filter: Json | null
          exclude_filter: Json | null
          message_type: 'text' | 'image' | 'video' | 'carousel'
          message_content: string | null
          message_media_url: string | null
          message_buttons: Json | null
          send_speed: 'fast' | 'normal' | 'slow'
          messages_per_minute: number | null
          status: 'draft' | 'scheduled' | 'sending' | 'sent' | 'failed'
          total_recipients: number | null
          total_sent: number
          total_delivered: number
          total_read: number
          total_clicked: number
          total_replied: number
          total_converted: number
          total_revenue: number | null
          ab_test: boolean
          ab_test_config: Json | null
        }
        Insert: Omit<Database['public']['Tables']['broadcasts']['Row'], 'created_at'>
        Update: Partial<Database['public']['Tables']['broadcasts']['Insert']>
      }

      // -----------------------------------------------
      // integrations — Integrações externas (Zapier, Make, etc.)
      // -----------------------------------------------
      integrations: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
          integration_type: string
          name: string | null
          config: Json
          credentials: Json | null
          is_active: boolean
          last_sync_at: string | null
          sync_status: 'success' | 'error' | 'pending' | null
          error_message: string | null
          total_calls: number
          successful_calls: number
          failed_calls: number
        }
        Insert: Omit<Database['public']['Tables']['integrations']['Row'], 'created_at' | 'updated_at'>
        Update: Partial<Database['public']['Tables']['integrations']['Insert']>
      }

      // -----------------------------------------------
      // analytics_events — Eventos para analytics
      // -----------------------------------------------
      analytics_events: {
        Row: {
          id: string
          user_id: string
          created_at: string
          event_type: string
          event_name: string | null
          lead_id: string | null
          conversation_id: string | null
          flow_id: string | null
          broadcast_id: string | null
          event_data: Json | null
          revenue: number | null
          user_agent: string | null
          ip_address: string | null
          session_id: string | null
        }
        Insert: Omit<Database['public']['Tables']['analytics_events']['Row'], 'created_at'>
        Update: never
      }
    }

    Views: {
      [_ in never]: never
    }

    Functions: {
      [_ in never]: never
    }

    Enums: {
      [_ in never]: never
    }
  }
}

// Tipos auxiliares para facilitar o uso no código
export type Profile = Database['public']['Tables']['profiles']['Row']
export type Agent = Database['public']['Tables']['agents']['Row']
export type KnowledgeBase = Database['public']['Tables']['knowledge_base']['Row']
export type PipelineStage = Database['public']['Tables']['pipeline_stages']['Row']
export type Lead = Database['public']['Tables']['leads']['Row']
export type Tag = Database['public']['Tables']['tags']['Row']
export type LeadTag = Database['public']['Tables']['lead_tags']['Row']
export type Flow = Database['public']['Tables']['flows']['Row']
export type Keyword = Database['public']['Tables']['keywords']['Row']
export type Conversation = Database['public']['Tables']['conversations']['Row']
export type Message = Database['public']['Tables']['messages']['Row']
export type Broadcast = Database['public']['Tables']['broadcasts']['Row']
export type Integration = Database['public']['Tables']['integrations']['Row']
export type AnalyticsEvent = Database['public']['Tables']['analytics_events']['Row']
