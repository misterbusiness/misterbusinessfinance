# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130331000823) do

  create_table "categories", :force => true do |t|
    t.string   "descricao"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "centrodecustos", :force => true do |t|
    t.string   "descricao"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "centrodecustos", ["ancestry"], :name => "index_centrodecustos_on_ancestry"

  create_table "configurables", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "configurables", ["name"], :name => "index_configurables_on_name"

  create_table "lancamentorapidos", :force => true do |t|
    t.string   "descricao"
    t.integer  "tipo_cd"
    t.integer  "diavencimento"
    t.decimal  "valor",            :precision => 9, :scale => 2
    t.string   "categoria"
    t.string   "centrodecusto"
    t.integer  "category_id"
    t.integer  "centrodecusto_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "lancamentos", :force => true do |t|
    t.string   "descricao"
    t.integer  "tipo_cd"
    t.date     "datavencimento"
    t.date     "dataacao"
    t.decimal  "valor",            :precision => 9, :scale => 2
    t.integer  "status_cd"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "category_id"
    t.integer  "centrodecusto_id"
    t.integer  "estorno_id"
    t.integer  "parcela_id"
  end

  create_table "meta", :force => true do |t|
    t.integer  "tipo"
    t.integer  "mes"
    t.integer  "ano"
    t.string   "descricao"
    t.decimal  "valor",      :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "parcela_lancamentos", :force => true do |t|
    t.integer  "indice"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "parcela_id"
    t.integer  "lancamento_id"
  end

  create_table "parcelas", :force => true do |t|
    t.integer  "num_parcelas"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
