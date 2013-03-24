class Centrodecusto < ActiveRecord::Base
  attr_accessible :descricao
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
  
  has_many :lancamento
  
  has_ancestry
end
