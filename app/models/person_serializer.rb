require 'active_model_serializers'

class Person
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  attr_accessor :name, :age, :notes

  def initialize
    @notes = []
  end

  # Definindo um método attributes para retornar um hash com os valores default
  def attributes
    {'name' => nil, 'age' => nil, 'notes' => nil} # Adicione 'notes' aqui
  end

  # Definindo um método serializable_hash para serializar os dados da pessoa
  def serializable_hash(options = nil)
    super(options).tap do |hash|
      hash['notes'] = notes.map { |note| note.serializable_hash }
    end
  end
end

class Note
  include ActiveModel::Serializers::JSON
  attr_accessor :title, :text

  # Definindo o método initialize para aceitar title e text
  def initialize(title: nil, text: nil)
    @title = title
    @text = text
  end

  # Definindo um método attributes para retornar um hash com os valores default
  def attributes
    {'title' => nil, 'text' => nil}
  end

  # Definindo um método serializable_hash para serializar os dados da notícia
  def serializable_hash
    { 'title' => title, 'text' => text }
  end
end

class PersonSerializer < ActiveModel::Serializer
  attributes :name, :age, :capitalized_name, :notes

    def capitalized_name
    object.name.capitalize
  end
end

# Uso de build : Em vez de criar uma nova instância de Note
person = Person.new
person.name = 'Napoleon'
person.age = 45
note = Note.new(title: 'Battle of Austerlitz', text: 'Some text here')
person.notes << note

puts ""
puts person.serializable_hash
# => {"name"=>"Napoleon", "age"=>45, "notes"=>[{"title"=>"Battle of Austerlitz", "text"=>"Some text here"}]}

