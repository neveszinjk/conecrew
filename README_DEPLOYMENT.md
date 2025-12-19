# Typebot Self-Hosted no Railway - Documentação Completa

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [O que você vai conseguir](#o-que-você-vai-conseguir)
3. [Arquivos Inclusos](#arquivos-inclusos)
4. [Guia Rápido de Início](#guia-rápido-de-início)
5. [Guia Detalhado](#guia-detalhado)
6. [Troubleshooting](#troubleshooting)
7. [Próximos Passos](#próximos-passos)

---

## 🎯 Visão Geral

Este pacote contém tudo que você precisa para instalar e hospedar uma **instância própria e ilimitada do Typebot** na plataforma **Railway**. Você terá controle total sobre a infraestrutura, dados e funcionalidades, sem limitações de plano comercial.

### Por que fazer isso?

- ✅ **Sem Limitações**: Plano UNLIMITED com acesso a todas as funcionalidades
- ✅ **Dados Próprios**: Seus dados ficam sob seu controle
- ✅ **Customização Total**: Modifique o código conforme necessário
- ✅ **Escalabilidade**: Escale conforme sua demanda cresce
- ✅ **Economia**: Pague apenas pela infraestrutura que usar

---

## 🚀 O que você vai conseguir

Após seguir este guia, você terá:

| Recurso | Incluído |
|---------|----------|
| **Chatbot Builder** | Sim - Interface completa para criar bots |
| **Chatbot Viewer** | Sim - Interface para usuários interagirem |
| **Banco de Dados** | Sim - PostgreSQL 16 |
| **Cache** | Sim - Redis para performance |
| **Storage de Mídia** | Sim - MinIO (S3-compatible) |
| **Plano Ilimitado** | Sim - Sem restrições |
| **Domínios Customizados** | Sim - Use seu próprio domínio |
| **SSL/TLS** | Sim - Certificados automáticos |
| **Backups** | Sim - Configurável no Railway |
| **Monitoramento** | Sim - Dashboard do Railway |

---

## 📦 Arquivos Inclusos

Este pacote contém os seguintes arquivos de documentação e configuração:

### 📄 Documentação

1. **`guia_instalacao_typebot_railway.md`** - Guia completo e detalhado (COMECE AQUI)
2. **`quick_reference.md`** - Referência rápida com checklist e troubleshooting
3. **`typebot_analysis.md`** - Análise técnica da arquitetura do Typebot
4. **`railway-config.md`** - Configuração detalhada do Railway
5. **`README_DEPLOYMENT.md`** - Este arquivo

### 🛠️ Ferramentas

1. **`setup-railway.sh`** - Script de setup automático (recomendado)
2. **`.env.railway.example`** - Arquivo de exemplo de variáveis de ambiente
3. **`typebot.io/`** - Repositório completo do Typebot (v3.14.2)

---

## ⚡ Guia Rápido de Início

### Para os Apressados (5 minutos)

1. **Faça um fork** do repositório em GitHub:
   - Acesse https://github.com/baptisteArno/typebot.io
   - Clique em "Fork"

2. **Acesse o Railway**:
   - Vá para https://railway.app
   - Crie uma conta ou faça login
   - Crie um novo projeto

3. **Adicione os serviços**:
   - PostgreSQL
   - Redis
   - MinIO (Docker image: `minio/minio:latest`)

4. **Configure o Builder e Viewer**:
   - Adicione dois serviços do GitHub repo
   - Configure as variáveis de ambiente (veja `.env.railway.example`)
   - Configure os comandos de build e start

5. **Execute as migrações**:
   - Conecte ao shell do serviço builder
   - Execute: `bunx turbo db:migrate`

6. **Acesse sua instância**:
   - Builder: https://seu-dominio-builder.railway.app
   - Viewer: https://seu-dominio-viewer.railway.app

---

## 📚 Guia Detalhado

Para um guia passo a passo completo, consulte:

👉 **[`guia_instalacao_typebot_railway.md`](./guia_instalacao_typebot_railway.md)**

Este documento cobre:
- Pré-requisitos
- Preparação do código-fonte
- Configuração do Railway
- Adição de serviços
- Configuração de variáveis de ambiente
- Execução de migrações
- Troubleshooting

---

## 🔧 Variáveis de Ambiente Essenciais

As variáveis mais importantes que você precisa configurar:

```env
# Database
DATABASE_URL=postgresql://user:password@host:5432/typebot

# Encryption (gerar com: openssl rand -base64 32)
ENCRYPTION_SECRET=sua-chave-aleatoria-de-32-caracteres

# URLs (substituir pelos domínios do Railway)
NEXTAUTH_URL=https://typebot-builder-xxx.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer-xxx.railway.app

# Admin (este email terá plano UNLIMITED)
ADMIN_EMAIL=seu-email@dominio.com
DEFAULT_WORKSPACE_PLAN=UNLIMITED

# Redis
REDIS_URL=redis://host:6379

# S3 / MinIO
S3_ENDPOINT=https://typebot-minio-xxx.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
```

Para a lista completa, veja **[`.env.railway.example`](./.env.railway.example)**

---

## 🐛 Troubleshooting

### Problema: Build falha com erro de memória

**Solução**: Adicione a variável de ambiente:
```env
NODE_OPTIONS=--max-old-space-size=4096
```

### Problema: Erro "DATABASE_URL not found"

**Solução**: 
1. Verifique se PostgreSQL foi criado no Railway
2. Copie a URL do PostgreSQL para a variável `DATABASE_URL`
3. Redeploy os serviços

### Problema: Imagens não carregam

**Solução**:
1. Acesse o MinIO e crie um bucket chamado `typebot`
2. Defina a política do bucket como "Public"
3. Verifique se as variáveis `S3_*` estão corretas

### Problema: Login não funciona

**Solução**:
1. Verifique se `NEXTAUTH_URL` corresponde ao domínio do builder
2. Verifique se `ENCRYPTION_SECRET` é válido (32 caracteres em base64)
3. Redeploy o serviço builder

Para mais soluções, consulte **[`quick_reference.md`](./quick_reference.md)**

---

## 📊 Arquitetura do Deployment

```
┌─────────────────────────────────────────────────────┐
│                    Railway                          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────┐  ┌──────────────┐                │
│  │   Builder    │  │   Viewer     │                │
│  │  (Next.js)   │  │  (Next.js)   │                │
│  └──────┬───────┘  └──────┬───────┘                │
│         │                 │                        │
│         └────────┬────────┘                        │
│                  │                                 │
│         ┌────────▼────────┐                        │
│         │   PostgreSQL    │                        │
│         │   (Database)    │                        │
│         └─────────────────┘                        │
│                                                     │
│         ┌─────────────────┐                        │
│         │     Redis       │                        │
│         │    (Cache)      │                        │
│         └─────────────────┘                        │
│                                                     │
│         ┌─────────────────┐                        │
│         │     MinIO       │                        │
│         │  (S3 Storage)   │                        │
│         └─────────────────┘                        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🎓 Próximos Passos

Após o deployment bem-sucedido:

1. **Criar seu primeiro bot**:
   - Acesse o Builder
   - Clique em "Create Typebot"
   - Use o editor visual para criar seu chatbot

2. **Testar o bot**:
   - Acesse o Viewer
   - Interaja com seu bot
   - Verifique se as respostas são coletadas

3. **Configurar domínio customizado** (opcional):
   - No Railway, adicione seu domínio
   - Configure os registros DNS
   - Aguarde a propagação

4. **Integrar com seu site**:
   - Use o código de embed fornecido
   - Customize a aparência do bot
   - Teste em produção

5. **Configurar backups**:
   - Configure backups automáticos do PostgreSQL
   - Exporte dados regularmente

6. **Monitorar performance**:
   - Use o dashboard do Railway
   - Configure alertas
   - Escale conforme necessário

---

## 📞 Suporte e Recursos

- **Documentação Oficial**: https://docs.typebot.io
- **GitHub**: https://github.com/baptisteArno/typebot.io
- **Discord Community**: https://typebot.io/discord
- **Railway Docs**: https://docs.railway.app
- **Issues**: https://github.com/baptisteArno/typebot.io/issues

---

## 📝 Notas Importantes

### Licença

O Typebot é protegido pela **Functional Source License (FSL)**. Você pode:

✅ Usar para criar bots para clientes
✅ Usar como freelancer
✅ Fazer pesquisa comercial
✅ Criar conteúdo educacional

❌ Não pode comercializar o acesso à sua instância
❌ Não pode oferecer serviço de hosting Typebot

Após 2 anos, o código torna-se Apache 2.0 (permissivo).

### Segurança

- Sempre use `HTTPS` em produção
- Mantenha `ENCRYPTION_SECRET` seguro
- Use senhas fortes para MinIO
- Configure backups regulares
- Monitore logs de erro

### Performance

- Recomendado: 4GB RAM, 20GB disco
- Mínimo: 2GB RAM, 10GB disco
- Redis melhora performance significativamente
- Configure CDN para mídia estática

---

## 🎉 Conclusão

Você agora tem tudo que precisa para hospedar uma instância completa e ilimitada do Typebot no Railway!

**Comece pelo guia detalhado**: [`guia_instalacao_typebot_railway.md`](./guia_instalacao_typebot_railway.md)

Boa sorte! 🚀

---

**Versão**: 1.0
**Atualizado**: 19 de Dezembro de 2025
**Typebot Version**: 3.14.2
**Autor**: Manus AI
