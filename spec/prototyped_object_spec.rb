require 'rspec'
require_relative '../lib/prototyped_object'

describe PrototypedObject do

  it 'permite definir un nuevo metodo' do
    objeto = PrototypedObject.new

    objeto.set_method(:nombre_metodo, proc {2})
    expect(objeto.nombre_metodo).to eq(2)

    objeto2 = PrototypedObject.new
    expect{
      objeto2.nombre_motodo
    }.to raise_error NoMethodError

  end

  it 'permite definir una nueva propiedad' do
    objeto_prototipado = PrototypedObject.new

    objeto_prototipado.set_property(:nueva_propiedad, 100)
    expect(objeto_prototipado.nueva_propiedad).to eq(100)
    expect(objeto_prototipado.nueva_propiedad = 200).to eq(200)

    objeto_prototipado2 = PrototypedObject.new
    expect{objeto_prototipado2.nueva_propiedad}.to raise_error NoMethodError
    expect{objeto_prototipado2.nueva_propiedad = 350}.to raise_error NoMethodError

  end

  it 'prototipos programaticos - parte 1' do
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)

  end

  let :padre do
    PrototypedObject.new
  end
  let :hijo do
    obj = PrototypedObject.new
    obj.set_prototype(padre)
    obj
  end

  it 'posee las propiedades de su prototipo' do
    padre.set_property :propiedad, 100
    expect(hijo.propiedad).to eq 100
  end
  it 'posee los metodos de su prototipo' do
    padre.set_method :metodo, proc{ 100 }
    expect(hijo.metodo).to eq 100
  end
  it 'no posee las propiedades de sus hijos' do
    hijo.set_property :propiedad, proc{ 100 }
    expect{padre.propiedad}.to raise_error NoMethodError
  end
  it 'no posee los metodos de sus hijos' do
    hijo.set_method :metodo, proc{ 100 }
    expect{padre.metodo}.to raise_error NoMethodError
  end

end