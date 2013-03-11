require 'spec_helper'

describe Category do
  before { @cat = Category.new(descricao: Configurable.categoria_padrao) }
  before { @cat.save }
  
  subject { @cat }
  
  it { should respond_to(:descricao) }
  
  describe "when categoria is already taken" do
    before do 
       cat_duplicate = Category.new(descricao: Configurable.categoria_padrao)
       cat_duplicate.save 
    end
    
    it { should_not be_valid }
  end
end
