class Lancamento < ActiveRecord::Base
  attr_accessible :categoria, :centrodecusto, :dataacao, :datavencimento, :descricao, :status, :tipo, :valor
end
