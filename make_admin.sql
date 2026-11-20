-- ============================================================
-- Donner les droits administrateur à un compte
-- 1) Créez d'abord le compte : Supabase > Authentication > Users > Add user
--    (cochez « Auto Confirm User »), avec un mot de passe long et unique.
-- 2) Remplacez l'adresse ci-dessous par celle du compte, puis exécutez.
-- ============================================================
insert into public.sd_admins (user_id)
select id from auth.users where email = 'VOTRE_EMAIL_ADMIN'
on conflict (user_id) do nothing;

-- Vérification : doit renvoyer une ligne
select a.user_id, u.email from public.sd_admins a join auth.users u on u.id = a.user_id;
