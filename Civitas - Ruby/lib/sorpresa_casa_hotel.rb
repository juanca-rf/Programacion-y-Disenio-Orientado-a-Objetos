# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_casa_hotel < Sorpresa
    public_class_method :new
    def initialize(valor, texto)
      super texto
      @valor = valor
    end
    
    #Aplica la carta de pagar por casas y hoteles
    def aplicar_a_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor * (todos[actual].cantidad_casas_hoteles))
      end
    end
    
    def to_s
      return super + "\nValor: " + @valor
    end
    
  end
end
