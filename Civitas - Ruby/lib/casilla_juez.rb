# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla_juez < Casilla
    def initialize(casilla_carcel, nombre)
      super(nombre)
      @carcel = casilla_carcel
    end
    
    #Se encarcela al jugador actual
    def recibe_jugador(iactual, todos)
      if jugador_correcto(iactual, todos)
        informe(iactual, todos)
        todos[iactual].encarcelar(@carcel)
      end
    end
    
  end
end
