# encoding:utf-8

#require './Tipo_casilla'
require './mazo_sorpresas'
require './Operaciones_juego'

module Civitas
  class Casilla
    attr_reader :nombre
    
    def initialize( nombre, importe = -1)
      @nombre = nombre
      @importe = importe
    end
   
    #Informa qué jugador ha caido en qué casilla    
    def informe(actual, todos)
      Diario.instance.ocurre_evento("Ha caido en la casilla " +  @nombre + " el jugador: " + todos[actual].nombre)
    end
    
    #Comprueba si el jugador es correcto
    def jugador_correcto(iactual, todos)
      if(iactual < todos.length && iactual >= 0)
        return true
      else
        return false
      end
    end
    
    def recibe_jugador(indice_jugador_actual, jugadores)
      #Overrided
    end

    #Imprime la información de la casilla
    def to_s
      return "\n" + @nombre 
    end   
   
  end
end