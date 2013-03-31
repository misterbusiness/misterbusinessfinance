class Lancamento < ActiveRecord::Base
  attr_accessible :datavencimento, :descricao, :status, :tipo, :valor, :dataacao, :category, :centrodecusto, :category_id, :centrodecusto_id, :lancamento_estornado, :lancamento_original
 
# 10-03-13 JH: Deprecated, alterado para gema simple_enum  
# 10-03-13 JH: Para queries a sintaxa é (nome_coluna)_cd => Lancamento.(nome_chave)
#  validates_inclusion_of :tipo, :in => ["Receita","Despesa"]
#  validates_inclusion_of :status, :in => ["Aberto","Quitado","Estornado","Cancelado"]
    
  as_enum :tipo, [:receita, :despesa]
  as_enum :status, [:aberto, :quitado, :estornado, :cancelado]  
    
  belongs_to :category
  belongs_to :centrodecusto
  
#  has_one :parcela_lancamento, :dependent => :destroy 
  belongs_to :parcela
    
  has_one :lancamento_estornado, :class_name => "Lancamento", :foreign_key => "estorno_id"
  belongs_to :lancamento_original, :class_name => "Lancamento", :foreign_key => "estorno_id"
  
    
# => Preparação para as validações    
  before_validation :set_default_status_if_not_specified
  before_validation :set_default_datavencimento_if_not_specified
  before_validation :set_tipo_depending_valor
  before_validation :set_default_valor_if_null
  before_validation :set_default_categoria_if_null
  before_validation :set_default_centrodecusto_if_null
  
  before_validation :set_valor_two_decimal_places
            
  validates :descricao, :presence => true
  validates :status, :presence => true
  validates :tipo, :presence => true
  validates :valor, :presence => true
  validates :datavencimento, :presence => true   
  validates :centrodecusto, :presence=> true
  validates :category, :presence => true
  
  validates_format_of :valor, :with => /^\d+\.*\d{0,2}$/
  validates :descricao, length: { maximum: 255 } 
  
  validates_as_enum :tipo
  validates_as_enum :status
  
  #Status validation
  validate :status_not_aberto_if_dataacao
  validate :status_not_quitado_if_no_dataacao
#  validate :status_quitado_no_change_allowed

# public methods
  def has_estorno?
    (!self.lancamento_estornado.nil? or !self.lancamento_original.nil?) and self.estornado?
  end
  
  def is_original?
    !self.lancamento_estornado.nil?
  end
  
  def is_estorno?
    !self.lancamento_original.nil?
  end
  
  def cancel
    self.status = :cancelado
    self.dataacao = Date.today.strftime("%d-%m-%Y")
    self.save
  end

  private 

  def set_default_status_if_not_specified
    self.status = :aberto if self.status.blank?
  end
  
  # Engenharia detalhada: 3.1.2
  def set_default_datavencimento_if_not_specified
    self.datavencimento = Date.today if self.datavencimento.blank? 
  end
    
  def set_tipo_depending_valor
    if self.valor? and self.valor < 0      
        self.tipo = :despesa
        self.valor = self.valor * -1      
    end
  end
  
  def set_valor_two_decimal_places
     self.valor = self.valor.round(2)
  end
  
  def set_default_valor_if_null
    self.valor = 0 if self.valor.blank?
  end
  
  def set_default_categoria_if_null
    self.category = Category.find_by_descricao(Configurable.categoria_padrao) if self.category.blank?
  end
  
  def set_default_centrodecusto_if_null
    self.centrodecusto = Centrodecusto.find_by_descricao(Configurable.centrodecusto_padrao) if self.centrodecusto.blank?
  end
  
#  def set_dataacao_null_if_status_cancelado
#    self.dataacao = nil if self.cancelado?
#  end
  
  def status_not_aberto_if_dataacao    
    errors.add(:status, "Nao pode estar aberto se existir data de confirmacao") if not self.dataacao.blank? and self.aberto?   
  end
  
  def status_not_quitado_if_no_dataacao
    errors.add(:status, "O lancamento nao pode estar quitado sem uma data de confirmacao") if self.quitado? and self.dataacao.blank?
  end
  
  def status_quitado_no_change_allowed
    errors.add(:status, "O lancamento quitado nao pode ser alterado") if self.changed? and self.quitado?
  end 
  
#  def status_not_cancelado_if_dataacao
#    errors.add(:status, "Nao pode estar cancelado se existir data de ")
#  end
      
end