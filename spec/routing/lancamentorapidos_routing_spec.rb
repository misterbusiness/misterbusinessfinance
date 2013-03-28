require "spec_helper"

describe LancamentorapidosController do
  describe "routing" do

    it "routes to #index" do
      get("/lancamentorapidos").should route_to("lancamentorapidos#index")
    end

    it "routes to #new" do
      get("/lancamentorapidos/new").should route_to("lancamentorapidos#new")
    end

    it "routes to #show" do
      get("/lancamentorapidos/1").should route_to("lancamentorapidos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/lancamentorapidos/1/edit").should route_to("lancamentorapidos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/lancamentorapidos").should route_to("lancamentorapidos#create")
    end

    it "routes to #update" do
      put("/lancamentorapidos/1").should route_to("lancamentorapidos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/lancamentorapidos/1").should route_to("lancamentorapidos#destroy", :id => "1")
    end

  end
end
