# Configuração do Typebot no Railway

## Pré-requisitos

1. Conta no Railway (https://railway.app)
2. Repositório GitHub com o código do Typebot (fork ou clone)
3. Conhecimento básico de variáveis de ambiente

## Passo 1: Preparar o Repositório

### Opção A: Usar o Repositório Oficial

```bash
# Clonar o repositório
git clone https://github.com/baptisteArno/typebot.io.git
cd typebot.io
git checkout latest
```

### Opção B: Fazer Fork no GitHub

1. Acesse https://github.com/baptisteArno/typebot.io
2. Clique em "Fork"
3. Clone seu fork:
```bash
git clone https://github.com/seu-usuario/typebot.io.git
cd typebot.io
```

## Passo 2: Gerar Chaves Necessárias

### 1. Gerar ENCRYPTION_SECRET

```bash
# Opção 1: Usar OpenSSL
openssl rand -base64 32

# Opção 2: Usar Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# Opção 3: Usar Bun
bun -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# Opção 4: Online (menos seguro)
# https://www.uuidgenerator.net/
```

**Exemplo de saída:**
```
aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcd=
```

### 2. Definir URLs

**Builder URL (onde você cria os bots):**
```
https://typebot-builder-seu-projeto.railway.app
```

**Viewer URL (onde os usuários interagem com os bots):**
```
https://typebot-viewer-seu-projeto.railway.app
```

Ou use domínios customizados:
```
https://typebot.seu-dominio.com
https://bot.seu-dominio.com
```

## Passo 3: Configurar Serviços no Railway

### 3.1 Criar Novo Projeto

1. Acesse https://railway.app/dashboard
2. Clique em "New Project"
3. Selecione "Deploy from GitHub"
4. Conecte sua conta GitHub
5. Selecione o repositório `typebot.io`

### 3.2 Adicionar Serviços

#### PostgreSQL

1. Clique em "+ Add Service"
2. Selecione "PostgreSQL"
3. Configure:
   - **Name**: `typebot-db`
   - **Version**: 16 (recomendado)

Railway criará automaticamente:
- `DATABASE_URL` (salve esta URL)
- Usuário e senha

#### Redis/Valkey

1. Clique em "+ Add Service"
2. Selecione "Redis" ou "Valkey"
3. Configure:
   - **Name**: `typebot-redis`
   - **Version**: Latest

Railway criará automaticamente:
- `REDIS_URL` (salve esta URL)

#### MinIO (Storage S3)

1. Clique em "+ Add Service"
2. Selecione "Docker Image"
3. Configure:
   - **Image**: `minio/minio:latest`
   - **Name**: `typebot-minio`
   - **Port**: 9000

Variáveis de Ambiente para MinIO:
```
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin123
```

### 3.3 Configurar Builder Service

1. Clique em "+ Add Service"
2. Selecione "GitHub Repo"
3. Selecione o repositório `typebot.io`
4. Configure:
   - **Name**: `typebot-builder`
   - **Branch**: `latest` ou `main`
   - **Root Directory**: `.` (raiz do projeto)

**Variáveis de Ambiente:**

```env
# Essenciais
DATABASE_URL=postgresql://user:password@host:5432/typebot
ENCRYPTION_SECRET=aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcd=
NEXTAUTH_URL=https://typebot-builder-seu-projeto.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer-seu-projeto.railway.app
ADMIN_EMAIL=seu-email@exemplo.com

# Redis
REDIS_URL=redis://host:6379

# Storage S3 (MinIO)
S3_ENDPOINT=https://typebot-minio-seu-projeto.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot

# Opcional: Configuração de Plano
DEFAULT_WORKSPACE_PLAN=UNLIMITED

# Opcional: SMTP para emails
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USERNAME=seu-email@gmail.com
SMTP_PASSWORD=sua-senha-app
```

**Build Command:**
```bash
bun install && bunx turbo build --filter=builder...
```

**Start Command:**
```bash
cd apps/builder && bun start
```

**Port:** 3000

### 3.4 Configurar Viewer Service

1. Clique em "+ Add Service"
2. Selecione "GitHub Repo"
3. Selecione o repositório `typebot.io`
4. Configure:
   - **Name**: `typebot-viewer`
   - **Branch**: `latest` ou `main`
   - **Root Directory**: `.` (raiz do projeto)

**Variáveis de Ambiente:**

```env
# Essenciais
DATABASE_URL=postgresql://user:password@host:5432/typebot
ENCRYPTION_SECRET=aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcd=
NEXTAUTH_URL=https://typebot-builder-seu-projeto.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer-seu-projeto.railway.app

# Redis
REDIS_URL=redis://host:6379

# Storage S3 (MinIO)
S3_ENDPOINT=https://typebot-minio-seu-projeto.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
```

**Build Command:**
```bash
bun install && bunx turbo build --filter=viewer...
```

**Start Command:**
```bash
cd apps/viewer && bun start
```

**Port:** 3000

## Passo 4: Configurar Domínios Customizados (Opcional)

### No Railway

1. Acesse o serviço (Builder ou Viewer)
2. Clique em "Settings"
3. Em "Domains", clique em "Add Domain"
4. Escolha entre:
   - **Railway Domain**: `seu-projeto.railway.app`
   - **Custom Domain**: `typebot.seu-dominio.com`

### Para Domínio Customizado

1. Acesse seu provedor de DNS (Namecheap, GoDaddy, etc.)
2. Crie um registro CNAME:
   - **Host**: `typebot` (ou `bot`)
   - **Value**: `seu-projeto.railway.app`

3. Aguarde propagação DNS (5-48 horas)

4. Configure SSL no Railway (automático com Let's Encrypt)

## Passo 5: Configurar Banco de Dados

### Executar Migrations

1. No Railway, acesse o serviço PostgreSQL
2. Clique em "Connect"
3. Use o comando psql fornecido

Ou execute via Railway CLI:

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Conectar ao projeto
railway link

# Executar migrations
railway run bunx turbo db:migrate
```

## Passo 6: Variáveis de Ambiente Completas

### Mínimo Necessário

```env
# Database
DATABASE_URL=postgresql://postgres:password@host:5432/typebot

# Encryption
ENCRYPTION_SECRET=gere-uma-chave-aleatoria-de-32-caracteres

# URLs
NEXTAUTH_URL=https://typebot-builder.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer.railway.app

# Admin
ADMIN_EMAIL=seu-email@exemplo.com

# Redis
REDIS_URL=redis://host:6379

# Node
NODE_OPTIONS=--no-node-snapshot
```

### Completo com Opcionais

```env
# === DATABASE ===
DATABASE_URL=postgresql://postgres:password@host:5432/typebot

# === ENCRYPTION ===
ENCRYPTION_SECRET=gere-uma-chave-aleatoria-de-32-caracteres

# === URLS ===
NEXTAUTH_URL=https://typebot-builder.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer.railway.app

# === ADMIN ===
ADMIN_EMAIL=seu-email@exemplo.com
DEFAULT_WORKSPACE_PLAN=UNLIMITED

# === REDIS ===
REDIS_URL=redis://host:6379

# === S3 / MinIO ===
S3_ENDPOINT=https://typebot-minio.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
S3_SSL=true
S3_REGION=us-east-1

# === SMTP (Emails) ===
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USERNAME=seu-email@gmail.com
SMTP_PASSWORD=sua-senha-app
SMTP_TLS=true

# === OAUTH (Opcional) ===
# Google
GOOGLE_CLIENT_ID=seu-client-id
GOOGLE_CLIENT_SECRET=seu-client-secret

# GitHub
GITHUB_CLIENT_ID=seu-client-id
GITHUB_CLIENT_SECRET=seu-client-secret

# === NODE ===
NODE_OPTIONS=--no-node-snapshot
NODE_ENV=production

# === LOGGING ===
LOG_LEVEL=info
```

## Passo 7: Deploy

### Opção 1: Deploy Automático

1. Faça push para GitHub:
```bash
git add .
git commit -m "Deploy configuration"
git push origin latest
```

2. Railway detectará automaticamente e iniciará o deploy

### Opção 2: Deploy Manual via CLI

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Conectar ao projeto
railway link

# Deploy
railway up
```

## Passo 8: Verificar Deployment

1. Acesse https://railway.app/dashboard
2. Verifique o status dos serviços:
   - ✅ PostgreSQL (healthy)
   - ✅ Redis (healthy)
   - ✅ MinIO (healthy)
   - ✅ Builder (running)
   - ✅ Viewer (running)

3. Acesse os domínios:
   - Builder: https://typebot-builder.railway.app
   - Viewer: https://typebot-viewer.railway.app

4. Faça login com o email do admin

## Troubleshooting

### Erro: "DATABASE_URL not found"
- Verifique se PostgreSQL foi criado
- Copie a URL do PostgreSQL para DATABASE_URL
- Redeploy os serviços

### Erro: "ENCRYPTION_SECRET is required"
- Gere uma nova chave: `openssl rand -base64 32`
- Adicione às variáveis de ambiente
- Redeploy

### Erro: "Connection refused"
- Verifique se os serviços estão rodando
- Verifique as URLs de conexão
- Verifique firewall/network policies

### Erro: "Cannot find module"
- Limpe cache: `railway run bun install`
- Redeploy
- Verifique Node.js version (deve ser 22+)

### Erro: "S3 bucket not found"
- Crie o bucket manualmente no MinIO
- Verifique credenciais S3
- Verifique endpoint URL

## Próximos Passos

1. ✅ Configurar domínios customizados
2. ✅ Configurar SSL/TLS
3. ✅ Configurar backups automáticos
4. ✅ Configurar monitoramento
5. ✅ Criar primeiro bot
6. ✅ Testar integração com webhooks

## Recursos Úteis

- Documentação Railway: https://docs.railway.app
- Documentação Typebot: https://docs.typebot.io
- Discord Typebot: https://typebot.io/discord
- GitHub Issues: https://github.com/baptisteArno/typebot.io/issues
