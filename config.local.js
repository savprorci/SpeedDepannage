// Fichier de TEST LOCAL — ignoré par git (voir .gitignore), à ne pas publier.
// Actif seulement si Supabase n'est pas configuré ET que la page est ouverte
// depuis un fichier local ou http://localhost. Sur le site publié, il est sans effet.
window.SD_CONFIG = Object.assign(window.SD_CONFIG || {}, {
  TEST_CODE: '2208'
});
