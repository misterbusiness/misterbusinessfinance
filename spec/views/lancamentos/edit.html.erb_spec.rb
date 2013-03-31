require 'spec_helper'

describe "lancamentos/edit" do
  before(:each) do
    @lancamento = assign(:lancamento, stub_model(Lancamento))
  end

  it "renders the edit lancamento form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => lancamentos_path(@lancamento), :method => "post" do
    end
  end
end
