require 'spec_helper'

describe "targets/show" do
  before(:each) do
    @target = assign(:target, stub_model(Target,
      :tipo_cd => 1,
      :descricao => "Descricao",
      :valor => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Descricao/)
    rendered.should match(/9.99/)
  end
end
