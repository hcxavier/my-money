# My Money - Gestão Financeira Pessoal

O **My Money** é uma solução completa para controle de finanças pessoais, composta por uma API robusta desenvolvida em Django e um aplicativo móvel intuitivo desenvolvido em Flutter. O projeto permite que usuários registrem suas receitas e despesas, visualizem métricas de saldo e gerenciem seu perfil de forma segura.

## 🚀 Funcionalidades Principais

- **Autenticação Segura:** Registro e login de usuários com suporte a OAuth2 e JWT.
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
7. Crie um super usuário (admin) e preencha os dados de acordo com sua preferência

    ```
    python manage.py createsuperuser
    ```
    
8. Abra a no navedador o admin do django `http://localhost:8000/admin/` e crie uma application com as seguintes configurações: 
    - Mantenha o Client id e copie-o para o `.env` do client.
    - No campo Redirect uris insira: `com.example.mymoney://callback`.
    - No campo Client type marque: `public`.
    - No campo Authorization grant type marque: `Authorization code`.
    - No campo Name insira qualquer nome.
    - No campo Algorithm marque: `RSA with SHA-2 256`. 
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

---

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
- `/frontend`: Projeto Web alternativo em React/Vite (Opcional).
