# Referência Rápida: Typebot no Railway

## Checklist de Deployment

- [ ] Fork do repositório em GitHub
- [ ] Criar projeto no Railway
- [ ] Adicionar PostgreSQL
- [ ] Adicionar Redis
- [ ] Adicionar MinIO
- [ ] Criar serviço `typebot-builder`
- [ ] Criar serviço `typebot-viewer`
- [ ] Configurar variáveis de ambiente
- [ ] Executar migrações do banco
- [ ] Criar bucket no MinIO
- [ ] Testar acesso ao Builder
- [ ] Criar primeiro bot

## Variáveis de Ambiente Essenciais

```env
# Database
DATABASE_URL=postgresql://user:password@host:5432/typebot

# Encryption (gerar com: openssl rand -base64 32)
ENCRYPTION_SECRET=aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcd=

# URLs (substituir pelos domínios do Railway)
NEXTAUTH_URL=https://typebot-builder-xxx.railway.app
NEXT_PUBLIC_VIEWER_URL=https://typebot-viewer-xxx.railway.app

# Admin
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

## Comandos Importantes

### Gerar ENCRYPTION_SECRET
```bash
openssl rand -base64 32
```

### Executar Migrações
```bash
bunx turbo db:migrate
```

### Build Local (Teste)
```bash
bun install
bunx turbo build --filter=builder...
bunx turbo build --filter=viewer...
```

### Iniciar Localmente
```bash
cd apps/builder && bun start
cd apps/viewer && bun start
```

## Estrutura do Typebot

| Componente | Porta | Função |
|-----------|-------|--------|
| Builder | 3000 | Interface para criar bots |
| Viewer | 3000 | Interface para usuários |
| PostgreSQL | 5432 | Banco de dados |
| Redis | 6379 | Cache |
| MinIO | 9000 | Storage S3 |

## Troubleshooting Rápido

| Problema | Solução |
|----------|---------|
| Build falha por memória | Adicionar `NODE_OPTIONS=--max-old-space-size=4096` |
| Erro de conexão DB | Verificar `DATABASE_URL` e status do PostgreSQL |
| Imagens não carregam | Verificar bucket MinIO e variáveis S3 |
| Login não funciona | Verificar `NEXTAUTH_URL` e `ENCRYPTION_SECRET` |
| Erro 502 Bad Gateway | Aguardar deploy completar ou verificar logs |

## Recursos Úteis

- **Documentação Typebot**: https://docs.typebot.io
- **Documentação Railway**: https://docs.railway.app
- **GitHub Typebot**: https://github.com/baptisteArno/typebot.io
- **Discord Typebot**: https://typebot.io/discord
- **Railway Dashboard**: https://railway.app/dashboard

## Configuração Mínima de Recursos

- **RAM**: 2GB (mínimo), 4GB (recomendado)
- **Disco**: 10GB (mínimo), 20GB (recomendado)
- **Banda**: 1Mbps (suficiente para teste)

## Plano Ilimitado

Ao configurar `DEFAULT_WORKSPACE_PLAN=UNLIMITED` e usar o `ADMIN_EMAIL`, você terá:

✅ Chatbots ilimitados
✅ Mensagens ilimitadas
✅ Respostas ilimitadas
✅ Sem limite de usuários
✅ Todas as integrações disponíveis
✅ API completa

## Próximos Passos Após Deploy

1. Criar primeiro bot no Builder
2. Testar bot no Viewer
3. Configurar domínio customizado
4. Configurar backups automáticos
5. Configurar monitoramento
6. Integrar com webhooks/APIs
7. Personalizar tema e branding

## Contato e Suporte

- **Issues**: https://github.com/baptisteArno/typebot.io/issues
- **Discord**: https://typebot.io/discord
- **Email**: Contate Baptiste Arno (criador)
- **Railway Support**: https://railway.app/support
