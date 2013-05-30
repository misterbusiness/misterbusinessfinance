require 'spec_helper'

describe "targets/index" do
  before(:each) do
    assign(:targets, [
      stub_model(Target,
        :tipo_cd => 1,
        :descricao => "Descricao",
        :valor => "9.99"
      ),
      stub_model(Target,
        :tipo_cd => 1,
        :descricao => "Descricao",
        :valor => "9.99"
      )
    ])
  end

  it "renders a list of targets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Descricao".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
