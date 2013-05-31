require 'spec_helper'

describe ReportsController do

  describe "GET 'receita_realizada'" do
    it "returns http success" do
      get 'receita_realizada'
      response.should be_success
    end
  end

  describe "GET 'despesa_realizada'" do
    it "returns http success" do
      get 'despesa_realizada'
      response.should be_success
    end
  end

  describe "GET 'receita_por_categoria'" do
    it "returns http success" do
      get 'receita_por_categoria'
      response.should be_success
    end
  end

  describe "GET 'despesa_por_categoria'" do
    it "returns http success" do
      get 'despesa_por_categoria'
      response.should be_success
    end
  end

  describe "GET 'receita_por_status'" do
    it "returns http success" do
      get 'receita_por_status'
      response.should be_success
    end
  end

  describe "GET 'despesa_por_centrodecusto'" do
    it "returns http success" do
      get 'despesa_por_centrodecusto'
      response.should be_success
    end
  end

end
