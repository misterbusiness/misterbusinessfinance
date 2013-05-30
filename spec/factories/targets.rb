# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :target do
    data "2013-05-30"
    tipo_cd 1
    descricao "MyString"
    valor "9.99"
  end
end
