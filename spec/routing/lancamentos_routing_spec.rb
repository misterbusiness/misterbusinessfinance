require "spec_helper"

describe LancamentosController do
  describe "routing" do

    it "routes to #index" do
      get("/lancamentos").should route_to("lancamentos#index")
    end

    it "routes to #new" do
      get("/lancamentos/new").should route_to("lancamentos#new")
    end

    it "routes to #show" do
      get("/lancamentos/1").should route_to("lancamentos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/lancamentos/1/edit").should route_to("lancamentos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/lancamentos").should route_to("lancamentos#create")
    end

    it "routes to #update" do
      put("/lancamentos/1").should route_to("lancamentos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/lancamentos/1").should route_to("lancamentos#destroy", :id => "1")
    end

  end
end
