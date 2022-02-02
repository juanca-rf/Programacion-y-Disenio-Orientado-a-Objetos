# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './Sorpresa'

module Civitas
  class Casilla_sorpresa < Casilla
    
    def initialize(mazo,nombre)
      super(nombre)
      @mazo = mazo
    end
    
    #Recibe sorpresa jugador
    def recibe_jugador(iactual, todos)
      if(jugador_correcto(iactual, todos))
        @sorpresa = @mazo.siguiente
        informe(iactual, todos)
        @sorpresa.aplicar_a_jugador(iactual, todos)
      end
    end
    
  end
end
