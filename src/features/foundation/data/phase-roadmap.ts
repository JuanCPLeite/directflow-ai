export type PhaseStatus = 'current' | 'next' | 'planned'

export type FoundationPhase = {
  number: string
  name: string
  focus: string
  status: PhaseStatus
}

export const foundationPhases: FoundationPhase[] = [
  {
    number: '01',
    name: 'Foundation and Platform Setup',
    focus: 'Reset repo, app shell, env contracts, Supabase baseline, and quality tooling.',
    status: 'current',
  },
  {
    number: '02',
    name: 'Authentication and Instagram Onboarding',
    focus: 'Account lifecycle, trial state, onboarding wizard, and Meta connection flow.',
    status: 'next',
  },
  {
    number: '03',
    name: 'Layout and Operational Dashboard',
    focus: 'Authenticated shell, navigation model, and first operator-facing dashboard.',
    status: 'planned',
  },
  {
    number: '04',
    name: 'AI Agents and Prompting',
    focus: 'Agent CRUD, provider settings, prompt templates, and testing playground.',
    status: 'planned',
  },
  {
    number: '05',
    name: 'Knowledge Base and Retrieval',
    focus: 'Ingestion, chunking, embeddings, and semantic retrieval management.',
    status: 'planned',
  },
  {
    number: '06',
    name: 'Visual Flow Builder',
    focus: 'Node editor, flow persistence, runtime contracts, and templates.',
    status: 'planned',
  },
  {
    number: '07',
    name: 'Keywords and Auto-Input Automation',
    focus: 'Trigger rules, restrictions, and automated lead capture actions.',
    status: 'planned',
  },
  {
    number: '08',
    name: 'CRM and Lead Operations',
    focus: 'Lead pipeline, segmentation, import/export, and operator workflows.',
    status: 'planned',
  },
]

export const preservedReferences = [
  'docs/',
  'documentos_originais/',
  '.planning/',
  'database/',
  'src/types/database.ts',
]

export const phaseOneTracks = [
  {
    title: 'Frontend foundation',
    body: 'Create a clean source tree, intentional shell, and reusable building blocks for the rest of the product.',
  },
  {
    title: 'Platform contracts',
    body: 'Stabilize env handling and Supabase integration so local work does not depend on production secrets.',
  },
  {
    title: 'Repository hygiene',
    body: 'Remove obsolete prototype files and keep only assets that support the documented architecture.',
  },
]
