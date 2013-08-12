class Category < ActiveRecord::Base

  attr_accessible :descricao, :ancestry, :parent_id, :is_cash_flow
  
  validates :descricao, :presence => true, :uniqueness => { :case_sensitive => false }
    
  has_many :lancamento
  has_many :lancamentorapido
  
  has_ancestry

  scope :cash_flow_flag, where(:is_cash_flow => true)
  scope :no_cash_flow_flag, where(Category.arel_table[:is_cash_flow].eq(false).or(Category.arel_table[:is_cash_flow].eq(nil)))

  def self.receitas_vendas_cash_flow
    @sales_id = Category.find_by_code(Configurable.sales_category_code)

    return Category.find_by_an
  end
end
