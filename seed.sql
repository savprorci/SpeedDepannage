-- Données initiales du site (équivalent des valeurs par défaut de index.html)
-- À exécuter une seule fois, après schema.sql. Sans risque si relancé : les lignes existantes sont mises à jour.

insert into public.sd_items (collection, id, position, data) values
  ('slides', 's1', 0, '{"title":"L''énergie qui ne s''arrête jamais.","text":"Location, vente, coffrets sur mesure, maintenance et supervision à distance.","image":""}'::jsonb),
  ('slides', 's2', 1, '{"title":"Intervention < 1h à Abidjan.","text":"Une panne ? Nos équipes interviennent en urgence 24h/24.","image":""}'::jsonb),
  ('slides', 's3', 2, '{"title":"Tarifs dégressifs.","text":"Groupes électrogènes et engins TP. Maintenance incluse.","image":""}'::jsonb),
  ('slides', 's4', 3, '{"title":"Speed Connect.","text":"Pilotez vos équipements en temps réel depuis votre smartphone.","image":""}'::jsonb),
  ('scImages', 'sc1', 0, '{"image":""}'::jsonb),
  ('scImages', 'sc2', 1, '{"image":""}'::jsonb),
  ('forfaits', 'essentiel', 0, '{"name":"Essentiel","price":"35 000 FCFA/trimestre","target":"Résidences, boutiques","visites":"1/trimestre","delai":"24h","image":""}'::jsonb),
  ('forfaits', 'serenite', 1, '{"name":"Sérénité","price":"62 000 FCFA/trimestre","target":"Pharmacies, supermarchés","visites":"1/mois","delai":"12h","image":""}'::jsonb),
  ('forfaits', 'preventif', 2, '{"name":"Préventif Pro","price":"125 000 FCFA/trimestre","target":"Supermarchés, PME","visites":"1/mois","delai":"8h ouvrées","image":""}'::jsonb),
  ('forfaits', 'haute', 3, '{"name":"Haute Dispo","price":"170 000 FCFA/trimestre","target":"Forte fréquentation","visites":"2/mois","delai":"6h","image":""}'::jsonb),
  ('forfaits', 'indus', 4, '{"name":"Industriel Std","price":"350 000 FCFA/mois","target":"Usines, hôpitaux","visites":"2/mois","delai":"4h ouvrées","image":""}'::jsonb),
  ('forfaits', 'critique', 5, '{"name":"Industriel Critique","price":"890 000 FCFA/trimestre","target":"Data centers","visites":"2/mois","delai":"2h","image":""}'::jsonb),
  ('location', 'l1', 0, '{"name":"GE Perkins 50 kVA","type":"Groupe électrogène","kva":50,"price":"À partir de 50 000 FCFA/sem","image":""}'::jsonb),
  ('location', 'l2', 1, '{"name":"GE Caterpillar 100 kVA","type":"Groupe électrogène","kva":100,"price":"À partir de 100 000 FCFA/sem","image":""}'::jsonb),
  ('location', 'l3', 2, '{"name":"Mini-pelle 1.7T","type":"Engin TP","kva":0,"price":"À partir de 85 000 FCFA/jour","image":""}'::jsonb),
  ('pieces', 'p1', 0, '{"name":"Filtre à huile Perkins","cat":"Filtration","price":"15 000 FCFA","image":""}'::jsonb),
  ('pieces', 'p2', 1, '{"name":"Huile 15W40 (20L)","cat":"Lubrifiants","price":"65 000 FCFA","image":""}'::jsonb),
  ('pieces', 'p3', 2, '{"name":"Batterie 12V 100Ah","cat":"Électrique","price":"80 000 FCFA","image":""}'::jsonb),
  ('vente', 'v1', 0, '{"name":"GE Perkins 20 kVA","cat":"Groupe","price":"Sur devis","image":""}'::jsonb),
  ('vente', 'v2', 1, '{"name":"Motopompe incendie","cat":"Motopompe","price":"Sur devis","image":""}'::jsonb)
on conflict (collection, id) do update
  set position = excluded.position, data = excluded.data;
