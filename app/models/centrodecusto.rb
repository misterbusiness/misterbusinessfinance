class Centrodecusto < ActiveRecord::Base
  attr_accessible :descricao
  
  belongs_to :lancamento
  
  has_ancestry
end
