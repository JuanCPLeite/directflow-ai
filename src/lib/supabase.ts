// ===========================================
// Cliente do Supabase
// ===========================================
// Este arquivo cria e exporta a conexão com o Supabase.
// Usamos as variáveis de ambiente do arquivo .env para
// não expor as chaves diretamente no código.

import { createClient } from '@supabase/supabase-js'
import type { Database } from '../types/database'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Variáveis de ambiente do Supabase não configuradas. Verifique o arquivo .env')
}

// Criamos o cliente tipado com nossa interface de banco de dados.
// O "Database" é um tipo que vai ser gerado automaticamente pelo Supabase
// e vai garantir que todas as queries sejam type-safe (sem erros de tipo).
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
  auth: {
    // Persiste a sessão no localStorage (usuário não precisa logar toda vez)
    persistSession: true,
    // Atualiza o token automaticamente antes de expirar
    autoRefreshToken: true,
  },
})
