require 'spec_helper'

describe "centrodecustos/show" do
  before(:each) do
    @centrodecusto = assign(:centrodecusto, stub_model(Centrodecusto,
      :descricao => "Descricao"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Descricao/)
  end
end
