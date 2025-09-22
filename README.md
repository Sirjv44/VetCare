# VetCare - Sistema para Clínica Veterinária

Um sistema completo desenvolvido em Ruby com Sinatra para gerenciamento de clínicas veterinárias.

## 📋 Funcionalidades

- **Gestão de Clientes**: Cadastro completo dos proprietários dos animais
- **Registro de Pets**: Informações detalhadas dos animais (espécie, raça, idade, peso, etc.)
- **Agendamento de Consultas**: Sistema completo de marcação e controle de consultas
- **Histórico Médico**: Registro detalhado de diagnósticos, tratamentos e medicações
- **Dashboard**: Visão geral com estatísticas e consultas recentes
- **Interface Responsiva**: Design moderno e adaptável para diferentes dispositivos

## 🛠️ Tecnologias Utilizadas

- **Ruby** 3.0+
- **Sinatra** - Framework web minimalista
- **SQLite3** - Banco de dados
- **Sequel** - ORM para Ruby
- **Bootstrap 5** - Framework CSS
- **Font Awesome** - Ícones

## 📦 Pré-requisitos

Antes de começar, certifique-se de ter instalado em sua máquina:

### 1. Ruby
```bash
# Verificar se o Ruby está instalado
ruby --version

# Deve retornar algo como: ruby 3.0.0p0 (ou superior)
```

**Instalação do Ruby:**

**No Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ruby-full
```

**No macOS (com Homebrew):**
```bash
brew install ruby
```

**No Windows:**
- Baixe e instale o Ruby através do [RubyInstaller](https://rubyinstaller.org/)

### 2. Bundler
```bash
# Instalar o Bundler (gerenciador de gems)
gem install bundler
```

### 3. SQLite3
```bash
# Ubuntu/Debian
sudo apt install sqlite3 libsqlite3-dev

# macOS
brew install sqlite3

# Windows - geralmente já vem com o Ruby
```

## 🚀 Instalação e Configuração

### 1. Clone ou baixe o projeto
```bash
# Se usando Git
git clone <url-do-repositorio>
cd veterinary-clinic

# Ou extraia os arquivos do projeto para uma pasta
```

### 2. Instale as dependências
```bash
# Instalar todas as gems necessárias
bundle install
```

### 3. Configuração do banco de dados
O banco de dados SQLite será criado automaticamente na primeira execução. As tabelas são criadas automaticamente pelo arquivo `models/database.rb`.

## ▶️ Executando o Sistema

### Modo de Desenvolvimento
```bash
# Executar com recarga automática (recomendado para desenvolvimento)
bundle exec rerun rackup config.ru

# Ou simplesmente
rerun rackup
```

### Modo de Produção
```bash
# Executar normalmente
bundle exec rackup config.ru

# Ou
rackup
```

O sistema estará disponível em: **http://localhost:9292**

## 📁 Estrutura do Projeto

```
veterinary-clinic/
├── app.rb                 # Aplicação principal Sinatra
├── config.ru             # Configuração Rack
├── Gemfile               # Dependências Ruby
├── veterinary_clinic.db # Banco de dados SQLite (criado automaticamente)
├── models/               # Modelos de dados
│   ├── database.rb       # Configuração do banco
│   ├── client.rb         # Modelo Cliente
│   ├── pet.rb           # Modelo Pet
│   ├── appointment.rb    # Modelo Consulta
│   └── medical_record.rb # Modelo Histórico Médico
├── views/                # Templates ERB
│   ├── layout.erb        # Layout principal
│   ├── dashboard.erb     # Página inicial
│   ├── clients/          # Views de clientes
│   ├── pets/            # Views de pets
│   ├── appointments/     # Views de consultas
│   └── medical_records/  # Views de histórico médico
└── public/               # Arquivos estáticos
    └── styles.css        # Estilos customizados
```

## 🎯 Como Usar o Sistema

### 1. Acesse o Dashboard
- Abra http://localhost:9292 no seu navegador
- Você verá estatísticas gerais e consultas recentes

### 2. Cadastre Clientes
- Clique em "Clientes" no menu lateral
- Use o botão "Novo Cliente" para adicionar proprietários

### 3. Registre Pets
- Acesse "Pets" no menu
- Cadastre os animais vinculando-os aos clientes

### 4. Agende Consultas
- Vá em "Consultas" e clique em "Nova Consulta"
- Selecione o pet, data, horário e motivo

### 5. Mantenha Histórico Médico
- Em "Histórico Médico", registre diagnósticos e tratamentos
- Vincule cada registro ao pet correspondente

## 🔧 Comandos Úteis

```bash
# Verificar gems instaladas
bundle list

# Atualizar gems
bundle update

# Verificar sintaxe Ruby
ruby -c app.rb

# Acessar console do banco (SQLite)
sqlite3 veterinary_clinic.db

# Ver logs em tempo real (se usando rerun)
# Os logs aparecerão automaticamente no terminal
```

## 📊 Banco de Dados

O sistema usa SQLite3 com as seguintes tabelas:

- **clients**: Informações dos proprietários
- **pets**: Dados dos animais
- **appointments**: Consultas agendadas
- **medical_records**: Histórico médico

### Comandos SQLite Úteis
```sql
-- Conectar ao banco
sqlite3 veterinary_clinic.db

-- Ver todas as tabelas
.tables

-- Ver estrutura de uma tabela
.schema clients

-- Consultar dados
SELECT * FROM clients;

-- Sair
.quit
```

## 🛡️ Segurança

- Validações implementadas nos modelos
- Sanitização de dados de entrada
- Relacionamentos com integridade referencial
- Prevenção contra SQL injection (via Sequel ORM)

## 🐛 Solução de Problemas

### Erro: "gem not found"
```bash
bundle install
```

### Erro: "database locked"
```bash
# Pare o servidor e reinicie
# Ctrl+C para parar
# Execute novamente: rerun rackup
```

### Erro: "port already in use"
```bash
# Use uma porta diferente
rackup -p 3000
```

### Erro de permissão no SQLite
```bash
# Verifique permissões da pasta
chmod 755 .
chmod 644 veterinary_clinic.db
```

## 📝 Desenvolvimento

### Adicionando novas funcionalidades:

1. **Novos modelos**: Crie em `models/`
2. **Novas rotas**: Adicione em `app.rb`
3. **Novas views**: Crie em `views/`
4. **Estilos**: Modifique `public/styles.css`

### Estrutura de uma nova funcionalidade:
```ruby
# Em app.rb
get '/nova_funcionalidade' do
  erb :nova_view
end

# Criar views/nova_view.erb
# Adicionar link no layout.erb
```

## 📞 Suporte

Para dúvidas ou problemas:

1. Verifique se todas as dependências estão instaladas
2. Confirme que o Ruby 3.0+ está sendo usado
3. Verifique se a porta 9292 está disponível
4. Consulte os logs no terminal para erros específicos

## 📄 Licença

Este projeto é de uso livre para fins educacionais e comerciais.

---

**Desenvolvido para facilitar a gestão de clínicas veterinárias**