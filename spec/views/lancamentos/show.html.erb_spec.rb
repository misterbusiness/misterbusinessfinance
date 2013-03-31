require 'spec_helper'

describe "lancamentos/show" do
  before(:each) do
    @lancamento = assign(:lancamento, stub_model(Lancamento))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
