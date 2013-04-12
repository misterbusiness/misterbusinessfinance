class Agendamento < ActiveRecord::Base
  attr_accessible :num_agendamentos

  validates :num_agendamentos, :presence => true

  has_many :lancamento, :dependent => :destroy
end
