# Modelo para representar as consultas/agendamentos
# Contém validações, relacionamentos e métodos para status
require 'sequel/model'

class Appointment < Sequel::Model
  # ==================== RELACIONAMENTOS ====================
  # Uma consulta pertence a um pet
  many_to_one :pet
  # Uma consulta pertence a um cliente através do pet
  many_to_one :client, through: :pet

  # ==================== VALIDAÇÕES ====================
  def validate
    super
    # Pet deve ser selecionado
    errors.add(:pet_id, 'deve ser selecionado') if pet_id.nil? || pet_id.zero?
    # Data e hora são obrigatórias
    errors.add(:date_time, 'não pode estar em branco') if date_time.nil?
    # Motivo da consulta é obrigatório
    errors.add(:reason, 'não pode estar em branco') if reason.nil? || reason.empty?
    # Data não pode ser no passado (usando Time.now para compatibilidade)
    # Comentado para permitir edição de consultas antigas
    # errors.add(:date_time, 'não pode ser no passado') if date_time && date_time.to_time < Time.now
  end

  # ==================== CALLBACKS ====================
  # Atualizar timestamp antes de salvar alterações
  def before_update
    self.updated_at = Time.now
    super
  end

  # ==================== MÉTODOS AUXILIARES ====================
  # Retornar classe CSS apropriada para o badge de status
  def status_badge_class
    case status
    when 'agendada'
      'badge-primary'      # Azul para agendada
    when 'concluída'
      'badge-success'      # Verde para concluída
    when 'cancelada'
      'badge-danger'       # Vermelho para cancelada
    else
      'badge-secondary'    # Cinza para outros status
    end
  end
end