require 'spec_helper'

describe "lancamentos/index" do
  before(:each) do
    assign(:lancamentos, [
      stub_model(Lancamento),
      stub_model(Lancamento)
    ])
  end

  it "renders a list of lancamentos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
