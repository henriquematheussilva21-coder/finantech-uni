# 🏦 FinanTech UNIPÊ (finantech-uni)

> Projeto prático desenvolvido para a disciplina de **Desenvolvimento Mobile** do curso de Ciência da Computação no Centro Universitário de João Pessoa (UNIPÊ).

O **FinanTech** é um aplicativo mobile focado no controle financeiro pessoal pessoal simplificado, pensado sob medida para ajudar estudantes universitários a gerenciarem suas receitas e despesas cotidianas sem complicações.

---

## 🎯 Objetivo do Projeto
O principal escopo deste projeto é consolidar os conhecimentos de criação de interfaces e fluxos navegáveis utilizando o ecossistema **Flutter**. O app foca na usabilidade inteligente e rápida para o cadastro e monitoramento de gastos diários.

## 📱 Funcionalidades Principais
* **Autenticação Prática:** Fluxo simulado de login e cadastro.
* **Visão Geral (Dashboard):** Visualização instantânea de Saldo, Receitas e Despesas.
* **Cadastro Dinâmico:** Formulário intuitivo para adição de novas transações com categorização.
* **Categorias Customizadas:** Divisão de gastos voltados à rotina estudantil (Transporte, Alimentação, Estudos).
* **Histórico de Movimentações:** Extrato completo em formato de lista corrida das finanças inseridas.

## 🛠️ Tecnologias e Ferramentas
* **Framework principal:** Flutter (v3.x)
* **Linguagem de programação:** Dart
* **Componentes Visuais:** Material Design Widgets
* **Gerenciamento de Estado:** Utilização de estados nativos (setState) apropriados para o escopo acadêmico.

---

## 📂 Estrutura de Pastas do Projeto (Escopo Sugerido)

```bash
lib/
 ├── main.dart             # Inicialização do App
 ├── screens/              # Telas da aplicação
 │    ├── login_screen.dart
 │    ├── home_screen.dart
 │    ├── transaction_form.dart
 │    └── history_screen.dart
 ├── widgets/              # Componentes visuais reaproveitáveis (Cards, Custom Inputs)
 └── models/               # Estruturas de dados (TransactionModel)
```

---

## 🚀 Como Executar o Projeto Localmente

1. **Pré-requisitos:** Certifique-se de ter o Flutter SDK instalado e configurado em sua máquina (`flutter doctor`).
2. **Clonar o Repositório:**
   ```bash
   git clone [https://github.com/henriquematheussilva21-coder/finantech-uni.git](https://github.com/henriquematheussilva21-coder/finantech-uni.git)
   ```
3. **Entrar na pasta do projeto:**
   ```bash
   cd finantech-uni
   ```
4. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```
5. **Executar o App:**
   ```bash
   flutter run
   ```

--- 

## 👥 Desenvolvedores (Grupo)
* **Matheus Henrique dos Santos Silva**
---
*Prof. Leandro Santana de Melo | CC UNIPÊ - 2026*[P5]
