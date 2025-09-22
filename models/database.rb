# Configuração e criação do banco de dados SQLite
# Este arquivo configura a conexão com o banco e cria as tabelas necessárias
require 'sequel'

# Configuração da conexão com o banco de dados SQLite
# O arquivo será criado automaticamente na primeira execução
DB = Sequel.sqlite('veterinary_clinic.db')

# ==================== CRIAÇÃO DAS TABELAS ====================

# Tabela de clientes (proprietários dos pets)
unless DB.table_exists?(:clients)
  DB.create_table :clients do
    primary_key :id                                              # ID único do cliente
    String :name, null: false                                    # Nome completo (obrigatório)
    String :email                                                # Email do cliente
    String :phone                                                # Telefone de contato
    String :address, text: true                                  # Endereço completo
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP     # Data de criação
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP     # Data da última atualização
  end
end

# Tabela de pets (animais dos clientes)
unless DB.table_exists?(:pets)
  DB.create_table :pets do
    primary_key :id                                              # ID único do pet
    foreign_key :client_id, :clients, null: false, on_delete: :cascade  # Referência ao cliente (obrigatório)
    String :name, null: false                                    # Nome do pet (obrigatório)
    String :species, null: false                                 # Espécie do animal (obrigatório)
    String :breed                                                # Raça do animal
    Integer :age                                                 # Idade em anos
    Float :weight                                                # Peso em quilogramas
    String :color                                                # Cor do animal
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP     # Data de criação
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP     # Data da última atualização
  end
end

# Tabela de consultas/agendamentos
unless DB.table_exists?(:appointments)
  DB.create_table :appointments do
    primary_key :id                                              # ID único da consulta
    foreign_key :pet_id, :pets, null: false, on_delete: :cascade    # Referência ao pet (obrigatório)
    DateTime :date_time, null: false                             # Data e hora da consulta (obrigatório)
    String :reason, null: false                                  # Motivo da consulta (obrigatório)
    String :notes, text: true                                    # Observações adicionais
    String :status, default: 'agendada'                          # Status: agendada, confirmada, concluída, cancelada
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP     # Data de criação
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP     # Data da última atualização
  end
end

# Tabela de registros médicos (histórico de saúde dos pets)
unless DB.table_exists?(:medical_records)
  DB.create_table :medical_records do
    primary_key :id                                              # ID único do registro
    foreign_key :pet_id, :pets, null: false, on_delete: :cascade    # Referência ao pet (obrigatório)
    Date :date, null: false                                      # Data do atendimento (obrigatório)
    String :diagnosis, text: true                                # Diagnóstico médico
    String :treatment, text: true                                # Tratamento realizado
    String :medications, text: true                              # Medicamentos prescritos
    String :notes, text: true                                    # Observações adicionais
    String :veterinarian                                         # Nome do veterinário responsável
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP     # Data de criação
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP     # Data da última atualização
  end
end