-- ============================================================
-- HADEUX — schéma Supabase (données partagées du foyer)
-- À exécuter une fois dans : Supabase → SQL Editor → New query → Run
-- ============================================================

-- Table qui contient l'unique état partagé de l'app (une seule ligne, id = 'shared')
create table if not exists public.hadeux (
  id         text primary key,
  data       jsonb,
  updated_at timestamptz default now()
);

-- Sécurité : personne n'accède aux données sans être connecté
alter table public.hadeux enable row level security;

-- Les utilisateurs CONNECTÉS peuvent lire et écrire la ligne partagée.
-- (Seuls Gus & Ju auront un compte dans ce projet Supabase.)
drop policy if exists "hadeux_select" on public.hadeux;
create policy "hadeux_select" on public.hadeux
  for select to authenticated using (true);

drop policy if exists "hadeux_insert" on public.hadeux;
create policy "hadeux_insert" on public.hadeux
  for insert to authenticated with check (true);

drop policy if exists "hadeux_update" on public.hadeux;
create policy "hadeux_update" on public.hadeux
  for update to authenticated using (true) with check (true);
