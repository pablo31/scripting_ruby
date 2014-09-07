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

  it 'prototipos programaticos - parte 1' do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a,
                        proc {
                            |otro_guerrero|
                          if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
                            otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                          end
                        });
    guerrero.set_method(:recibe_danio, proc {|danio|self.energia = self.energia - danio}) # originalmente decia {...}
    otro_guerrero = guerrero.clone #clone es un metodo que ya viene definido en Ruby
    guerrero.atacar_a otro_guerrero
    expect(otro_guerrero.energia).to eq(80)

  end

end