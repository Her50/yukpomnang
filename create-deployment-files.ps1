# Script pour créer tous les fichiers de déploiement

# Créer le fichier .env pour la production
@'
# Configuration de production pour Railway
DATABASE_URL=postgresql://username:password@host:5432/database
REDIS_URL=redis://host:6379/0
MONGODB_URL=mongodb://host:27017/yukpomnang
ENVIRONMENT=production
RUST_LOG=info
JWT_SECRET=your_jwt_secret_here_production
ENCRYPTION_KEY=your_encryption_key_here_production
YUKPO_API_KEY=yukpo_backend_key_2024
EMBEDDING_API_KEY=yukpo_embedding_key_2024
EMBEDDING_SERVICE_URL=http://localhost:8000
AI_SERVICE_URL=https://api.openai.com/v1
HOST=0.0.0.0
PORT=8000
'@ | Out-File -FilePath ".env.production" -Encoding UTF8

# Créer le fichier Procfile pour Railway
@'
web: cd backend && cargo run --release
'@ | Out-File -FilePath "Procfile" -Encoding UTF8

# Créer le fichier .railwayignore
@'
node_modules/
target/
.git/
*.log
.env
.env.local
.env.development
'@ | Out-File -FilePath ".railwayignore" -Encoding UTF8

Write-Host "Fichiers de déploiement créés avec succès!"
