require 'spec_helper'

describe "lancamentorapidos/edit" do
  before(:each) do
    @lancamentorapido = assign(:lancamentorapido, stub_model(Lancamentorapido))
  end

  it "renders the edit lancamentorapido form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lancamentorapidos_path(@lancamentorapido), :method => "post" do
    end
  end
end
