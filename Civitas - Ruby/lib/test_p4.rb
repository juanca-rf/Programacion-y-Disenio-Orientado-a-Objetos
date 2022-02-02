# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './vista_textual'
require './Controlador'
require './jugador_especulador'
require './jugador'
require './titulo_propiedad'

module Civitas
  puts "TEST P4 __________________________________"
  
  jugador = Jugador.new("Paco")
  jugador.propiedades << Titulo_propiedad.new("escarbuto", 0, 0, 0, 0, 0)

  puts "ANTES"
  puts jugador.to_s

  puts "DESPUES"
  jugador = Jugador_especulador.nuevo_especulador(jugador, 50)
  puts jugador.to_s
  puts jugador.propiedades[0].to_s

end
