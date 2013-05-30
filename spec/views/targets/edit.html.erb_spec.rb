require 'spec_helper'

describe "targets/edit" do
  before(:each) do
    @target = assign(:target, stub_model(Target,
      :tipo_cd => 1,
      :descricao => "MyString",
      :valor => "9.99"
    ))
  end

  it "renders the edit target form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => targets_path(@target), :method => "post" do
      assert_select "input#target_tipo_cd", :name => "target[tipo_cd]"
      assert_select "input#target_descricao", :name => "target[descricao]"
      assert_select "input#target_valor", :name => "target[valor]"
    end
  end
end
