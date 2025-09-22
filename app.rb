# Aplicação principal do sistema de clínica veterinária
# Desenvolvido em Ruby com Sinatra
require 'sinatra/base'
require 'sinatra/reloader'
require 'sequel'
require 'bcrypt'
require 'rack-flash'

# Importação dos modelos
require_relative 'models/database'
require_relative 'models/client'
require_relative 'models/pet'
require_relative 'models/appointment'
require_relative 'models/medical_record'

class VeterinaryApp < Sinatra::Base
  # Configuração para ambiente de desenvolvimento
  configure :development do
    register Sinatra::Reloader
    also_reload 'models/*.rb'
  end

  # Configuração de sessões e flash messages
  use Rack::Session::Cookie, secret: 'veterinary_clinic_secret_key_2024'
  use Rack::Flash

  # Configuração de diretórios
  set :views, './views'
  set :public_folder, './public'

  # Métodos auxiliares para formatação
  helpers do
    # Formatar data no padrão brasileiro
    def format_date(date)
      return 'N/A' unless date
      date.strftime('%d/%m/%Y')
    end

    # Formatar data e hora no padrão brasileiro
    def format_datetime(datetime)
      return 'N/A' unless datetime
      datetime.strftime('%d/%m/%Y às %H:%M')
    end
  end

  # ROTA PRINCIPAL - Dashboard
  get '/' do
    # Buscar estatísticas para o dashboard
    @total_clients = Client.count
    @total_pets = Pet.count
    @total_appointments = Appointment.count
    # Buscar as 5 consultas mais recentes
    @recent_appointments = Appointment.order(:date_time).reverse.limit(5).all
    erb :dashboard
  end

  # ==================== ROTAS PARA CLIENTES ====================
  
  # Listar todos os clientes
  get '/clients' do
    @clients = Client.order(:name).all
    erb :'clients/index'
  end

  # Formulário para novo cliente
  get '/clients/new' do
    erb :'clients/new'
  end

  # Criar novo cliente
  post '/clients' do
    client = Client.new(
      name: params[:name],
      email: params[:email],
      phone: params[:phone],
      address: params[:address]
    )
    
    # Validar e salvar cliente
    if client.valid?
      client.save
      flash[:success] = 'Cliente cadastrado com sucesso!'
      redirect '/clients'
    else
      flash[:error] = client.errors.full_messages.join(', ')
      erb :'clients/new'
    end
  end

  # Exibir detalhes de um cliente específico
  get '/clients/:id' do
    @client = Client[params[:id]]
    halt 404 unless @client
    # Buscar pets do cliente
    @pets = @client.pets
    erb :'clients/show'
  end

  # Formulário para editar cliente
  get '/clients/:id/edit' do
    @client = Client[params[:id]]
    halt 404 unless @client
    erb :'clients/edit'
  end

  # Atualizar dados do cliente
  put '/clients/:id' do
    @client = Client[params[:id]]
    halt 404 unless @client
    
    @client.update(
      name: params[:name],
      email: params[:email],
      phone: params[:phone],
      address: params[:address]
    )
    
    flash[:success] = 'Cliente atualizado com sucesso!'
    redirect "/clients/#{@client.id}"
  end

  # Remover cliente
  delete '/clients/:id' do
    client = Client[params[:id]]
    halt 404 unless client
    
    client.destroy
    flash[:success] = 'Cliente removido com sucesso!'
    redirect '/clients'
  end

  # ==================== ROTAS PARA PETS ====================
  
  # Listar todos os pets
  get '/pets' do
    # Buscar pets com informações do cliente
    @pets = Pet.eager(:client).order(:name).all
    erb :'pets/index'
  end

  # Formulário para novo pet
  get '/pets/new' do
    # Buscar clientes para o select
    @clients = Client.order(:name).all
    erb :'pets/new'
  end

  # Criar novo pet
  post '/pets' do
    pet = Pet.new(
      name: params[:name],
      species: params[:species],
      breed: params[:breed],
      age: params[:age].to_i,
      weight: params[:weight].to_f,
      color: params[:color],
      client_id: params[:client_id].to_i
    )
    
    # Validar e salvar pet
    if pet.valid?
      pet.save
      flash[:success] = 'Pet cadastrado com sucesso!'
      redirect '/pets'
    else
      @clients = Client.order(:name).all
      flash[:error] = pet.errors.full_messages.join(', ')
      erb :'pets/new'
    end
  end

  # Exibir detalhes de um pet específico
  get '/pets/:id' do
    # Buscar pet com todas as informações relacionadas
    @pet = Pet.eager(:client, :appointments, :medical_records).where(id: params[:id]).first
    halt 404 unless @pet
    erb :'pets/show'
  end

  # Formulário para editar pet
  get '/pets/:id/edit' do
    @pet = Pet[params[:id]]
    halt 404 unless @pet
    # Buscar clientes para o select
    @clients = Client.order(:name).all
    erb :'pets/edit'
  end

  # Atualizar dados do pet
  put '/pets/:id' do
    @pet = Pet[params[:id]]
    halt 404 unless @pet
    
    @pet.update(
      name: params[:name],
      species: params[:species],
      breed: params[:breed],
      age: params[:age].to_i,
      weight: params[:weight].to_f,
      color: params[:color],
      client_id: params[:client_id].to_i
    )
    
    flash[:success] = 'Pet atualizado com sucesso!'
    redirect "/pets/#{@pet.id}"
  end

  # Remover pet
  delete '/pets/:id' do
    pet = Pet[params[:id]]
    halt 404 unless pet
    
    pet.destroy
    flash[:success] = 'Pet removido com sucesso!'
    redirect '/pets'
  end

  # ==================== ROTAS PARA CONSULTAS ====================
  
  # Listar todas as consultas
  get '/appointments' do
    # Buscar consultas com informações do pet e cliente
    @appointments = Appointment.eager(:pet => :client).order(:date_time).reverse.all
    erb :'appointments/index'
  end

  # Formulário para nova consulta
  get '/appointments/new' do
    # Buscar pets com informações do cliente para o select
    @pets = Pet.eager(:client).order(:name).all
    erb :'appointments/new'
  end

  # Criar nova consulta
  post '/appointments' do
    appointment = Appointment.new(
      pet_id: params[:pet_id].to_i,
      # Combinar data e hora em um DateTime
      date_time: DateTime.parse("#{params[:date]} #{params[:time]}"),
      reason: params[:reason],
      notes: params[:notes],
      status: params[:status] || 'agendada'
    )
    
    # Validar e salvar consulta
    if appointment.valid?
      appointment.save
      flash[:success] = 'Consulta agendada com sucesso!'
      redirect '/appointments'
    else
      @pets = Pet.eager(:client).order(:name).all
      flash[:error] = appointment.errors.full_messages.join(', ')
      erb :'appointments/new'
    end
  end

  # Exibir detalhes de uma consulta específica
  get '/appointments/:id' do
    # Buscar consulta com informações do pet e cliente
    @appointment = Appointment.eager(:pet => :client).where(id: params[:id]).first
    halt 404 unless @appointment
    erb :'appointments/show'
  end

  # Formulário para editar consulta
  get '/appointments/:id/edit' do
    @appointment = Appointment[params[:id]]
    halt 404 unless @appointment
    # Buscar pets para o select
    @pets = Pet.eager(:client).order(:name).all
    erb :'appointments/edit'
  end

  # Atualizar dados da consulta
  put '/appointments/:id' do
    @appointment = Appointment[params[:id]]
    halt 404 unless @appointment
    
    @appointment.update(
      pet_id: params[:pet_id].to_i,
      # Combinar data e hora em um DateTime
      date_time: DateTime.parse("#{params[:date]} #{params[:time]}"),
      reason: params[:reason],
      notes: params[:notes],
      status: params[:status]
    )
    
    flash[:success] = 'Consulta atualizada com sucesso!'
    redirect "/appointments/#{@appointment.id}"
  end

  # Remover consulta
  delete '/appointments/:id' do
    appointment = Appointment[params[:id]]
    halt 404 unless appointment
    
    appointment.destroy
    flash[:success] = 'Consulta removida com sucesso!'
    redirect '/appointments'
  end

  # ==================== ROTAS PARA HISTÓRICO MÉDICO ====================
  
  # Listar todos os registros médicos
  get '/medical_records' do
    # Buscar registros com informações do pet e cliente
    @medical_records = MedicalRecord.eager(:pet => :client).order(:date).reverse.all
    erb :'medical_records/index'
  end

  # Formulário para novo registro médico
  get '/medical_records/new' do
    # Buscar pets para o select
    @pets = Pet.eager(:client).order(:name).all
    erb :'medical_records/new'
  end

  # Criar novo registro médico
  post '/medical_records' do
    medical_record = MedicalRecord.new(
      pet_id: params[:pet_id].to_i,
      date: Date.parse(params[:date]),
      diagnosis: params[:diagnosis],
      treatment: params[:treatment],
      medications: params[:medications],
      notes: params[:notes],
      veterinarian: params[:veterinarian]
    )
    
    # Validar e salvar registro médico
    if medical_record.valid?
      medical_record.save
      flash[:success] = 'Registro médico criado com sucesso!'
      redirect '/medical_records'
    else
      @pets = Pet.eager(:client).order(:name).all
      flash[:error] = medical_record.errors.full_messages.join(', ')
      erb :'medical_records/new'
    end
  end

  # Exibir detalhes de um registro médico específico
  get '/medical_records/:id' do
    # Buscar registro com informações do pet e cliente
    @medical_record = MedicalRecord.eager(:pet => :client).where(id: params[:id]).first
    halt 404 unless @medical_record
    erb :'medical_records/show'
  end

  # Executar aplicação se este arquivo for chamado diretamente
  run! if app_file == $0
end