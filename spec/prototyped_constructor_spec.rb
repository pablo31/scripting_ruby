require 'rspec'
require_relative '../lib/prototyped_constructor'

describe 'Constructores' do

  let :guerrero do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero
  end

  it 'Parte 1' do

    guerrero_constructor = PrototypedConstructor.new(guerrero, proc {
        |guerrero_nuevo, una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      guerrero_nuevo.energia = una_energia
      guerrero_nuevo.potencial_ofensivo = un_potencial_ofensivo
      guerrero_nuevo.potencial_defensivo = un_potencial_defensivo
    })
    un_guerrero = guerrero_constructor.new(100, 30, 10)
    expect(un_guerrero.energia).to eq(100)

  end

  it 'Parte 2' do

    guerrero_constructor = PrototypedConstructor.new(guerrero)
    un_guerrero = guerrero_constructor.new(
        {energia: 100, potencial_ofensivo: 30, potencial_defensivo: 10}
    )
    expect(un_guerrero.potencial_ofensivo).to eq(30)

  end

  it 'Parte 3' do

    guerrero_constructor = PrototypedConstructor.copy(guerrero)
    un_guerrero = guerrero_constructor.new
    expect(un_guerrero.potencial_defensivo).to eq(10)

  end


  it 'Parte 4' do

    guerrero_constructor = PrototypedConstructor.new(guerrero, proc {
        |guerrero_nuevo, una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      guerrero_nuevo.energia = una_energia
      guerrero_nuevo.potencial_ofensivo = un_potencial_ofensivo
      guerrero_nuevo.potencial_defensivo = un_potencial_defensivo
    })
    un_guerrero = guerrero_constructor.new(100, 30, 10)
    expect(un_guerrero.energia).to eq(100)


    #Guerrero es la primer variante de constructores, que recibe 3 parametros
    espadachin_constructor = guerrero_constructor.extended {
        |espadachin, habilidad, potencial_espada|
      espadachin.set_property(:habilidad, habilidad)
      espadachin.set_property(:potencial_espada, potencial_espada)
      espadachin.set_method(:potencial_ofensivo, proc {
        @potencial_ofensivo + self.potencial_espada * self.habilidad
      })
    }
    espadachin = espadachin_constructor.new(100, 30, 10, 0.5, 30)
    expect(espadachin.potencial_ofensivo).to eq(45)
  end

end