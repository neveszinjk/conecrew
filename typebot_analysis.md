# Análise do Typebot - Estrutura e Arquitetura

## Visão Geral do Projeto

**Typebot** é um construtor de chatbots "Fair Source" que permite criar chatbots avançados visualmente, incorporá-los em qualquer lugar e coletar resultados em tempo real.

### Versão Analisada
- **Versão**: 3.14.2 (latest)
- **Licença**: Functional Source License (FSL) - Após 2 anos torna-se Apache 2.0
- **Repositório**: https://github.com/baptisteArno/typebot.io

## Arquitetura do Projeto

### Estrutura de Diretórios

```
typebot.io/
├── apps/                          # Aplicações principais
│   ├── builder/                   # Interface de construção de bots (Next.js)
│   ├── viewer/                    # Interface de visualização/chat (Next.js)
│   ├── docs/                      # Documentação
│   └── landing-page/              # Página de landing
├── packages/                      # Pacotes compartilhados (monorepo)
│   ├── ai/                        # Integração com IA
│   ├── blocks/                    # Blocos do builder
│   ├── bot-engine/                # Motor do bot
│   ├── prisma/                    # ORM e schemas
│   ├── credentials/               # Gerenciamento de credenciais
│   ├── whatsapp/                  # Integração WhatsApp
│   └── ... (mais 80+ pacotes)
├── scripts/                       # Scripts de deployment
├── Dockerfile                     # Build multi-stage
├── docker-compose.yml             # Orquestração local
└── package.json                   # Workspace root
```

### Aplicações Principais

#### 1. **Builder** (`apps/builder`)
- Interface web para criar e editar chatbots
- Framework: Next.js 14+
- Porta padrão: 3000
- Funcionalidades:
  - Editor visual de fluxos
  - Gerenciamento de temas
  - Configuração de integrações
  - Autenticação de usuários

#### 2. **Viewer** (`apps/viewer`)
- Interface onde usuários interagem com os chatbots
- Framework: Next.js 14+
- Porta padrão: 3000 (em container separado)
- Funcionalidades:
  - Renderização de bots
  - Coleta de respostas
  - Integração com webhooks

### Dependências Principais

| Serviço | Versão | Propósito |
|---------|--------|----------|
| **PostgreSQL** | 16 | Banco de dados principal |
| **Redis** | Alpine | Cache e sessões |
| **Node.js** | 22+ | Runtime |
| **Bun** | 1.3.3 | Package manager e runtime |
| **Turbo** | 2.6.1+ | Monorepo orchestration |
| **Next.js** | 14+ | Framework web |
| **Prisma** | Último | ORM |

### Stack Tecnológico

**Frontend:**
- React + TypeScript
- TailwindCSS
- TanStack Query
- tRPC para API

**Backend:**
- Next.js API Routes
- Prisma ORM
- PostgreSQL
- Redis

**DevOps:**
- Docker & Docker Compose
- Turbo (monorepo)
- Bun (package manager)

## Variáveis de Ambiente Necessárias

### Essenciais

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `DATABASE_URL` | URL de conexão PostgreSQL | `postgresql://user:pass@host:5432/typebot` |
| `ENCRYPTION_SECRET` | Chave de 32 caracteres para encriptação | Gerado aleatoriamente |
| `NEXTAUTH_URL` | URL base do builder | `https://typebot.example.com` |
| `NEXT_PUBLIC_VIEWER_URL` | URL base do viewer | `https://bot.example.com` |
| `ADMIN_EMAIL` | Email do admin (plano UNLIMITED) | `admin@example.com` |

### Opcionais (para funcionalidades)

- **SMTP**: `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`
- **OAuth**: Google, GitHub, GitLab, Facebook, Azure AD, Keycloak
- **Storage**: S3 (AWS, MinIO, etc.)
- **Integrações**: OpenAI, Giphy, Unsplash, Pexels, WhatsApp
- **Cache**: `REDIS_URL`
- **Telemetria**: PostHog, Sentry

## Configuração de Deployment

### Docker

O projeto inclui um `Dockerfile` multi-stage otimizado:

1. **Build Bun** - Instala Bun na imagem base
2. **Base** - Node 22 + Bun
3. **Pruned** - Turbo prune para otimizar dependências
4. **Builder** - Build das aplicações
5. **Release** - Imagem final otimizada

**Argumentos de Build:**
- `SCOPE`: `builder` ou `viewer` (qual aplicação buildar)
- `BUN_VERSION`: Versão do Bun (default: 1.3.3)

### Docker Compose

O arquivo `docker-compose.yml` orquestra:
- **typebot-db**: PostgreSQL 16
- **typebot-redis**: Redis Alpine
- **typebot-builder**: Builder app (porta 8080)
- **typebot-viewer**: Viewer app (porta 8081)

## Requisitos para Self-Hosting

### Mínimos
- PostgreSQL 12+
- Redis (ou Valkey)
- Node.js 20+
- 2GB RAM
- 10GB espaço em disco

### Recomendados
- PostgreSQL 16
- Redis 7+
- Node.js 22
- 4GB+ RAM
- 20GB+ espaço em disco
- S3 (MinIO, AWS, etc.) para uploads

## Plano de Deployment no Railway

### Componentes Necessários

1. **PostgreSQL** - Banco de dados
2. **Valkey/Redis** - Cache
3. **MinIO** - Storage de mídia (S3-compatible)
4. **Builder Service** - Aplicação builder
5. **Viewer Service** - Aplicação viewer

### Configuração Railway

- **Builder**: Deploy da imagem `baptistearno/typebot-builder:latest`
- **Viewer**: Deploy da imagem `baptistearno/typebot-viewer:latest`
- **Variáveis de Ambiente**: Configuradas via Railway dashboard
- **Domínios**: Subdomínios Railway ou domínios customizados

## Licença e Limitações

### Fair Source License (FSL)

**Permitido:**
✅ Criar e publicar bots para clientes
✅ Usar como freelancer
✅ Pesquisa comercial
✅ Conteúdo educacional

**Não Permitido:**
❌ Comercializar acesso à instância
❌ Oferecer serviço de hosting Typebot
❌ Integrar editor em software próprio (sem usar código de 2 anos atrás)

**Após 2 anos:** Código torna-se Apache 2.0 (permissivo)

## Próximos Passos

1. Preparar variáveis de ambiente
2. Configurar banco de dados PostgreSQL
3. Configurar storage S3 (MinIO)
4. Deploy no Railway
5. Configurar domínios e SSL
6. Testar funcionalidades
