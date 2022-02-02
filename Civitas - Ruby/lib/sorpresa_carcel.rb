# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_carcel < Sorpresa
    public_class_method :new
    def initialize tablero
      @tablero = tablero
    end
    
    #Aplica la carta de ir a la carcel
    def aplicar_a_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].encarcelar(@tablero.num_casilla_carcel)
      end
    end
    
  end
end
