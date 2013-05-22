# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cat = Category.create(:descricao => "Sem categoria")
cat = Category.create(:descricao => "Servicos")
cat = Category.create(:descricao => "Travel and Living")
cat = Category.create(:descricao => "Projetos")
cat = Category.create(:descricao => "Administrativo")
cat = Category.create(:descricao => "Escritorio")
cat = Category.create(:descricao => "Vendas")

cdc = Centrodecusto.create(:descricao => "Sem centro de custo")
cdc = Centrodecusto.create(:descricao => "Corporativo")
cdc = Centrodecusto.create(:descricao => "Vendas")
cdc = Centrodecusto.create(:descricao => "Engenharia")
cdc = Centrodecusto.create(:descricao => "Produto")
cdc = Centrodecusto.create(:descricao => "Projetos")

