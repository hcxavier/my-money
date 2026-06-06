# My Money - Gestão Financeira Pessoal

O **My Money** é uma solução completa para controle de finanças pessoais, composta por uma API robusta desenvolvida em Django e um aplicativo móvel intuitivo desenvolvido em Flutter. O projeto permite que usuários registrem suas receitas e despesas, visualizem métricas de saldo e gerenciem seu perfil de forma segura.

Video Apresentando o Projeto: https://youtu.be/BOz_ZEra7Is

## 🚀 Funcionalidades Principais

- **Autenticação Segura:** Registro e login de usuários com suporte a OAuth2.
- **Gestão de Transações:** Cadastro, edição, exclusão e listagem de receitas (Entradas) e despesas (Saídas).
- **Categorização:** Organização de movimentações por categorias (Alimentação, Transporte, Saúde, etc.).
- **Dashboard Financeiro:** Visualização de saldo total, total de entradas e total de saídas com datas das últimas movimentações.
- **Filtros Avançados:** Busca e filtragem de transações por data, tipo e categoria.
- **Perfil do Usuário:** Personalização de perfil com upload de foto (Avatar).

---

## 🛠️ Tecnologias Utilizadas

### Backend (API)
- **Linguagem:** Python 3.x
- **Framework:** [Django 5.0+](https://www.djangoproject.com/)
- **API Toolkit:** [Django REST Framework](https://www.django-rest-framework.org/)
- **Autenticação:** [Django OAuth Toolkit](https://django-oauth-toolkit.readthedocs.io/) & PyJWT
- **Banco de Dados:** SQLite (Desenvolvimento)

### Frontend (App Móvel)
- **Framework:** [Flutter](https://flutter.dev/)
- **Linguagem:** Dart
- **Cliente HTTP:** [Dio](https://pub.dev/packages/dio)
- **Armazenamento Seguro:** [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- **Autenticação:** [Flutter AppAuth](https://pub.dev/packages/flutter_appauth)

### Frontend (Web)
- **Framework:** [React](https://react.dev/)
- **Build Tool:** [Vite](https://vitejs.dev/)
- **Styling:** [Tailwind CSS](https://tailwindcss.com/)

---

## 🏗️ Como Executar o Projeto

### 1. Configuração do Backend (API)

Navegue até a pasta `api/`:
```bash
cd api
```

#### Passo a passo:
1.  **Crie um ambiente virtual:**
    ```bash
    python -m venv venv
    ```
2.  **Ative o ambiente virtual:**
    - No Linux/macOS: `source venv/bin/activate`
    - No Windows: `venv\Scripts\activate`
3.  **Instale as dependências:**
    ```bash
    pip install -r requirements.txt
    ```
4.  **Gere a chave RSA para o OIDC:**
    ```bash
    openssl genrsa -out oidc_rsa.key 2048
    ```
5.  **Configure as variáveis de ambiente:**
    Crie um arquivo `.env` na raiz da pasta `api/` com base no seguinte modelo:
    ```env
    DJANGO_DEBUG=True
    DJANGO_SECRET_KEY=sua_chave_secreta_aqui
    DJANGO_ALLOWED_HOSTS=*
    DATABASE_URL=sqlite:///db.sqlite3
    ```
6.  **Execute as migrações e inicie o servidor:**
    Você pode usar o script facilitador:
    ```bash
    chmod +x run_server.sh
    ./run_server.sh
    ```
    Ou manualmente:
    ```bash
    python manage.py migrate
    python manage.py runserver 0.0.0.0:8000
    ```
7.  **Crie um superusuário (admin):**
    Preencha os dados de acordo com sua preferência:
    ```bash
    python manage.py createsuperuser
    ```
8.  **Configure a aplicação OAuth2:**
    Abra no navegador o admin do Django em `http://localhost:8000/admin/` e crie uma nova aplicação em "Django OAuth Toolkit" > "Applications" com as seguintes configurações:
    - **Client ID:** Mantenha o gerado e copie-o para o `.env` dos clientes (Mobile e Web).
    - **Redirect URIs:** Insira `com.example.mymoney://callback` (para Mobile).
    - **Post Logout Redirect URIs:** Insira `com.example.mymoney://callback`.
    - **Client Type:** Marque `Public`.
    - **Authorization Grant Type:** Marque `Authorization code`.
    - **Name:** Insira um nome de sua preferência (ex: My Money App).
    - **Skip Authorization:** Marque esta opção.
    - **Algorithm:** Marque `RSA with SHA-2 256`.

---

### 2. Configuração do Frontend (App Móvel)

Navegue até a pasta `client/`:
```bash
cd client
```

#### Passo a passo:
1.  **Instale as dependências do Flutter:**
    ```bash
    flutter pub get
    ```
2.  **Configure as variáveis de ambiente:**
    Crie um arquivo `.env` na raiz da pasta `client/` com as seguintes chaves:
    ```env
    API_URL=http://seu_ip:8000
    CLIENT_ID=seu_client_id_do_oauth2
    ```
3.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```
**Obs:** É necessário que o computador que esteja executando o servidor Django e o celular com o aplicativo Flutter estejam na mesma rede local.

## 🧪 Testes

### Executando testes da API:
```bash
cd api
./run_tests.sh
```

---

## 📂 Estrutura do Repositório

- `/api`: Código fonte do servidor Django (Backend).
- `/client`: Código fonte do aplicativo Flutter (Frontend Mobile).
- `/frontend`: Código fonte da aplicação React (Frontend Web).
