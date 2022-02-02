# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class TituloPropiedad
    
    attr_reader :precioCompra, :precioEdificar, :propietario, :nombre, :numCasas, :numHoteles, :hipotecado
    @@factor_intereses_hipoteca=1.1
    
    def initialize(nombre, precio_base_alquiler, factor_revalorizacion, precio_base_hipoteca, precio_compra,precio_edificar)
      @nombre = nombre
      @alquilerBase = precio_base_alquiler
      @factorRevalorizacion = factor_revalorizacion
      @hipotecaBase = precio_base_hipoteca
      @precioCompra = precio_compra
      @precioEdificar = precio_edificar
      @hipotecado = false
      @numCasas = 0
      @numHoteles = 0
      @propietario = nil
    end
    
    # Imprime el estado completo de un objeto del tipo TituloPropiedad
    def to_s
      string =  "Nombre de la propiedad: " + @nombre + 
                "\nAlquiler Base: " + @alquilerBase + 
                "\nFactor de Revalorizacion: " + @factorRevalorizacion + 
                "\nHipoteca Base: " + @hipotecaBase + 
                "\nPrecio Edificar: " + @precioEdificar + 
                "\nPopietario: " + @propietario.toString() + 
                "\nNumero de casas: " + @numCasas + 
                "\nNumero de Hoteles: " + @numHoteles + 
                "\nHipotecado: " + @hipotecado
      return string
    end
    
    #  Devuelve el precio del alquiler calculado según las reglas del juego
    def getPrecioAlquiler
      if( @hipotecado || propietarioEncarcelado )
            return 0
      else
            return  ( @alquilerBase*(1+(@numCasas*0.5)+(@numHoteles*2.5)) )
      end 
    end
    
    # Devuelve el importe que se recibe al hipotecar la propiedad
    def getImporteHipoteca
      return @hipotecaBase*(1+(@numCasas*0.5)+(@numHoteles*2.5))
    end
    
    # Devuelve el importe que se obtiene al hipotecar el título multiplicado por factorInteresesHipoteca
    def getImporteCancelarHipoteca
      return (getImporteHipoteca*@@factor_intereses_hipoteca)
    end
    
    # Devuelve si el jugador pasado es el propietario
    def esEsteElPropietario jugador
      return ( @propietario == jugador)
    end
    
    # Devuelve si esta propiedad tiene dueño
    def tienePropietario
      return @propietario != nil
    end
    
    # Se paga el alquiler si el jugador no es el propietario y pertenece a otro
    def tramitarAlquiler (jugador)
      if( tienePropietario && !esEsteElPropietario(jugador) )
        jugador.pagaAlquiler( getPrecioAlquiler )
        @propietario.recibe( alquiler )
      end
    end
    
    # Devuelve si el propietario esta encarcelado
    def propietarioEncarcelado
      return @propietario.encarcelado
    end
    
    # Devuelve la cantidad total de casas y hoteles
    def cantidadCasasHoteles
      return ( @numCasas + @numHoteles )
    end
    
    # Calcula el precio de venta
    def getPrecioVenta
       return ( @precioCompra + ((( @numCasas + @numHoteles ) * @precioEdificar) * @factorRevalorizacion))
    end
    
    # Se derruyen las casas si hay las suficientes para ello
    def derruirCasas (n , jugador)
        if( esEsteElPropietario(jugador) && ( n<=@numCasas ) )
            @numCasas -= n
            return true
        else
            return false
        end
    end
    
    # Se derruyen los hoteles si hay las suficientes para ello
    def derruirHoteles (n , jugador)
        if( esEsteElPropietario(jugador) && ( n<=@numHoteles ) )
            @numHoteles -= n
            return true
        else
            return false
        end
    end
    
    # Se cambia al propietario que se pasa por argumento
    def actualizaPropietarioPorConversion jugador
      @propietario = jugador
    end
    
    # El propietario ingresa el precio de venta y se desvincula de la propiedad
    def vender jugador
      if(esEsteElPropietario(jugador) && !@hipotecado)
        jugador.recibe(getPrecioVenta)
        actualizaPropietarioPorConversion(nil) 
        derruirCasas(@numCasas, jugador)
        derruirHoteles(@numHoteles, jugador)
        return true
      else
        return false
      end
    end
    
=begin
    Implementar en siguiente practica
    boolean cancelarHipoteca (Jugador jugador)
    boolean hipotecar (Jugador jugador)
    boolean comprar(Jugador jugador)
    boolean construirCasa( Jugador jugador)
    boolean construirHotel( Jugador jugador)
=end
    
    
    
  end
end
