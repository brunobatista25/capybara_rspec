require 'spec_helper.rb'

describe 'Registrar conta' do
  it 'Com sucesso' do
    user_page.load
    @pessoa = OpenStruct.new
    @pessoa.nome = Faker::Name.first_name
    @pessoa.sobrenome = Faker::Name.last_name
    @pessoa.endereco = Faker::Address.street_name
    @pessoa.email = Faker::Internet.free_email

    user_page.realizar_cadastro(@pessoa)

    expect(user_page.notice.text).to eq 'Usuário Criado com sucesso'
  end
end
