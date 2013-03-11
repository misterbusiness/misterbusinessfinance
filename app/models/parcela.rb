class Parcela < ActiveRecord::Base
  attr_accessible :num_parcelas
  
  has_many :parcela_lancamento, :dependent => :destroy
  has_many :lancamento, :through => :parcela_lancamento
end
