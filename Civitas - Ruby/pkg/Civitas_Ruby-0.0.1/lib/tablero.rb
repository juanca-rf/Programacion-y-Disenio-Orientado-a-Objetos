# encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Civitas
  class Tablero
    attr_reader :numCasillaCarcel
    attr_reader :porSalida
    attr_reader :casillas
    
    
    def initialize (carcel)
      if carcel >= 1
        @numCasillaCarcel = carcel
      else
        @numCasillaCarcel = 1
      end
      
      @casillas = []
      @casillas.push( Casilla.new("Salida") )
      @porSalida = 0
      @tieneJuez = false      
    end
    
    #Comprobacion de de la integridad del tablero
    def correcto
      return ( (@casillas.length > @numCasillaCarcel) && @tiene_juez )
    end
    
    #Comprobacion de acceso a casilla 
    #Tiene distinto nombre ya que en ruby no se puede tener dos iguales
    def correcto_num numCasilla
      return ( correcto && (numCasilla >= 0) && (numCasilla < @casillas.length) )
    end
    
    #Decrementa el valor de por_salida si es mayor que 0 y lo devuelve
    def get_por_salida
      if @por_salida>0
        @por_salida = @por_salida-1
      end
      return (@por_salida + 1)
    end
    
    #Añade casilla, y si procede, tambien la de carcel
    def añade_casilla casilla
      if @numCasillaCarcel == @casillas.length
        carcel = Casilla.new("Carcel")
        @casillas.push(carcel)
      end
      
      @casillas.push(casilla) 
    
      if @num_casilla_carcel == @casillas.length
        carcel = Casilla.new("Carcel")
        @casillas.push(carcel)
      end
    end
    
    #Añade un juez si no existe
    def añade_juez
      if !@tieneJuez
        juez = Casilla.new("Juez")
        @casillas.push(juez)
        @tiene_juez = true
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
          final = final % @casillas.lenght
          @por_salida = @por_salida + 1
        end
        return final
      end
    end
    
    #Emula una tirada para saber cuanto falta para llegar a la posicion deseada
    def calcular_tirada(origen, destino)
      tirada = origen - destino
      if tirada < 0
        tirada = tirada + @casillas.lenght 
      end
      return tirada
    end
    
  end
end