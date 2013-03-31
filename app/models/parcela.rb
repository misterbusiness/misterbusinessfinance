class Parcela < ActiveRecord::Base
  attr_accessible :num_parcelas
  
  validates :num_parcelas, :presence => true
  
#  has_many :parcela_lancamento, :dependent => :destroy
  has_many :lancamento, :dependent => :destroy
end
