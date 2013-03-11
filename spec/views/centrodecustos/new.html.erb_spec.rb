require 'spec_helper'

describe "centrodecustos/new" do
  before(:each) do
    assign(:centrodecusto, stub_model(Centrodecusto,
      :descricao => "MyString"
    ).as_new_record)
  end

  it "renders new centrodecusto form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => centrodecustos_path, :method => "post" do
      assert_select "input#centrodecusto_descricao", :name => "centrodecusto[descricao]"
    end
  end
end
