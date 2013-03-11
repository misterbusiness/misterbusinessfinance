require 'spec_helper'

describe Centrodecusto do
  before { @cdc = Centrodecusto.new(descricao: Configurable.centrodecusto_padrao) }
  before { @cdc.save }
  
  subject { @cdc }
  
  it { should respond_to(:descricao) }
  
  describe "when centro de custo is already taken" do
    before do 
       cat_duplicate = Centrodecusto.new(descricao: Configurable.centrodecusto_padrao)
       cat_duplicate.save 
    end
    
    it { should_not be_valid }
  end
end
