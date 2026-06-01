# My Money - Documentação do Aplicativo

## 1. Proposta do Aplicativo
O **My Money** é um aplicativo de gestão financeira pessoal desenvolvido em Flutter. O objetivo principal da ferramenta é ajudar os usuários a organizarem suas finanças diárias de forma simples e intuitiva. Através dele, é possível registrar receitas e despesas, acompanhar saldos através de um painel de resumo e filtrar movimentações para ter um melhor controle sobre o fluxo de caixa.

O aplicativo conta com sistema de autenticação, mantendo os dados de cada usuário seguros e privados, além de permitir personalização do perfil de usuário.

---

## 2. Principais Funcionalidades

O aplicativo está estruturado com as seguintes funcionalidades principais:

### 🔐 Autenticação e Segurança
- **Login e Cadastro (Registro):** Criação de conta e acesso seguro via credenciais.
- **Gerenciamento de Sessão:** Controle de acesso mantendo o usuário logado de forma segura (utilizando `flutter_secure_storage`).
- **Logout:** Encerramento seguro da sessão do usuário.

### 👤 Perfil do Usuário
- **Visualização e Edição de Perfil:** Área dedicada para visualização das informações do usuário.
- **Avatar do Usuário:** Suporte a exibição e atualização de foto de perfil (via `image_picker`).

### 💰 Gestão de Transações
- **Criação de Transações:** Formulário para adicionar novas entradas (receitas) ou saídas (despesas), permitindo categorização.
- **Listagem de Transações:** Histórico de todas as movimentações financeiras apresentadas em forma de lista ou cards detalhados.
- **Filtros de Transações:** Modalidade de busca avançada para filtrar transações por data, categoria ou tipo.
- **Exclusão:** Confirmação e remoção de transações lançadas equivocadamente.

### 📊 Dashboard e Resumo
- **Cards de Resumo (Summary Cards):** Painel exibindo totais de Receitas, Despesas e o Saldo atual, atualizado dinamicamente conforme as movimentações.

---

## 3. Tecnologias e Pacotes Utilizados (Front-end)
O projeto foi desenvolvido em Dart/Flutter e utiliza as seguintes bibliotecas principais (conforme `pubspec.yaml`):
- **Dio:** Para requisições HTTP e consumo de API.
- **Flutter Secure Storage:** Para armazenamento seguro de tokens de autenticação localmente.
- **Intl:** Para internacionalização e formatação de datas e moedas.
- **Image Picker:** Para seleção de imagens e foto de perfil.
- **Top Snackbar Flutter:** Para exibição de notificações e feedbacks visuais ao usuário (alertas de sucesso/erro).
- **Flutter SVG:** Para renderização de elementos vetoriais (ícones e logotipos).

---

## 4. Documentação da API

*(Descreva abaixo os endpoints, métodos, headers esperados, payloads de requisição e respostas para cada rota da API utilizada pelo aplicativo)*

### Base URL:
`[COLOQUE AQUI A URL BASE DA API]`

### Endpoints:

#### Auth
- **Login**
  - **Método:** `POST`
  - **Rota:** `/auth/login`
  - **Descrição:** [Descrição do endpoint]
  - **Body:**
    ```json
    {
      "email": "",
      "password": ""
    }
    ```
  - **Response:**
    ```json
    {}
    ```

- **Registro**
  - **Método:** `POST`
  - **Rota:** `/auth/register`
  - **Descrição:** [Descrição do endpoint]
  - **Body:**
    ```json
    {}
    ```
  - **Response:**
    ```json
    {}
    ```

#### User
- **Perfil do Usuário**
  - **Método:** `GET`
  - **Rota:** `/user/profile`
  - **Descrição:** [Descrição do endpoint]
  - **Headers:** `Authorization: Bearer <token>`
  - **Response:**
    ```json
    {}
    ```

#### Transactions
- **Listar Transações**
  - **Método:** `GET`
  - **Rota:** `/transactions`
  - **Descrição:** [Descrição do endpoint]
  - **Headers:** `Authorization: Bearer <token>`
  - **Query Params:** `?filter=...`
  - **Response:**
    ```json
    {}
    ```

- **Criar Transação**
  - **Método:** `POST`
  - **Rota:** `/transactions`
  - **Descrição:** [Descrição do endpoint]
  - **Headers:** `Authorization: Bearer <token>`
  - **Body:**
    ```json
    {}
    ```
  - **Response:**
    ```json
    {}
    ```

- **Excluir Transação**
  - **Método:** `DELETE`
  - **Rota:** `/transactions/:id`
  - **Descrição:** [Descrição do endpoint]
  - **Headers:** `Authorization: Bearer <token>`
  - **Response:**
    ```json
    {}
    ```

*(Preencha os campos acima com os detalhes reais da API desenvolvida/utilizada para o back-end)*
