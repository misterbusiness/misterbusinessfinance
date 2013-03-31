require 'spec_helper'

describe "lancamentos/new" do
  before(:each) do
    assign(:lancamento, stub_model(Lancamento).as_new_record)
  end

  it "renders new lancamento form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lancamentos_path, :method => "post" do
    end
  end
end
