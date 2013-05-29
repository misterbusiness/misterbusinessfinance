class Lancamento < ActiveRecord::Base
  attr_accessible :datavencimento, :descricao, :status, :tipo, :valor,
                  :dataacao, :category, :centrodecusto, :category_id, :centrodecusto_id,
                  :lancamento_estornado, :lancamento_original

  as_enum :tipo, [:receita, :despesa]
  as_enum :status, [:aberto, :quitado, :estornado, :cancelado]  
    
  belongs_to :category
  belongs_to :centrodecusto
  
#  has_one :parcela_lancamento, :dependent => :destroy 
  belongs_to :parcela
  belongs_to :agendamento
    
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


# scopes
# Using squeel and ARel. Squeel é utilizado para operações unicas no banco

  # O escopo padrão será de lançamentos válidos, ou seja, não cancelados e não estornados
  default_scope where(Lancamento.arel_table[:status_cd].not_eq(Lancamento.cancelado))

  scope :parcelados, where(Lancamento.arel_table[:parcela_id].not_eq(nil)).group(:parcela_id)
  scope :a_vista, where(Lancamento.arel_table[:parcela_id].eq(nil))
  scope :receitas, where(:tipo_cd => Lancamento.receita)
  scope :despesas, where(:tipo_cd => Lancamento.despesa)
  scope :por_mes, group{date_part('month',datavencimento)}.order{date_part('month',datavencimento)}
  scope :este_ano, lambda {|ano| where(:datavencimento => ano.beginning_of_year..ano.end_of_year)}
  scope :este_mes, lambda {|mes| where(:datavencimento => mes.beginning_of_month..mes.end_of_month)}
  scope :parcelamentos_realizados, lambda {|ano| parcelados.este_ano(ano).por_mes}
  scope :lancamentos_realizados, lambda {|ano| a_vista.este_ano(ano).por_mes}
  scope :quitados, where(:status_cd => Lancamento.quitado)
  scope :abertos, where(:status_cd => Lancamento.aberto)
  scope :este_dia, lambda {|dia| where(:datavencimento => dia.beginning_of_day..dia.end_of_day)}
  scope :por_dia,  group{date_part('day',datavencimento)}.order{date_part('day',datavencimento)}
  scope :caixa_dia, lambda {|dia| receitas.quitados.por_dia.select{sum(valor)} - despesas.quitados.por_dia.select{sum(valor)} }
  scope :caixa_mes, lambda {|mes| receitas.quitados.este_mes(mes).select{sum(valor)} - despesas.quitados.este_mes(mes).select{sum(valor)} }

  scope :range, lambda {|dt_inicio, dt_fim| where(:datavencimento => dt_inicio..dt_fim )}
  scope :a_partir_de, lambda {|dt| where('datavencimento > (?) ', dt)}
  scope :a_partir_de_backwards, lambda {|dt| where('datavencimento < (?) ', dt)}

  scope :por_categoria, group{category_id}
  scope :por_centrodecusto, group{centrodecusto_id}
  scope :por_status, group {status_cd}

# public methods
  def has_parcelamento?
    !self.parcela.nil?
  end

  def has_agendamento?
    !self.agendamento.nil?
  end

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
    self.centrodecusto = Centrodecusto.find_by_descricao(Configurable.centrodecusto_padrao) if self.centrodecusto.nil?
  end

  def status_not_aberto_if_dataacao    
    errors.add(:status, "Nao pode estar aberto se existir data de confirmacao") if not self.dataacao.blank? and self.aberto?   
  end
  
  def status_not_quitado_if_no_dataacao
    errors.add(:status, "O lancamento nao pode estar quitado sem uma data de confirmacao") if self.quitado? and self.dataacao.blank?
  end
  
  def status_quitado_no_change_allowed
    errors.add(:status, "O lancamento quitado nao pode ser alterado") if self.changed? and self.quitado?
  end

end
