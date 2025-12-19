#!/bin/bash

# ============================================
# Script de Setup Automático do Typebot no Railway
# ============================================
# Este script ajuda a configurar o Typebot no Railway
# Uso: bash setup-railway.sh

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Typebot - Setup Automático para Railway                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cor
print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Verificar se está no diretório correto
if [ ! -f "package.json" ] || [ ! -d "apps/builder" ] || [ ! -d "apps/viewer" ]; then
    print_error "Este script deve ser executado no diretório raiz do Typebot"
    exit 1
fi

print_step "Verificando dependências..."

# Verificar se bun está instalado
if ! command -v bun &> /dev/null; then
    print_warning "Bun não está instalado. Instalando..."
    curl -fsSL https://bun.sh/install | bash
    export PATH="$HOME/.bun/bin:$PATH"
fi
print_success "Bun encontrado"

# Verificar se openssl está instalado
if ! command -v openssl &> /dev/null; then
    print_error "OpenSSL não está instalado. Por favor, instale-o."
    exit 1
fi
print_success "OpenSSL encontrado"

echo ""
print_step "Gerando configurações..."
echo ""

# Gerar ENCRYPTION_SECRET
print_step "Gerando ENCRYPTION_SECRET..."
ENCRYPTION_SECRET=$(openssl rand -base64 32)
print_success "ENCRYPTION_SECRET gerado: $ENCRYPTION_SECRET"

echo ""
print_step "Coletando informações..."
echo ""

# Coletar informações do usuário
read -p "$(echo -e ${BLUE}▶${NC}) Email do administrador: " ADMIN_EMAIL
read -p "$(echo -e ${BLUE}▶${NC}) Domínio do Builder (ex: typebot-builder-xxx.railway.app): " BUILDER_URL
read -p "$(echo -e ${BLUE}▶${NC}) Domínio do Viewer (ex: typebot-viewer-xxx.railway.app): " VIEWER_URL
read -p "$(echo -e ${BLUE}▶${NC}) Domínio do MinIO (ex: typebot-minio-xxx.railway.app): " MINIO_URL

echo ""
print_step "Validando URLs..."

# Validar URLs
if [[ ! $BUILDER_URL =~ ^https?:// ]]; then
    BUILDER_URL="https://$BUILDER_URL"
fi

if [[ ! $VIEWER_URL =~ ^https?:// ]]; then
    VIEWER_URL="https://$VIEWER_URL"
fi

if [[ ! $MINIO_URL =~ ^https?:// ]]; then
    MINIO_URL="https://$MINIO_URL"
fi

print_success "URLs validadas"

echo ""
print_step "Criando arquivo .env para Railway..."

# Criar arquivo .env
cat > .env.railway << EOF
# Typebot - Configuração para Railway
# Gerado automaticamente em $(date)

# Database
DATABASE_URL=\${Postgres.DATABASE_URL}

# Encryption
ENCRYPTION_SECRET=$ENCRYPTION_SECRET

# URLs
NEXTAUTH_URL=$BUILDER_URL
NEXT_PUBLIC_VIEWER_URL=$VIEWER_URL

# Admin
ADMIN_EMAIL=$ADMIN_EMAIL
DEFAULT_WORKSPACE_PLAN=UNLIMITED

# Redis
REDIS_URL=\${Redis.REDIS_URL}

# S3 / MinIO
S3_ENDPOINT=$MINIO_URL
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
S3_SSL=true
S3_REGION=us-east-1

# Node
NODE_OPTIONS=--no-node-snapshot
NODE_ENV=production
EOF

print_success "Arquivo .env.railway criado"

echo ""
print_step "Instalando dependências..."

# Instalar dependências
bun install > /dev/null 2>&1 || {
    print_error "Falha ao instalar dependências"
    exit 1
}

print_success "Dependências instaladas"

echo ""
print_step "Verificando estrutura do projeto..."

# Verificar estrutura
if [ -f "apps/builder/package.json" ] && [ -f "apps/viewer/package.json" ]; then
    print_success "Estrutura do projeto validada"
else
    print_error "Estrutura do projeto inválida"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Setup Concluído com Sucesso!                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}Próximos passos:${NC}"
echo ""
echo "1. Acesse https://railway.app/dashboard"
echo "2. Crie um novo projeto"
echo "3. Adicione os serviços:"
echo "   - PostgreSQL"
echo "   - Redis"
echo "   - MinIO"
echo "   - typebot-builder"
echo "   - typebot-viewer"
echo ""
echo "4. Configure as variáveis de ambiente em cada serviço:"
echo "   - Copie o conteúdo de .env.railway"
echo ""
echo "5. Defina os comandos de build e start:"
echo ""
echo "   Builder:"
echo "   - Build: bun install && bunx turbo build --filter=builder..."
echo "   - Start: cd apps/builder && bun start"
echo ""
echo "   Viewer:"
echo "   - Build: bun install && bunx turbo build --filter=viewer..."
echo "   - Start: cd apps/viewer && bun start"
echo ""
echo "6. Após o deploy, execute as migrações:"
echo "   - bunx turbo db:migrate"
echo ""
echo "7. Crie o bucket no MinIO:"
echo "   - Nome: typebot"
echo "   - Política: Public"
echo ""
echo -e "${YELLOW}Informações Geradas:${NC}"
echo ""
echo "Email Admin: $ADMIN_EMAIL"
echo "Builder URL: $BUILDER_URL"
echo "Viewer URL: $VIEWER_URL"
echo "MinIO URL: $MINIO_URL"
echo "ENCRYPTION_SECRET: $ENCRYPTION_SECRET"
echo ""
echo -e "${YELLOW}Arquivo de Configuração:${NC} .env.railway"
echo ""
echo "Para mais informações, visite:"
echo "- Docs: https://docs.typebot.io"
echo "- Discord: https://typebot.io/discord"
echo ""
