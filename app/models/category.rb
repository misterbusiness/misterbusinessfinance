class Category < ActiveRecord::Base

  attr_accessible :descricao, :ancestry, :parent_id, :is_cash_flow
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
    
  has_many :lancamento
  has_many :lancamentorapido
  
  has_ancestry

  scope :cash_flow_flag, where(:is_cash_flow => true)
  scope :no_cash_flow_flag, where(:is_cash_flow => false)
end
