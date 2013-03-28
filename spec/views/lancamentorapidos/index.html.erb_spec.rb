require 'spec_helper'

describe "lancamentorapidos/index" do
  before(:each) do
    assign(:lancamentorapidos, [
      stub_model(Lancamentorapido),
      stub_model(Lancamentorapido)
    ])
  end

  it "renders a list of lancamentorapidos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
