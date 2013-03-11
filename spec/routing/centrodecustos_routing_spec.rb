require "spec_helper"

describe CentrodecustosController do
  describe "routing" do

    it "routes to #index" do
      get("/centrodecustos").should route_to("centrodecustos#index")
    end

    it "routes to #new" do
      get("/centrodecustos/new").should route_to("centrodecustos#new")
    end

    it "routes to #show" do
      get("/centrodecustos/1").should route_to("centrodecustos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/centrodecustos/1/edit").should route_to("centrodecustos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/centrodecustos").should route_to("centrodecustos#create")
    end

    it "routes to #update" do
      put("/centrodecustos/1").should route_to("centrodecustos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/centrodecustos/1").should route_to("centrodecustos#destroy", :id => "1")
    end

  end
end
