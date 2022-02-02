# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_salir_carcel < Sorpresa
    public_class_method :new
    def initialize mazo
      @mazo = mazo
    end
    
    #Aplica la carta para salir de la carcel
    def aplicar_a_jugador(actual, todos)
      salvocond = false
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos.each do |jugador_actual|
          if(jugador_actual.tiene_salvoconducto)
            salvocond = true
          end
        end
        if(salvocond)
          sorpresa = Sorpresa_salir_carcel.new(@mazo)
          todos[actual].obtener_salvoconducto(sorpresa)
          sorpresa.salir_del_mazo          
        end
      end
    end
    
    #Si el tipo de sorpresa es evitar la carcel, se inhabilita en el mazo de cartas sorpresa
    def salir_del_mazo
      @mazo.inhabilitar_carta_especial(self)
    end
    
    #Si el tipo de sorpresa es evitar la carcel, se habilita en el mazo de cartas sorpresa
    def usada
      @mazo.habilitar_carta_especial(self)
    end
    
  end
end