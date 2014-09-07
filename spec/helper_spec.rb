require 'rspec'
require_relative '../lib/prototyped_object'

describe 'tadp' do

  it 'definir nuevo metodo' do

    objeto = PrototypedObject.new
    objeto.set_method(:nombre_metodo, proc {2})

    expect(objeto.nombre_metodo).to eq(2)

    objeto2 = PrototypedObject.new

    expect{
      objeto2.nombre_motodo
    }.to raise_error NoMethodError

  end

  it 'definir nueva propiedad' do

    objeto_prototipado = PrototypedObject.new
    objeto_prototipado.set_property(:nueva_propiedad, 100)

    expect(objeto_prototipado.nueva_propiedad).to eq(100)

    expect(objeto_prototipado.nueva_propiedad = 200).to eq(200)

    objeto_prototipado2 = PrototypedObject.new

    expect{objeto_prototipado2.nueva_propiedad}.to raise_error NoMethodError

    expect{objeto_prototipado2.nueva_propiedad = 350}.to raise_error NoMethodError

  end

end