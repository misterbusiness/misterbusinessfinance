require 'spec_helper'

describe Lancamento do
#  fixtures :lancamentos

  before { @lancamento = Lancamento.new(descricao:"Lancamento de Teste", tipo: Lancamento.receita) }  
  before { @cat = Category.new(descricao: "Categoria vazia") }
  before { @cat.save }
  before { @cdc = Centrodecusto.new(descricao: "Centro de custo vazio") }
  before { @cdc.save } 
     
  
  subject { @lancamento }
  
  it { should respond_to(:descricao) }
  it { should respond_to(:status) }
  it { should respond_to(:tipo) }
  it { should respond_to(:valor) }
  it { should respond_to(:datavencimento) }  
  it { should respond_to(:category) }
  it { should respond_to(:centrodecusto) }
  
  it { should be_valid } 
  
#  describe "when tipo is not enum" do
#    before {@lancamento.tipo = 13}
#    it {should_not be_valid}
#  end
  
#  describe "when status is not enum" do
#    before {@lancamento.status = 13}
#    it {should_not be_valid}
#  end
  
  describe "when descricao is not present" do
    before {@lancamento.descricao = " "}
    it { should_not be_valid}
  end
  
  describe "when descricao is too long" do
    before { @lancamento.descricao = "a"*256 }
    it { should_not be_valid}
  end
  
  describe "when valor is negative" do
    before { @lancamento.valor = Math::PI*-1 }
    before { @lancamento.tipo = :receita }
    before { @lancamento.save }
    it { @lancamento.tipo.should eq(:despesa) }
    it { @lancamento.valor.to_f.should eq(3.14)}
  end    
  
  describe "when categoria is not present" do 
    before { @lancamento.category = nil }
    before { @lancamento.save }
    it { @lancamento.category.should eq(Category.find_by_descricao("Categoria vazia")) }
  end 
  
  describe "when centrodecusto is not present" do
    before { @lancamento.centrodecusto = nil }
    before { @lancamento.save }
    it { @lancamento.centrodecusto.should eq(Centrodecusto.find_by_descricao("Centro de custo vazio")) }
  end  
  
end
