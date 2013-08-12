class Centrodecusto < ActiveRecord::Base
  attr_accessible :descricao, :ancestry, :parent_id, :is_cash_flow
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
  
  has_many :lancamento
  has_many :lancamentorapido
  
  has_ancestry
end
