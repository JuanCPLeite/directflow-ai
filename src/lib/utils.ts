// ===========================================
// Utilitários gerais
// ===========================================
// Funções auxiliares usadas em todo o projeto.

import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

// Função para combinar classes CSS do Tailwind de forma inteligente.
// Evita conflitos quando duas classes do Tailwind se contradizem
// (ex: "p-2 p-4" → mantém só "p-4").
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// Formata um valor numérico para moeda brasileira (R$)
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value)
}

// Formata uma data para o padrão brasileiro
export function formatDate(date: string | Date): string {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  }).format(new Date(date))
}

// Formata data + hora
export function formatDateTime(date: string | Date): string {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(date))
}

// Retorna quantos minutos/horas/dias atrás foi uma data
export function timeAgo(date: string | Date): string {
  const seconds = Math.floor((new Date().getTime() - new Date(date).getTime()) / 1000)

  if (seconds < 60) return 'agora'
  if (seconds < 3600) return `${Math.floor(seconds / 60)}min atrás`
  if (seconds < 86400) return `${Math.floor(seconds / 3600)}h atrás`
  if (seconds < 604800) return `${Math.floor(seconds / 86400)}d atrás`
  return formatDate(date)
}

// Trunca um texto longo adicionando "..." no final
export function truncate(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text
  return text.slice(0, maxLength) + '...'
}

// Gera um ID único simples (para uso interno, não para banco)
export function generateId(): string {
  return Math.random().toString(36).substring(2, 9)
}
