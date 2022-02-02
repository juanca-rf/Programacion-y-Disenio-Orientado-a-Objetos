# encoding:utf-8

require 'singleton' #Para poder utilizarlo es necesario incluirlo de esta manera, si no es imposible iniciarlo
require './diario'
module Civitas
  class Dado
    include Singleton
    
    attr_reader :ultimo_resultado
    @@salida_carcel=5
    
    
    def initialize
      @ultimo_resultado = 0
      @debug = false
    end
    
    
    def tirar
      @ultimo_resultado = 1
      if !@debug
        @ultimo_resultado = (rand(6)+1)
      end
      return @ultimo_resultado
    end
    
    
    def salgo_de_la_carcel
      return tirar >= @@salida_carcel
    end
    
    
    def quien_empieza(numJugadores)
      @ultimo_resultado = rand(numJugadores); 
      return(@ultimo_resultado);
    end
    
    
    def set_debug(d)
      @debug = d
      if @debug
        Diario.instance.ocurre_evento("El modo debug se ha activado")
      else
        Diario.instance.ocurre_evento("El modo debug se ha desactivado")
      end
    end    
    
  end
end