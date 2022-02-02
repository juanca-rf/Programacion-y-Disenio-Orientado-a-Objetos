# encoding:utf-8

require './casilla'
require './Casilla_juez'

module Civitas
  class Tablero
    attr_reader :num_casilla_carcel
    attr_reader :por_salida
    attr_reader :casillas
    
    
    def initialize (carcel)
      if carcel >= 1
        @num_casilla_carcel = carcel
      else
        @num_casilla_carcel = 1
      end
      
      @casillas = []
      @casillas.push( Casilla.new("Salida") )
      @por_salida = 0
      @tieneJuez = false      
    end
    
    #Comprobacion de de la integridad del tablero
    def correcto
      return ( (@casillas.length > @num_casilla_carcel) && @tiene_juez )
    end
    
    #Comprobacion de acceso a casilla 
    #Tiene distinto nombre ya que en ruby no se puede tener dos iguales
    def correcto_num numCasilla
      return ( correcto && (numCasilla < @casillas.length) )
    end
    
    #Decrementa el valor de por_salida si es mayor que 0 y lo devuelve
    def get_por_salida
      if @por_salida>0
        @por_salida -= 1
        return (@por_salida + 1)
      else
        return 0
      end 
    end
    
    #Añade casilla, y si procede, tambien la de carcel
    def añade_casilla casilla
      if @num_casilla_carcel == @casillas.length
        @casillas.push(Casilla.new("Carcel"))
      end
      @casillas.push(casilla) 
      if @num_casilla_carcel == @casillas.length
        @casillas.push(Casilla.new("Carcel"))
      end
    end
    
    #Añade un juez si no existe
    def añade_juez
      if !@tieneJuez
        @tiene_juez = true
        #añade_casilla( Casilla.new(@num_casilla_carcel,"Juez"))
        #Creo que de esta forma esta mejor que arriba
        @casillas.push(Casilla_juez.new(@num_casilla_carcel,"Juez"))
      end
    end
    
    #Devuelve la casilla solicitada si esta en el rango de casillas existentes
    def get_casilla numCasilla
      if correcto_num(numCasilla)
        return @casillas[numCasilla]
      else
        return nil 
      end
    end
    
    #Calcula la nueva posicion en relacion al origen de la tirada 
    def nueva_posicion(actual, tirada)
      if !correcto
        return -1
      else
        final = actual + tirada
        if final > @casillas.length
          @por_salida += 1
        end
        return (final % @casillas.length)
      end
    end
    
    #Emula una tirada para saber cuanto falta para llegar a la posicion deseada
    def calcular_tirada(origen, destino)
      tirada = origen - destino
      if tirada < 0
        tirada = tirada + @casillas.length 
      end
      return tirada
    end
    
    def print_casillas
      @casillas.each do |x|
        puts "|||||||||||||||||||||||||||||||||||||||||||||||||||||||\n" + x.to_s
      end
    end
    
  end
end