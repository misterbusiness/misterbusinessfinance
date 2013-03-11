require 'spec_helper'

describe "centrodecustos/edit" do
  before(:each) do
    @centrodecusto = assign(:centrodecusto, stub_model(Centrodecusto,
      :descricao => "MyString"
    ))
  end

  it "renders the edit centrodecusto form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => centrodecustos_path(@centrodecusto), :method => "post" do
      assert_select "input#centrodecusto_descricao", :name => "centrodecusto[descricao]"
    end
  end
end
