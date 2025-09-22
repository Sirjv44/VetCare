# Modelo para representar os registros médicos dos pets
# Contém validações e relacionamentos para histórico de saúde
require 'sequel/model'

class MedicalRecord < Sequel::Model
  # ==================== RELACIONAMENTOS ====================
  # Um registro médico pertence a um pet
  many_to_one :pet
  # Um registro médico pertence a um cliente através do pet
  many_to_one :client, through: :pet

  # ==================== VALIDAÇÕES ====================
  def validate
    super
    # Pet deve ser selecionado
    errors.add(:pet_id, 'deve ser selecionado') if pet_id.nil? || pet_id.zero?
    # Data do atendimento é obrigatória
    errors.add(:date, 'não pode estar em branco') if date.nil?
    # Diagnóstico é obrigatório
    errors.add(:diagnosis, 'não pode estar em branco') if diagnosis.nil? || diagnosis.empty?
  end

  # ==================== CALLBACKS ====================
  # Atualizar timestamp antes de salvar alterações
  def before_update
    self.updated_at = Time.now
    super
  end
end