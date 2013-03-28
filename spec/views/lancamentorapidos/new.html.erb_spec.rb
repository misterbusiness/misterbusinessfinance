require 'spec_helper'

describe "lancamentorapidos/new" do
  before(:each) do
    assign(:lancamentorapido, stub_model(Lancamentorapido).as_new_record)
  end

  it "renders new lancamentorapido form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lancamentorapidos_path, :method => "post" do
    end
  end
end
