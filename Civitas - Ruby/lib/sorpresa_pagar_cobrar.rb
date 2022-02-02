# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_pagar_cobrar < Sorpresa
    public_class_method :new
    def initialize(valor, texto)
      super texto
      @valor = valor
    end
    
    #Aplica la carta de pagar o cobrar con el valor de la carta
    def aplicar_a_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor)
      end
    end
    
    def to_s
      return super + "\nValor: " + @valor
    end
    
  end
end
