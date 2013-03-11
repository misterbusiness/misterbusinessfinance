class Lancamento < ActiveRecord::Base
  attr_accessible :datavencimento, :descricao, :status, :tipo, :valor
      
#  validates :datavencimento, :presence => false
  validates :descricao, :presence => true
  validates :status, :presence => true
  validates :tipo, :presence => true
  validates :valor, :presence => true
  
  validates_inclusion_of :tipo, :in => ["Receita","Despesa"]
  validates_inclusion_of :status, :in => ["Aberto","Quitado","Estornado","Cancelado"]
    
# => Preparação para as validações    
  before_validation :set_default_status_if_not_specified
  before_validation :set_default_datavencimento_if_not_specified
  before_validation :set_tipo_depending_valor
  before_validation :set_default_valor_if_null
  before_validation :set_default_categoria_if_null
  
  has_one :category
  has_one :costcenter
  
# => 05-03-13 JH: Teste de função para gerar erro
#  before_validation :set_default_datavencimento_if_not_specified

  private 

  def set_default_status_if_not_specified
    self.status = 'Aberto' if self.status.blank?
  end
  
  def set_default_datavencimento_if_not_specified
    self.datavencimento = Date.today if self.datavencimento.blank?
# => 05-03-13 JH: Teste de função para gerar erro
#     errors.add(:datavencimento, "Data nao pode ser vazia") if self.datavencimento.blank? 
  end
  
  def set_tipo_depending_valor
    if self.valor? and self.valor < 0
      if self.tipo == "Receita"
        self.tipo = "Despesa"
        self.valor = self.valor * -1
      end
    end
  end
  
  def set_default_valor_if_null
    self.valor = 0 if self.valor.blank?
  end
  
  def set_default_categoria_if_null
    self.category = Category.find(1) if self.category.blank?
  end
end


#05-03-2013: Verificar como podemos usar enums no rails (evitar hard-code)
