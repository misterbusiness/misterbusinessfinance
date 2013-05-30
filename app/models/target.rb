class Target < ActiveRecord::Base
  attr_accessible :data, :descricao, :tipo_cd, :valor

  as_enum :tipo, [:receita, :despesa]

  scope :receitas, where(:tipo_cd => Target.receita)
  scope :despesas, where(:tipo_cd => Target.despesa)
  scope :por_mes, group{date_part('month',data)}.order{date_part('month',data)}
  scope :este_ano, lambda {|ano| where(:data => ano.beginning_of_year..ano.end_of_year)}
  scope :este_mes, lambda {|mes| where(:data => mes.beginning_of_month..mes.end_of_month)}

end