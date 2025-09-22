# Gemfile para Sistema de Clínica Veterinária
# Compatível com Ruby 3.2.9
source 'https://rubygems.org'

# Especifica a versão exata do Ruby
ruby '3.2.9'

# ==================== GEMS PRINCIPAIS ====================

# Framework web minimalista e rápido
gem 'sinatra', '~> 3.0.0'

# Banco de dados SQLite3 - versão compatível com Ruby 3.2.9
gem 'sqlite3', '~> 1.7.0'

# ORM (Object-Relational Mapping) para Ruby
gem 'sequel', '~> 5.75.0'

# Criptografia para senhas (se necessário no futuro)
gem 'bcrypt', '~> 3.1.20'

# Flash messages para feedback do usuário
gem 'rack-flash3', '~> 1.0.0'

# Extensões úteis para Sinatra (reloader, etc.)
# gem 'sinatra-contrib', '~> 3.0.0\'  # Removido devido a conflitos

# Servidor web Puma (mais moderno que WEBrick)
gem 'puma', '~> 6.4.0'

# Rack para middleware
gem 'rack', '~> 2.2.0'

# ==================== GEMS DE DESENVOLVIMENTO ====================
group :development do
  # Reinicia automaticamente a aplicação quando arquivos mudam
  gem 'rerun', '~> 0.14.0'
  
  # Debugging avançado
  gem 'pry', '~> 0.14.0'
  
  # Linter para código Ruby
  gem 'rubocop', '~> 1.57.0'
end

# ==================== GEMS DE TESTE (OPCIONAL) ====================
group :test do
  # Framework de testes
  gem 'rspec', '~> 3.12.0'
  
  # Testes de integração para aplicações Rack
  gem 'rack-test', '~> 2.1.0'
end

# ==================== GEMS DE PRODUÇÃO ====================
group :production do
  # Para deploy em produção (se necessário)
  gem 'thin', '~> 1.8.0'
end