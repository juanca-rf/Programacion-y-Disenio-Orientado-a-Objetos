# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_jugador < Sorpresa
    public_class_method :new
    def initialize(valor, texto)
      super texto
      @valor = valor
    end
    
    #Aplica la carta de pagar al jugador por parte de los demas jugadores
    def aplicar_a_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        sorpresa1 = Sorpresa_pagar_cobrar.new( @valor * -1, "")
        sorpresa2 = Sorpresa_pagar_cobrar.new( (@valor * ((todos.length) - 1)), "")
        for i in (0..todos.length)
          if i != actual
            sorpresa1.aplicar_a_jugador(i,todos)
          else
            sorpresa2.aplicar_a_jugador(i,todos)
          end
        end
      end
    end
    
    def to_s
      return super + "\nValor: " + @valor
    end
    
  end
end
