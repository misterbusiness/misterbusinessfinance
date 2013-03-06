class Category < ActiveRecord::Base
  attr_accessible :description
  
  
  belongs_to :lancamento
  
  has_ancestry
end
