import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database'
import { env, hasSupabaseEnv } from '@/config/env'

export const supabase = hasSupabaseEnv
  ? createClient<Database>(env.supabaseUrl!, env.supabaseAnonKey!, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
      },
    })
  : null
