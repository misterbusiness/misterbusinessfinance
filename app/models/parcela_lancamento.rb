class ParcelaLancamento < ActiveRecord::Base
  attr_accessible :indice
    
  validates :parcela, :presence => true
  validates :lancamento, :presence => true
  
  belongs_to :lancamento
  belongs_to :parcela
end
