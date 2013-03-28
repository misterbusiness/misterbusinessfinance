require 'spec_helper'

describe "lancamentorapidos/show" do
  before(:each) do
    @lancamentorapido = assign(:lancamentorapido, stub_model(Lancamentorapido))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
