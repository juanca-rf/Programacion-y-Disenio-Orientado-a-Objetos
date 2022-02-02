# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla_impuesto < Casilla
    def initialize(nombre, importe)
      super
    end
    
    #El jugador paga el impuesto que indique la casilla
    def recibe_jugador(iactual, todos)
      if jugador_correcto(iactual, todos)
        informe(iactual, todos)
        todos[iactual].paga_impuesto(@importe)
      end
    end
    
    def to_s
      return super + "\nCantidad a pagar: " + @importe
    end
  end
end
