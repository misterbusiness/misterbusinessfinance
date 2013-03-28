class Lancamentorapido < ActiveRecord::Base
    attr_accessible :diavencimento, :descricao, :tipo, :valor, :category, :centrodecusto, :category_id, :centrodecusto_id
     
  as_enum :tipo, [:receita, :despesa]  
    
  belongs_to :category
  belongs_to :centrodecusto   
  
    
# => Preparação para as validações        
  before_validation :set_default_valor_if_null
  before_validation :set_tipo_depending_valor
  before_validation :set_default_categoria_if_null
  before_validation :set_default_centrodecusto_if_null
  
  before_validation :set_valor_two_decimal_places
            
  validates :descricao, :presence => true  
  validates :tipo, :presence => true
  validates :valor, :presence => true
  validates :diavencimento, :presence => true   
  validates :centrodecusto, :presence=> true
  validates :category, :presence => true   
  
  validates_uniqueness_of :descricao
  
  validates_format_of :valor, :with => /^\d+\.*\d{0,2}$/
  validates :descricao, length: { maximum: 255 } 
  
  validates_as_enum :tipo    
  
  private 
    
  def set_tipo_depending_valor
    if self.valor? and self.valor < 0      
        self.tipo = :despesa
        self.valor = self.valor * -1      
    end
  end
  
  def set_default_categoria_if_null
    self.category = Category.find_by_descricao(Configurable.categoria_padrao) if self.category.blank?
  end
  
  def set_default_centrodecusto_if_null
    self.centrodecusto = Centrodecusto.find_by_descricao(Configurable.centrodecusto_padrao) if self.centrodecusto.blank?
  end
  
    def set_default_valor_if_null
    self.valor = 0 if self.valor.blank?
  end
  
  
    def set_valor_two_decimal_places
     self.valor = self.valor.round(2)
    end
end
