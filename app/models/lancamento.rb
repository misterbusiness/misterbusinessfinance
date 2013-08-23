include ActionView::Helpers::NumberHelper

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
  validates :centrodecusto, :presence => true
  validates :category, :presence => true

  validates_format_of :valor, :with => /^\d+\.*\d{0,2}$/
  validates :descricao, length: {maximum: 255}

  validates_as_enum :tipo
  validates_as_enum :status

  #Status validation
  validate :status_not_aberto_if_dataacao
  validate :status_not_quitado_if_no_dataacao


# scopes
# Using squeel and ARel. Squeel é utilizado para operações unicas no banco

# O escopo padrão será de lançamentos válidos, ou seja, não cancelados e não estornados
  default_scope where(Lancamento.arel_table[:status_cd].not_eq(Lancamento.cancelado))

  # Para a visão índice deverão ser carregados todos os lançamentos não cancelados ordenados por data
  # do vencimento crescente dentro da faixa de tempo determinada. O lançamento default será composto de um
  # range de 48 horas adiantadas e atrasadas. Os lançamentos depois serão reorganizados na própria visão de
  # acordo com a data que estiver exibida, a partir de paginação. Ver action FILTROS para as opções de filtragem
  # e os dados que serão resgatados para os mesmos


  scope :padrao, lambda { validos.range(Time.now.beginning_of_month, Time.now.end_of_month).order('datavencimento desc') }

  scope :parcelados, where(Lancamento.arel_table[:parcela_id].not_eq(nil)).group(:parcela_id)
  scope :a_vista, where(Lancamento.arel_table[:parcela_id].eq(nil))
  scope :receitas, where(:tipo_cd => Lancamento.receita)
  scope :despesas, where(:tipo_cd => Lancamento.despesa)

  # Pela data de vencimento
  scope :por_mes, group { date_part('month', datavencimento) }.order { date_part('month', datavencimento) }
  scope :este_ano, lambda { |ano| where(:datavencimento => ano.beginning_of_year..ano.end_of_year) }
  scope :este_mes, lambda { |mes| where(:datavencimento => mes.beginning_of_month..mes.end_of_month) }
  scope :este_dia, lambda { |dia| where(:datavencimento => dia.beginning_of_day..dia.end_of_day) }
  scope :por_dia, group { date_part('day', datavencimento) }.order { date_part('day', datavencimento) }
  scope :range, lambda { |dt_inicio, dt_fim| where(:datavencimento => dt_inicio..dt_fim) }
  scope :a_partir_de, lambda { |dt| where('datavencimento > (?) ', dt) }
  scope :ate, lambda { |dt| where('datavencimento < (?) ', dt) }

  # Pela data da ação
  scope :acao_por_mes, group { date_part('month', dataacao) }.order { date_part('month', dataacao) }
  scope :acao_este_ano, lambda { |ano| where(:dataacao => ano.beginning_of_year..ano.end_of_year) }
  scope :acao_este_mes, lambda { |mes| where(:dataacao => mes.beginning_of_month..mes.end_of_month) }
  scope :acao_este_dia, lambda { |dia| where(:dataacao => dia.beginning_of_day..dia.end_of_day) }
  scope :acao_por_dia, group { date_part('day', dataacao) }.order { date_part('day', dataacao) }
  scope :acao_range, lambda { |dt_inicio, dt_fim| where(:dataacao => dt_inicio..dt_fim) }
  scope :acao_a_partir_de, lambda { |dt| where('dataacao > (?) ', dt) }
  scope :acao_ate, lambda { |dt| where('dataacao < (?) ', dt) }


  scope :parcelamentos_realizados, lambda { |ano| parcelados.este_ano(ano).por_mes }
  scope :lancamentos_realizados, lambda { |ano| a_vista.este_ano(ano).por_mes }
  scope :quitados, where(:status_cd => Lancamento.quitado)
  scope :abertos, where(:status_cd => Lancamento.aberto)
  scope :este_dia, lambda { |dia| where(:datavencimento => dia.beginning_of_day..dia.end_of_day) }
  scope :por_dia, group { date_part('day', datavencimento) }.order { date_part('day', datavencimento) }
  scope :caixa_dia, lambda { |dia| receitas.quitados.por_dia.select { sum(valor) } - despesas.quitados.por_dia.select { sum(valor) } }
  scope :caixa_mes, lambda { |mes| receitas.quitados.este_mes(mes).select { sum(valor) } - despesas.quitados.este_mes(mes).select { sum(valor) } }

  scope :validos, where(status_cd: [Lancamento.quitado, Lancamento.aberto])

  scope :range, lambda { |dt_inicio, dt_fim| where(:datavencimento => dt_inicio..dt_fim) }
  scope :a_partir_de, lambda { |dt| where('datavencimento > (?) ', dt) }
  scope :ate, lambda { |dt| where('datavencimento < (?) ', dt) }

  scope :por_categoria, group { category_id }
  scope :por_centrodecusto, group { centrodecusto_id }
  scope :por_status, group { status_cd }
  scope :por_descricao, lambda { |descricao| where('descricao like ? ', descricao) }

  scope :valor_menor, lambda { |valor| where('valor < (?) ', valor) }
  scope :valor_menor_igual, lambda { |valor| where('valor <= (?) ', valor) }
  scope :valor_maior, lambda { |valor| where('valor > (?) ', valor) }
  scope :valor_maior_igual, lambda { |valor| where('valor >= (?) ', valor) }
  scope :valor_entre, lambda { |valor1,valor2| where('valor >= (?) and valor <= (?)', valor1,valor2) }
  scope :valor_igual, lambda { |valor| where('valor = (?) ', valor) }

  # Lançamentos por categoria-macro
  #scope :vendas, where(category_id => Category.find_by_descricao("Vendas").id)

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


  # Metodos de formatacao
  def valor_format
    self.receita? ? sinal = "+" : sinal = "-"
    number_to_currency("#{sinal}#{self.valor}", precision: 2, unit: "R$ ")
  end

  def datavencimento_format
    !self.datavencimento.nil? ? self.datavencimento.strftime('%d-%m-%Y') : nil
  end

  def dataacao_format
    !self.dataacao.nil? ? self.dataacao.strftime('%d-%m-%Y') : nil
  end

  def category_format
    self.category.descricao
  end

  def centrodecusto_format
    self.centrodecusto.descricao
  end

  def status_format
    self.status
  end

  def estornar_format
    if self.estornado? or self.quitado?
      "<a href='#{Rails.application.routes.url_helpers.estornar_lancamento_path(self.id)}' class='btn mister-table-button' data-remote='true'>X</a>"
    else
      "<p></p>"
    end
  end

  def quitar_format
    if self.aberto? or self.quitado?
      "<a href='#{Rails.application.routes.url_helpers.quitar_lancamento_path(self.id)}' class='btn mister-table-button' data-remote='true'>X</a>"
    else
      "<p></p>"
    end
  end

  def cancelar_format
    if self.aberto? or self.cancelado?
      "<a href='#{Rails.application.routes.url_helpers.cancelar_lancamento_path(self.id)}' class='btn mister-table-button' data-remote='true'>X</a>"
    else
      "<p></p>"
    end
  end

  def self.create_lancamento(params)
    @lancamento = Lancamento.new(params[:lancamento])

    @lancamento.category = Category.find_or_create_by_descricao(params[:category]) unless params[:category].blank?
    @lancamento.centrodecusto = Centrodecusto.find_or_create_by_descricao(params[:centrodecusto]) unless params[:centrodecusto].blank?

    @quitado = params[:quitado]
    @freqParcelas = params[:freqParcelas] unless params[:freqParcelas].blank?
    @numParcelas = Integer(params[:numParcelas]) unless params[:numParcelas].blank?

    @freqAgendamentos = params[:freqAgendamentos] unless params[:freqAgendamentos].blank?
    @numAgendamentos = Integer(params[:numAgendamentos]) unless params[:numAgendamentos].blank?

    #Validações padrão
    @lancamento.tipo = :receita if @lancamento.tipo.blank?
    @lancamento.valor = 0 if @lancamento.valor.blank?

    @numParcelas = 1 if @numParcelas.blank?
    @numAgendamentos = 1 if @numAgendamentos.blank?

    @freqParcelas = 'Mensal' if @freqParcelas.blank?
    @freqAgendamentos = 'Mensal' if @freqAgendamentos.blank?


    if @quitado == 'true'
      @lancamento.status = :quitado
      @lancamento.dataacao = Date.today.strftime('%d-%m-%Y')
    end

    if @numParcelas > 1
      # Cria o registro de parcela
      @parcela = Parcela.new
      @parcela.num_parcelas = @numParcelas

      if @parcela.save then
        (1..@numParcelas).each do |i|
          @lancamento_parcela = Lancamento.new
          @lancamento_parcela = @lancamento.dup
          @lancamento_parcela.valor = @lancamento.valor/@numParcelas

          @lancamento_parcela.datavencimento = case @freqParcelas
                                                 when 'Semanal' then
                                                   @lancamento_parcela.datavencimento + (i-1).weeks
                                                 when 'Mensal' then
                                                   @lancamento_parcela.datavencimento + (i-1).months
                                                 when 'Semestral' then
                                                   @lancamento_parcela.datavencimento + ((i-1)*6).months
                                                 when 'Anual' then
                                                   @lancamento_parcela.datavencimento + (i-1).years
                                                 else
                                                   @lancamento_parcela.datavencimento
                                               end

          @lancamento_parcela.descricao = "#{@lancamento.descricao} - #{@freqParcelas} - (#{i}/#{@numParcelas})"
          @lancamento_parcela.parcela = @parcela

          @lancamento_parcela.save
        end #do
      end # if @parcela.save
    end # @numParcelas > 1


    if @numAgendamentos > 1
      # Cria o registro de agendamento
      @agendamento = Agendamento.new
      @agendamento.num_agendamentos = @numAgendamentos

      if @agendamento.save
        (1..@numAgendamentos).each do |i|
          @lancamento_agendamento = Lancamento.new
          @lancamento_agendamento = @lancamento.dup

          @lancamento_agendamento.datavencimento = case @freqAgendamentos
                                                     when 'Semanal' then
                                                       @lancamento_agendamento.datavencimento + (i-1).weeks
                                                     when 'Mensal' then
                                                       @lancamento_agendamento.datavencimento + (i-1).months
                                                     when 'Semestral' then
                                                       @lancamento_agendamento.datavencimento + ((i-1)*6).months
                                                     when 'Anual' then
                                                       @lancamento_agendamento.datavencimento + (i-1).years
                                                     else
                                                       @lancamento_agendamento.datavencimento
                                                   end
          @lancamento_agendamento.agendamento = @agendamento

          @lancamento_agendamento.save
        end #do
      end #@agendamento.save
    end
    # TODO: Criar uma tabela com o registro de todas as mensagens do sistema
    if (!(@numParcelas > 1) and !(@numAgendamentos > 1))
      if @lancamento.save
        return true
      else
        return false
      end
    end
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
