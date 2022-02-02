# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_casilla < Sorpresa
    public_class_method :new
    def initialize(tablero, valor, texto)
      super texto
      @tablero = tablero
      @valor = valor
    end
    
    #Aplica la carta de ir a la casilla especificada por la carta
    def aplicar_a_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        casilla_act = todos[actual].num_casilla_actual
        tirada = @tablero.calcular_tirada(casilla_act, @valor)
        nueva_pos = @tablero.nueva_posicion(casilla_act, tirada)
        todos[actual].mover_a_casilla(nueva_pos)
        @tablero.get_casilla(nueva_pos).recibe_jugador(actual, todos)
      end
    end
    
    def to_s
      return super + "\nValor: " + @valor
    end
    
  end
end
