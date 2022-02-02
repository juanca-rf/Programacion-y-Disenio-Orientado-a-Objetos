# encoding:utf-8
require './dado'

module Civitas
  class Mazo_sorpresa
    
    #Metodo privado de inicializacion
    private
    def init
      @sorpresas = []
      @cartas_especiales = []
      @barajada = false
      @usadas = 0
    end
    
    public
    def initialize(d=false)
      @debug = d
      init
      if @debug
        Diario.instance.ocurre_evento("El modo debug está activo")
      end
    end
  
    #Inserta una carta si no esta el mazo en uso
    def al_mazo s
      if !@barajada
        @sorpresas.push(s)
      end
    end
    
    #Sacar una carta del mazo
    def siguiente
      if ((!@barajada || @usadas == @sorpresas.length) && !@debug)  #Se baraja si se han usado todas o no se ha barajado
        @sorpresas.shuffle
        @usadas = 0
        @barajada = true
      end

      @usadas += 1 
      @ultima_sorpresa = @sorpresas[0]
      @sorpresas.shift
      @sorpresas.push(@ultima_sorpresa)

      return @ultima_sorpresa
    end
    
    def inhabilitar_carta_especial sorpresa
      if @sorpresas.include?(sorpresa)
        @sorpresas.delete[sorpresa]
        @cartas_especiales.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha inhabilitado una carta especial")
      end
    end
  
    def habilitar_carta_especial sorpresa 
      if @cartas_especiales.include?(sorpresa)
        @cartas_especiales.delete[sorpresa]
        @sorpresas.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha habilitado una carta especial")
      end
    end
    
    def get_sorpresas i
      return @sorpresas[i]
    end
    
    def get_tam_sorpresas
      return @sorpresas.length
    end
    
  end
end