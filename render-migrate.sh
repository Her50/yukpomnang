#!/bin/bash
echo "🚀 Render Migration Script - Démarrage..."

# Attendre que la base de données soit prête
echo "⏳ Attente de la base de données..."
sleep 5

# Vérifier si DATABASE_URL est définie
if [ -z "$DATABASE_URL" ]; then
    echo "❌ DATABASE_URL n'est pas définie"
    exit 1
fi

echo "📊 Application des migrations de colonnes nom/prenom..."

# Appliquer manuellement la migration des colonnes nom/prenom
psql "$DATABASE_URL" -c "
-- Migration pour ajouter les colonnes nom et photo de profil aux utilisateurs
ALTER TABLE users ADD COLUMN IF NOT EXISTS nom VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS prenom VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS nom_complet VARCHAR(255);
ALTER TABLE users ADD COLUMN IF NOT EXISTS photo_profil VARCHAR(500);
ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(500);

-- Mettre à jour les utilisateurs existants avec des noms par défaut basés sur l'email
UPDATE users 
SET nom_complet = COALESCE(
    nom_complet, 
    split_part(email, '@', 1)
)
WHERE nom_complet IS NULL;

-- Mettre à jour les avatars par défaut pour les utilisateurs existants
UPDATE users 
SET avatar_url = COALESCE(
    avatar_url,
    'https://ui-avatars.com/api/?name=' || 
    COALESCE(nom_complet, split_part(email, '@', 1)) ||
    '&background=random&color=fff&size=200'
)
WHERE avatar_url IS NULL;

-- Créer des index pour les recherches
CREATE INDEX IF NOT EXISTS idx_users_nom_complet ON users(nom_complet);
CREATE INDEX IF NOT EXISTS idx_users_photo_profil ON users(photo_profil);
CREATE INDEX IF NOT EXISTS idx_users_avatar_url ON users(avatar_url);
"

if [ $? -eq 0 ]; then
    echo "✅ Migrations appliquées avec succès !"
else
    echo "⚠️  Erreur lors de l'application des migrations, mais on continue..."
fi

echo "🚀 Démarrage de l'application Rust..."
cd backend
cargo run --release