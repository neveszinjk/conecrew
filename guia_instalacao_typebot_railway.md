
# Guia Completo: Como Instalar o Typebot com Plano Ilimitado no Railway

**Autor**: Manus AI
**Data**: 19 de Dezembro de 2025

## Introdução

Este documento oferece um guia detalhado para instalar e hospedar uma instância própria e ilimitada do **Typebot** na plataforma **Railway**. Ao seguir estes passos, você terá total controle sobre sua aplicação de chatbot, desde a gestão da infraestrutura até a personalização completa, contornando as limitações de planos comerciais e garantindo a soberania dos seus dados.

O Typebot é uma poderosa ferramenta de construção de chatbots *fair source* [1], que permite a criação de experiências conversacionais avançadas de forma visual e intuitiva. Hospedá-lo no Railway, uma plataforma de infraestrutura como serviço (IaaS) moderna, simplifica o processo de deploy e escalabilidade.

## Pré-requisitos

Antes de iniciar, certifique-se de que possui os seguintes pré-requisitos:

- **Conta no GitHub**: Essencial para clonar ou fazer fork do repositório do Typebot.
- **Conta no Railway**: Necessária para provisionar a infraestrutura e realizar o deploy. Um plano gratuito é suficiente para começar.
- **Conhecimento Básico**: Familiaridade com `git`, variáveis de ambiente e o funcionamento de um `Dockerfile` é recomendada.

## Passo 1: Preparar o Código-Fonte

Para começar, você precisa de uma cópia do código-fonte do Typebot. Recomendamos fazer um *fork* do repositório oficial para ter sua própria versão e poder fazer alterações futuras.

