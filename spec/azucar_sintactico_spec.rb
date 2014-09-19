require_relative 'spec_helper'

describe 'Azucar Sintactico' do

  it 'Parte 1' do
    guerrero_proto = PrototypedObject.new
    guerrero_proto.energia = 100
    expect(guerrero_proto.energia).to eq(100)
    guerrero_proto.potencial_defensivo = 10
    guerrero_proto.potencial_ofensivo = 30
    guerrero_proto.atacar_a = proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end}
    guerrero_proto.recibe_danio =  proc { |danio|
      self.energia = self.energia - danio}

    Guerrero = PrototypedConstructor.copy(guerrero_proto)
    un_guerrero = Guerrero.new
    Guerrero.new.atacar_a(un_guerrero)
    expect(un_guerrero.energia).to eq(80)
  end


  it 'Parte 2' do
    guerrero_proto = PrototypedObject.new {
      self.energia = 100
      self.potencial_ofensivo = 30
      self.potencial_defensivo = 10
      self.atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      self.recibe_danio = proc { |danio|
        self.energia = self.energia - danio}
    }

    # Se controla que se hayan asignado todos los atributos
    expect(guerrero_proto.energia).to eq(100)
    expect(guerrero_proto.potencial_ofensivo).to eq(30)
    expect(guerrero_proto.potencial_defensivo).to eq(10)

    # Se controla que se hayan asignado los métodos 'atacar_a' y 'recibe_danio' y que devuelve lo que corresponde.
    otro_guerrero = guerrero_proto.clone
    expect(otro_guerrero.atacar_a(guerrero_proto)).to eq(80)
  end

  it 'Parte 3' do

    guerrero = PrototypedObject.new
    guerrero_constructor = PrototypedConstructor.new(guerrero) do |una_energia, un_potencial_ofensivo,
        un_potencial_defensivo|
      self.energia = una_energia
      self.potencial_ofensivo = un_potencial_ofensivo
      self.potencial_defensivo = un_potencial_defensivo
    end

    un_guerrero = guerrero_constructor.new(100, 30, 10)
    expect(un_guerrero.energia).to eq(100)
  end

  it 'Parte 4' do

    guerrero_constructor = PrototypedConstructor.create {
      self.atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      self.recibe_danio = proc { |danio| self.energia = self.energia - danio}
    }.with {
        |una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      self.energia = una_energia
      self.potencial_ofensivo = un_potencial_ofensivo
      self.potencial_defensivo = un_potencial_defensivo
    }

    guerrero = guerrero_constructor.new(100, 30, 10)
    expect(guerrero.energia).to eq(100)

  end

end