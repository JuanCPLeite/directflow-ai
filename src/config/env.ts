const readEnv = (key: string) => {
  const value = import.meta.env[key]
  return typeof value === 'string' && value.trim().length > 0 ? value : null
}

export const env = {
  appName: readEnv('VITE_APP_NAME') ?? 'InstaFlow AI',
  appUrl: readEnv('VITE_APP_URL'),
  supabaseUrl: readEnv('VITE_SUPABASE_URL'),
  supabaseAnonKey: readEnv('VITE_SUPABASE_ANON_KEY'),
  sentryDsn: readEnv('VITE_SENTRY_DSN'),
  stripePublishableKey: readEnv('VITE_STRIPE_PUBLISHABLE_KEY'),
  metaAppId: readEnv('VITE_META_APP_ID'),
} as const

export const envReadiness = [
  { label: 'Supabase URL', ready: Boolean(env.supabaseUrl) },
  { label: 'Supabase anon key', ready: Boolean(env.supabaseAnonKey) },
  { label: 'App URL', ready: Boolean(env.appUrl) },
  { label: 'Meta App ID', ready: Boolean(env.metaAppId) },
  { label: 'Stripe publishable key', ready: Boolean(env.stripePublishableKey) },
  { label: 'Sentry DSN', ready: Boolean(env.sentryDsn) },
] as const

export const hasSupabaseEnv = Boolean(env.supabaseUrl && env.supabaseAnonKey)
