# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './vista_textual'
require './Controlador'
require './jugador_especulador'

module Civitas

    puts "Comienzo de programa............."
    vista = Vista_textual.new()
    nombres = []
    
    puts "Cuantos jugadores quieres?"
    num_jugadores = gets.to_i 
  
    if( num_jugadores >= 2 && num_jugadores <=4 )
       for i in 0..(num_jugadores-1)
           puts("Nombre del juagdor #{i} : ")
           nombres.push( gets.chomp )
       end
        civitas = Civitas_juego.new(nombres)
        Dado.instance.set_debug(true)
        controlador = Controlador.new(civitas, vista); 
        controlador.juega
  
    else puts("Numero de jugadores erroneo. FIN DEL PROGRAMA")
    end

end
