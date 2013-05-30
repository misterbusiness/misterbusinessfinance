require 'spec_helper'

describe "targets/new" do
  before(:each) do
    assign(:target, stub_model(Target,
      :tipo_cd => 1,
      :descricao => "MyString",
      :valor => "9.99"
    ).as_new_record)
  end

  it "renders new target form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => targets_path, :method => "post" do
      assert_select "input#target_tipo_cd", :name => "target[tipo_cd]"
      assert_select "input#target_descricao", :name => "target[descricao]"
      assert_select "input#target_valor", :name => "target[valor]"
    end
  end
end
