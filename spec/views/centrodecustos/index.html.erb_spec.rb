require 'spec_helper'

describe "centrodecustos/index" do
  before(:each) do
    assign(:centrodecustos, [
      stub_model(Centrodecusto,
        :descricao => "Descricao"
      ),
      stub_model(Centrodecusto,
        :descricao => "Descricao"
      )
    ])
  end

  it "renders a list of centrodecustos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Descricao".to_s, :count => 2
  end
end
