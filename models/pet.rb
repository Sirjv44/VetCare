# Modelo para representar os pets (animais da clínica)
# Contém validações, relacionamentos e métodos auxiliares
require 'sequel/model'

class Pet < Sequel::Model
  # ==================== RELACIONAMENTOS ====================
  # Um pet pertence a um cliente
  many_to_one :client
  # Um pet pode ter várias consultas
  one_to_many :appointments
  # Um pet pode ter vários registros médicos
  one_to_many :medical_records

  # ==================== VALIDAÇÕES ====================
  def validate
    super
    # Nome é obrigatório
    errors.add(:name, 'não pode estar em branco') if name.nil? || name.empty?
    # Espécie é obrigatória
    errors.add(:species, 'não pode estar em branco') if species.nil? || species.empty?
    # Cliente deve ser selecionado
    errors.add(:client_id, 'deve ser selecionado') if client_id.nil? || client_id.zero?
    # Idade deve ser positiva se fornecida
    errors.add(:age, 'deve ser um número positivo') if age && age < 0
    # Peso deve ser positivo se fornecido
    errors.add(:weight, 'deve ser um número positivo') if weight && weight <= 0
  end

  # ==================== CALLBACKS ====================
  # Atualizar timestamp antes de salvar alterações
  def before_update
    self.updated_at = Time.now
    super
  end

  # ==================== MÉTODOS AUXILIARES ====================
  # Formatar idade para exibição amigável
  def age_display
    return 'N/A' unless age
    case age
    when 0
      'Filhote'
    when 1
      '1 ano'
    else
      "#{age} anos"
    end
  end
end