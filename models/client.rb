# Modelo para representar os clientes (proprietários dos pets)
# Contém validações e relacionamentos com outras entidades
require 'sequel/model'

class Client < Sequel::Model
  # ==================== RELACIONAMENTOS ====================
  # Um cliente pode ter vários pets
  one_to_many :pets
  # Um cliente pode ter várias consultas através dos seus pets
  one_to_many :appointments, through: :pets
  # Um cliente pode ter vários registros médicos através dos seus pets
  one_to_many :medical_records, through: :pets

  # ==================== VALIDAÇÕES ====================
  def validate
    super
    # Nome é obrigatório
    errors.add(:name, 'não pode estar em branco') if name.nil? || name.empty?
    # Email deve ter formato válido se fornecido
    errors.add(:email, 'formato inválido') if email && !email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end

  # ==================== CALLBACKS ====================
  # Atualizar timestamp antes de salvar alterações
  def before_update
    self.updated_at = Time.now
    super
  end
end