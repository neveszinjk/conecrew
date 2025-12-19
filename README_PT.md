# 🚀 Typebot Self-Hosted no Railway

Bem-vindo! Este repositório contém o **Typebot v3.14.2** configurado para deploy automático no Railway com **plano UNLIMITED**.

## ⚡ Deploy Rápido (Um Clique)

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new?repo=https://github.com/neveszinjk/conecrew&envs=DATABASE_URL,ENCRYPTION_SECRET,NEXTAUTH_URL,NEXT_PUBLIC_VIEWER_URL,ADMIN_EMAIL,REDIS_URL,S3_ENDPOINT,S3_ACCESS_KEY_ID,S3_SECRET_ACCESS_KEY,S3_BUCKET_NAME&DEFAULT_WORKSPACE_PLAN=UNLIMITED)

## 📚 Documentação

Comece pela documentação em português:

1. **[INDICE.md](./INDICE.md)** - Índice completo com navegação
2. **[README_DEPLOYMENT.md](./README_DEPLOYMENT.md)** - Visão geral e guia rápido
3. **[guia_instalacao_typebot_railway.md](./guia_instalacao_typebot_railway.md)** - Guia passo a passo
4. **[quick_reference.md](./quick_reference.md)** - Referência rápida
5. **[typebot_analysis.md](./typebot_analysis.md)** - Análise técnica
6. **[railway-config.md](./railway-config.md)** - Configuração detalhada

## 🛠️ Ferramentas

- **[setup-railway.sh](./setup-railway.sh)** - Script de setup automático
- **[.env.railway.example](./.env.railway.example)** - Variáveis de ambiente

## 🎯 O que você vai conseguir

✅ **Typebot Ilimitado** - Sem restrições de bots, mensagens ou usuários
✅ **Infraestrutura Completa** - PostgreSQL, Redis, MinIO
✅ **Domínios Customizados** - Use seu próprio domínio
✅ **SSL/TLS Automático** - Certificados Let's Encrypt
✅ **Dados Próprios** - Controle total
✅ **Escalável** - Cresça conforme necessário

## 🚀 Primeiros Passos

### Opção 1: Deploy Automático (Recomendado)

1. Clique no botão "Deploy on Railway" acima
2. Configure as variáveis de ambiente
3. Aguarde o deployment
4. Acesse sua instância

### Opção 2: Deploy Manual

1. Leia [guia_instalacao_typebot_railway.md](./guia_instalacao_typebot_railway.md)
2. Execute [setup-railway.sh](./setup-railway.sh)
3. Configure no Railway
4. Deploy

## 📋 Variáveis de Ambiente Essenciais

```env
DATABASE_URL=postgresql://...
ENCRYPTION_SECRET=sua-chave-de-32-caracteres
NEXTAUTH_URL=https://seu-dominio-builder.railway.app
NEXT_PUBLIC_VIEWER_URL=https://seu-dominio-viewer.railway.app
ADMIN_EMAIL=seu-email@dominio.com
DEFAULT_WORKSPACE_PLAN=UNLIMITED
REDIS_URL=redis://...
S3_ENDPOINT=https://seu-minio.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
```

## 🏗️ Arquitetura

```
Railway
├── PostgreSQL (Banco de dados)
├── Redis (Cache)
├── MinIO (Storage S3)
├── typebot-builder (Interface de criação)
└── typebot-viewer (Interface de usuário)
```

## 📞 Suporte

- **Documentação Typebot**: https://docs.typebot.io
- **GitHub Typebot**: https://github.com/baptisteArno/typebot.io
- **Discord**: https://typebot.io/discord
- **Railway Docs**: https://docs.railway.app

## 📝 Licença

Typebot é protegido pela **Functional Source License (FSL)**. Você pode usar para criar bots, fazer pesquisa comercial e criar conteúdo educacional. Após 2 anos, torna-se Apache 2.0.

## ✨ Recursos

- 💬 34+ blocos de construção
- 🎨 Temas customizáveis
- 🔌 Integrações (OpenAI, Google Sheets, Webhooks, etc.)
- 📊 Analytics e resultados em tempo real
- 👨‍💻 API completa
- ⚡ Embed rápido sem iframe

---

**Versão**: 3.14.2
**Atualizado**: 19 de Dezembro de 2025
**Autor**: Manus AI

Boa sorte! 🎉
