# 🔧 Fix Rápido para Erros de Build no Railway

## ❌ Problema

Os serviços estão falhando no build com erro:
```
ERROR: failed to build: failed to solve: failed to compute cache key: 
"/scripts/-entrypoint.sh": not found
```

## ✅ Solução Rápida

Ao invés de compilar o Typebot do zero (que é complexo), vamos usar as **imagens Docker pré-compiladas** do Typebot que já estão prontas no Docker Hub.

### Passo 1: Deletar os Serviços Antigos

1. Acesse https://railway.app/dashboard
2. Para cada serviço que deu erro (Builder, Viewer):
   - Clique no serviço
   - Vá para **Settings**
   - Clique em **Delete Service**
   - Confirme

### Passo 2: Criar Novo Serviço Builder

1. Clique em **+ New Service**
2. Selecione **Docker Image**
3. Configure:
   - **Image**: `baptistearno/typebot-builder:latest`
   - **Name**: `typebot-builder`
   - **Port**: `3000`

4. Vá para **Variables** e adicione:
```env
DATABASE_URL=${Postgres.DATABASE_URL}
REDIS_URL=${Redis.REDIS_URL}
ENCRYPTION_SECRET=sua-chave-de-32-caracteres
NEXTAUTH_URL=https://seu-dominio-builder.railway.app
NEXT_PUBLIC_VIEWER_URL=https://seu-dominio-viewer.railway.app
ADMIN_EMAIL=seu-email@dominio.com
DEFAULT_WORKSPACE_PLAN=UNLIMITED
S3_ENDPOINT=https://seu-minio.railway.app
S3_ACCESS_KEY_ID=minioadmin
S3_SECRET_ACCESS_KEY=minioadmin123
S3_BUCKET_NAME=typebot
NODE_ENV=production
PORT=3000
```

5. Clique em **Deploy**

### Passo 3: Criar Novo Serviço Viewer

1. Repita o Passo 2, mas com:
   - **Image**: `baptistearno/typebot-viewer:latest`
   - **Name**: `typebot-viewer`

2. Use as **mesmas variáveis de ambiente**

3. Clique em **Deploy**

### Passo 4: Aguardar Deploy

- Aguarde ambos os serviços ficarem com status **"Running"**
- Isso deve levar 2-5 minutos

### Passo 5: Executar Migrações

1. Clique no serviço **typebot-builder**
2. Vá para **Settings** > **Shell**
3. Execute:
```bash
bunx turbo db:migrate
```

4. Aguarde completar

### Passo 6: Testar

1. Acesse a URL do Builder
2. Faça login com seu email
3. Crie um novo bot
4. Teste no Viewer

## 🎯 Por que isso funciona?

- ✅ As imagens estão **pré-compiladas** e testadas
- ✅ Não precisa compilar Bun, Node, etc.
- ✅ Muito mais rápido (2-5 minutos vs 30+ minutos)
- ✅ Menos chance de erros
- ✅ Usa menos recursos

## ⚠️ Importante

- **Não use o Dockerfile original** para Railway
- **Use as imagens do Docker Hub** (muito mais simples)
- **Mantenha as mesmas variáveis de ambiente** em ambos os serviços

## 📞 Se Ainda Tiver Problemas

1. Verifique se PostgreSQL e Redis estão rodando
2. Verifique se as variáveis de ambiente estão corretas
3. Verifique os logs do Railway para mensagens de erro específicas
4. Tente deletar e criar o serviço novamente

## 🚀 Próximos Passos

Após o deploy bem-sucedido:

1. Configure domínios customizados
2. Configure backups automáticos
3. Configure monitoramento
4. Crie seu primeiro bot!

---

**Versão**: 1.0
**Data**: 19 de Dezembro de 2025
**Autor**: Manus AI