1.  **Faça o Fork**: Acesse o repositório oficial [https://github.com/baptisteArno/typebot.io](https://github.com/baptisteArno/typebot.io) e clique no botão "Fork" no canto superior direito.

2.  **Clone seu Fork**: Após criar o fork, clone o repositório para sua máquina local (ou use o ambiente do Railway diretamente):

    ```bash
    git clone https://github.com/SEU-USUARIO/typebot.io.git
    cd typebot.io
    ```

    Substitua `SEU-USUARIO` pelo seu nome de usuário do GitHub.

## Passo 2: Configurar o Projeto no Railway

O Railway simplifica a criação de toda a infraestrutura necessária. O Typebot depende de um banco de dados, um serviço de cache e um storage de objetos.

### 2.1. Criar um Novo Projeto

1.  Acesse seu dashboard no Railway e clique em **New Project**.
2.  Selecione **Deploy from GitHub repo** e escolha o fork do `typebot.io` que você acabou de criar.

### 2.2. Adicionar Serviços de Dependência

Dentro do seu novo projeto, adicione os seguintes serviços clicando em **+ New**:

#### A. Banco de Dados (PostgreSQL)

-   Selecione **Database** > **Add PostgreSQL**.
-   Este serviço irá provisionar um banco de dados PostgreSQL e expor a variável `DATABASE_URL` automaticamente para os outros serviços do projeto.

#### B. Cache (Redis)

-   Selecione **Database** > **Add Redis**.
-   Este serviço irá provisionar um servidor Redis e expor a variável `REDIS_URL`.

#### C. Storage de Objetos (MinIO)

Para armazenar mídias como imagens e vídeos, usaremos o MinIO, um storage compatível com a API S3.

1.  Selecione **Empty Service**.
2.  Nas configurações do serviço, vá para a aba **Settings** e em **Service**, configure o **Docker Image** para `minio/minio:latest`.
3.  Na aba **Variables**, adicione as seguintes variáveis de ambiente para configurar o MinIO:

| Variável | Valor | Descrição |
| :--- | :--- | :--- |
| `MINIO_ROOT_USER` | `minioadmin` | Usuário root do MinIO. |
| `MINIO_ROOT_PASSWORD` | `minioadmin123` | Senha do usuário root. **Use uma senha forte em produção.** |

4.  Na aba **Settings**, em **Networking**, configure o **Port** para `9000` e gere um domínio público para o serviço.

## Passo 3: Configurar e Fazer o Deploy dos Serviços do Typebot

O Typebot é composto por duas aplicações principais: o **Builder** (para criar os bots) e o **Viewer** (para os usuários interagirem com os bots). Ambos precisam ser configurados como serviços separados no Railway.

### 3.1. Configurar o `typebot-builder`

1.  No seu projeto Railway, clique em **+ New** e selecione o repositório `typebot.io` novamente.
2.  Renomeie este serviço para `typebot-builder`.
3.  Na aba **Settings** do serviço, configure os comandos de build e start:
    -   **Build Command**: `bun install && bunx turbo build --filter=builder...`
    -   **Start Command**: `cd apps/builder && bun start`

4.  Na aba **Variables**, adicione as seguintes variáveis de ambiente:

| Variável | Valor | Descrição |
| :--- | :--- | :--- |
| `DATABASE_URL` | `${Postgres.DATABASE_URL}` | Referência automática ao serviço PostgreSQL. |
| `REDIS_URL` | `${Redis.REDIS_URL}` | Referência automática ao serviço Redis. |
| `ENCRYPTION_SECRET` | *Gerar valor aleatório* | Chave de 32 bytes para criptografia. Use `openssl rand -base64 32` para gerar. |
| `NEXTAUTH_URL` | *URL do builder* | URL pública do serviço `typebot-builder` gerada pelo Railway. |
| `NEXT_PUBLIC_VIEWER_URL` | *URL do viewer* | URL pública do serviço `typebot-viewer` (que será criado a seguir). |
| `ADMIN_EMAIL` | `seu-email@dominio.com` | Email do administrador que terá acesso ao plano **UNLIMITED**. |
| `DEFAULT_WORKSPACE_PLAN` | `UNLIMITED` | Define o plano padrão para novos usuários como ilimitado. |
| `S3_ENDPOINT` | *URL do MinIO* | URL pública do serviço MinIO. |
| `S3_ACCESS_KEY_ID` | `minioadmin` | Usuário do MinIO. |
| `S3_SECRET_ACCESS_KEY` | `minioadmin123` | Senha do MinIO. |
| `S3_BUCKET_NAME` | `typebot` | Nome do bucket que será usado. |

### 3.2. Configurar o `typebot-viewer`

1.  Repita o processo: clique em **+ New** e selecione o repositório `typebot.io`.
2.  Renomeie este serviço para `typebot-viewer`.
3.  Configure os comandos de build e start:
    -   **Build Command**: `bun install && bunx turbo build --filter=viewer...`
    -   **Start Command**: `cd apps/viewer && bun start`

4.  Na aba **Variables**, adicione as **mesmas variáveis** que você configurou para o `typebot-builder`. O Railway permite compartilhar variáveis entre serviços, mas é crucial garantir que ambos tenham acesso a todas as configurações necessárias.

## Passo 4: Executar as Migrações do Banco de Dados

Com os serviços configurados, o banco de dados precisa ser preparado. O Typebot usa o Prisma para gerenciar o schema do banco.

1.  No seu projeto Railway, vá para o serviço `typebot-builder`.
2.  Na aba **Settings**, role para baixo até a seção **Danger Zone** e clique em **Connect to a Shell**.
3.  No terminal que abrir, execute o comando para aplicar as migrações:

    ```bash
    bunx turbo db:migrate
    ```

## Passo 5: Configurar o Bucket no MinIO

O serviço MinIO precisa de um *bucket* chamado `typebot` para que o Typebot possa salvar os arquivos.

1.  Acesse a URL pública do seu serviço MinIO.
2.  Faça login com o usuário (`minioadmin`) и a senha (`minioadmin123`) que você configurou.
3.  No menu lateral, clique em **Buckets** e depois em **Create Bucket**.
4.  Dê o nome de `typebot` ao bucket e salve.
5.  Clique no bucket recém-criado, vá para a aba **Access Policy** e defina a política como **Public**.

## Passo 6: Acessar sua Instância

Após o deploy ser concluído com sucesso, você pode acessar sua instância do Typebot:

-   **Builder**: Acesse a URL do serviço `typebot-builder`.
-   **Viewer**: A URL do `typebot-viewer` será usada para incorporar os chatbots em seus sites.

Faça login com o email que você definiu como `ADMIN_EMAIL` para começar a criar seus chatbots com acesso a todos os recursos ilimitados.

## Troubleshooting

-   **Erro de Memória no Build**: Se o build falhar por falta de memória, adicione a variável `NODE_OPTIONS` com o valor `--max-old-space-size=4096` nas configurações de build dos serviços `builder` e `viewer`.
-   **Falha na Conexão com o Banco**: Verifique se a variável `DATABASE_URL` está corretamente referenciada e se o serviço PostgreSQL está rodando.
-   **Imagens não Carregam**: Certifique-se de que o bucket no MinIO foi criado, está com a política de acesso pública e que as variáveis `S3_*` estão corretas em ambos os serviços do Typebot.

## Referências

[1] Typebot. (2025). *Typebot Official Documentation*. Acessado em 19 de dezembro de 2025, de [https://docs.typebot.io](https://docs.typebot.io)

[2] Railway. (2025). *Railway Documentation*. Acessado em 19 de dezembro de 2025, de [https://docs.railway.app](https://docs.railway.app)

[3] GitHub - baptisteArno/typebot.io. (2025). *Typebot Source Code*. Acessado em 19 de dezembro de 2025, de [https://github.com/baptisteArno/typebot.io](https://github.com/baptisteArno/typebot.io)
