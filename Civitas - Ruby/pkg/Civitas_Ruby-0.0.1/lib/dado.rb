# encoding:utf-8

require 'singleton' #Para poder utilizarlo es necesario incluirlo de esta manera, si no es imposible iniciarlo
require './diario'
module Civitas
  class Dado
    include Singleton
    
    attr_reader :ultimoResultado
    @@salida_carcel=5
    
    
    def initialize
      @ultimoResultado = 0
      @debug = false
    end
    
    
    def tirar
      @ultimoResultado = 1
      if !@debug
        @ultimoResultado = (rand(6)+1)
      end
      return @ultimoResultado
    end
    
    
    def salgoDeLaCarcel
      return tirar == @SalidaCarcel
    end
    
    
    def quienEmpieza(numJugadores)
      @ultimoResultado = rand(numJugadores); 
      return(@ultimoResultado);
    end
    
    
    def setDebug(d)
      @debug = d
      if @debug
        Diario.instance.ocurre_evento("El modo debug se ha activado")
      else
        Diario.instance.ocurre_evento("El modo debug se ha desactivado")
      end
    end    
    
  end
end