class Category < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :description

  belongs_to :lancamento  
=======
  attr_accessible :descricao
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
    
  belongs_to :lancamento
  
>>>>>>> eae583c9d8439f647460bbbf436ac2f25711c320
  has_ancestry
end
