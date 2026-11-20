-- ============================================================
-- Speed Dépannage — schéma Supabase
-- À exécuter dans : Supabase > SQL Editor > New query > Run
-- Les tables sont préfixées « sd_ » : aucun conflit avec d'autres tables du projet.
-- ============================================================

-- 1) Contenu du site (slides, forfaits, location, vente, pièces, images Speed Connect)
create table if not exists public.sd_items (
  collection text not null check (collection in ('slides','scImages','forfaits','location','pieces','vente')),
  id         text not null,
  position   integer not null default 0,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);
create index if not exists sd_items_collection_position_idx on public.sd_items (collection, position);

-- 2) Comptes autorisés à modifier le site
create table if not exists public.sd_admins (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

-- 3) Messages du formulaire de contact
create table if not exists public.sd_contacts (
  id         uuid primary key default gen_random_uuid(),
  name       text not null check (char_length(name)    between 1 and 120),
  email      text not null check (char_length(email)   between 3 and 200),
  phone      text not null check (char_length(phone)   between 5 and 40),
  message    text not null check (char_length(message) between 1 and 4000),
  created_at timestamptz not null default now()
);

-- 4) Fonctions
create or replace function public.sd_is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (select 1 from public.sd_admins where user_id = auth.uid());
$$;

create or replace function public.sd_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists sd_items_touch on public.sd_items;
create trigger sd_items_touch before update on public.sd_items
  for each row execute function public.sd_touch_updated_at();

-- 5) Sécurité au niveau des lignes (RLS)
alter table public.sd_items    enable row level security;
alter table public.sd_admins   enable row level security;
alter table public.sd_contacts enable row level security;

-- sd_items : lecture publique, écriture réservée aux admins
drop policy if exists "sd_items_read"         on public.sd_items;
drop policy if exists "sd_items_admin_insert" on public.sd_items;
drop policy if exists "sd_items_admin_update" on public.sd_items;
drop policy if exists "sd_items_admin_delete" on public.sd_items;
create policy "sd_items_read"         on public.sd_items for select to anon, authenticated using (true);
create policy "sd_items_admin_insert" on public.sd_items for insert to authenticated with check (public.sd_is_admin());
create policy "sd_items_admin_update" on public.sd_items for update to authenticated using (public.sd_is_admin()) with check (public.sd_is_admin());
create policy "sd_items_admin_delete" on public.sd_items for delete to authenticated using (public.sd_is_admin());

-- sd_admins : chacun peut seulement voir sa propre ligne (aucune écriture depuis le site)
drop policy if exists "sd_admins_read_self" on public.sd_admins;
create policy "sd_admins_read_self" on public.sd_admins for select to authenticated using (user_id = auth.uid());

-- sd_contacts : tout le monde peut écrire un message, seuls les admins peuvent les lire / supprimer
drop policy if exists "sd_contacts_insert"       on public.sd_contacts;
drop policy if exists "sd_contacts_admin_read"   on public.sd_contacts;
drop policy if exists "sd_contacts_admin_delete" on public.sd_contacts;
create policy "sd_contacts_insert"       on public.sd_contacts for insert to anon, authenticated with check (true);
create policy "sd_contacts_admin_read"   on public.sd_contacts for select to authenticated using (public.sd_is_admin());
create policy "sd_contacts_admin_delete" on public.sd_contacts for delete to authenticated using (public.sd_is_admin());

-- Droits d'accès aux tables (en complément des règles RLS ci-dessus)
grant select                         on public.sd_items    to anon, authenticated;
grant insert, update, delete         on public.sd_items    to authenticated;
grant select                         on public.sd_admins   to authenticated;
grant insert                         on public.sd_contacts to anon, authenticated;
grant select, delete                 on public.sd_contacts to authenticated;

-- 6) Stockage des images (bucket public en lecture, envoi réservé aux admins)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('sd-images', 'sd-images', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "sd_images_admin_insert" on storage.objects;
drop policy if exists "sd_images_admin_update" on storage.objects;
drop policy if exists "sd_images_admin_delete" on storage.objects;
create policy "sd_images_admin_insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'sd-images' and public.sd_is_admin());
create policy "sd_images_admin_update" on storage.objects for update to authenticated
  using (bucket_id = 'sd-images' and public.sd_is_admin())
  with check (bucket_id = 'sd-images' and public.sd_is_admin());
create policy "sd_images_admin_delete" on storage.objects for delete to authenticated
  using (bucket_id = 'sd-images' and public.sd_is_admin());
