class Lancamento < ActiveRecord::Base
  attr_accessible :datavencimento, :descricao, :status, :tipo, :valor
      
#  validates :datavencimento, :presence => false
  validates :descricao, :presence => true
  validates :status, :presence => true
  validates :tipo, :presence => true
  validates :valor, :presence => true
  validates :datavencimento, :presence => true   
 
# 10-03-13 JH: Deprecated, alterado para gema simple_enum  
# 10-03-13 JH: Para queries a sintaxa é (nome_coluna)_cd => Lancamento.(nome_chave)
#  validates_inclusion_of :tipo, :in => ["Receita","Despesa"]
#  validates_inclusion_of :status, :in => ["Aberto","Quitado","Estornado","Cancelado"]
  
  # Engenharia detalhada: 3.1.1
  as_enum :tipo, [:receita, :despesa]
  as_enum :status, [:aberto, :quitado, :estornado, :cancelado]
    
# => Preparação para as validações    
  before_validation :set_default_status_if_not_specified
  before_validation :set_default_datavencimento_if_not_specified
  before_validation :set_tipo_depending_valor
  before_validation :set_default_valor_if_null
  before_validation :set_default_categoria_if_null
  
  before_validation :set_valor_two_decimal_places
  
  has_one :category
  
  
# => 05-03-13 JH: Teste de função para gerar erro
#  before_validation :set_default_datavencimento_if_not_specified

  private 

  def set_default_status_if_not_specified
    self.status = :aberto if self.status.blank?
  end
  # Engenharia detalhada: 3.1.2
  def set_default_datavencimento_if_not_specified
    self.datavencimento = Date.today if self.datavencimento.blank?
# => 05-03-13 JH: Teste de função para gerar erro
#     errors.add(:datavencimento, "Data nao pode ser vazia") if self.datavencimento.blank? 
  end
  
  # Engenharia detalhada: 3.1.4
  def set_tipo_depending_valor
    if self.valor? and self.valor < 0
      if self.tipo == :receita
        self.tipo = :despesa
        self.valor = self.valor * -1
      end
    end
  end
  
  def set_valor_two_decimal_places
     self.valor = self.valor.round(2)
  end
  
  def set_default_valor_if_null
    self.valor = 0 if self.valor.blank?
  end
  
  def set_default_categoria_if_null
    self.category = Category.find(1) if self.category.blank?
  end
end


#05-03-2013: Verificar como podemos usar enums no rails (evitar hard-code)
