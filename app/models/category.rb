class Category < ActiveRecord::Base
  attr_accessible :descricao
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
    
  belongs_to :lancamento
  
  has_ancestry
end
