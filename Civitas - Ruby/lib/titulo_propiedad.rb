# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Titulo_propiedad
    
    attr_reader :precio_compra, :precio_edificar, :propietario, :nombre, :num_casas, :num_hoteles, :hipotecado
    @@factor_intereses_hipoteca=1.1
    
    def initialize(nombre, precio_base_alquiler, factor_revalorizacion, precio_base_hipoteca, precio_compra,precio_edificar)
      @nombre = nombre
      @alquiler_base = precio_base_alquiler
      @factor_revalorizacion = factor_revalorizacion
      @hipoteca_base = precio_base_hipoteca
      @precio_compra = precio_compra
      @precio_edificar = precio_edificar
      @hipotecado = false
      @num_casas = 0
      @num_hoteles = 0
      @propietario = nil
    end
    
    # Imprime el estado completo de un objeto del tipo TituloPropiedad
    def to_s
      if(@propietario == nil)
        propietario_s = "No tiene"
      else
        propietario_s = @propietario.nombre
      end
      string =  "\nTitulo Propiedad "+"\n############################################\n" + "# Nombre de la propiedad: " +  @nombre + "\n# Alquiler Base: " + @alquiler_base.to_s +  "\n# Factor de Revalorizacion: " + @factor_revalorizacion.to_s +  "\n# Hipoteca Base: " + @hipoteca_base.to_s + "\n# Precio Edificar: " + @precio_edificar.to_s + "\n# Popietario: " + propietario_s + "\n# Numero de casas: " + @num_casas.to_s + "\n# Numero de Hoteles: " + @num_hoteles.to_s + "\n# Hipotecado: " + @hipotecado.to_s
      return string
    end
    
    #  Devuelve el precio del alquiler calculado según las reglas del juego
    def get_precio_alquiler
      if( @hipotecado || propietario_encarcelado )
            return 0
      else
            return  ( @alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5)) )
      end 
    end
    
    # Devuelve el importe que se recibe al hipotecar la propiedad
    def get_importe_hipoteca
      return @hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
    end
    
    # Devuelve el importe que se obtiene al hipotecar el título multiplicado por factorInteresesHipoteca
    def get_importe_cancelar_hipoteca
      return (get_importe_hipoteca*@@factor_intereses_hipoteca)
    end
    
    #Cancela la hipoteca de su dueño si este lo paga
    def cancelar_hipoteca jugador
      result = false
      if(@hipotecado && es_este_el_propietario(jugador))
        jugador.paga(get_importe_cancelar_hipoteca)
        @hipotecado = false
        result = true
      end
      return result
    end
    
    # Devuelve si el jugador pasado es el propietario
    def es_este_el_propietario jugador
      return ( @propietario == jugador)
    end
    
    # Devuelve si esta propiedad tiene dueño
    def tiene_propietario
      return @propietario != nil
    end
    
    # Se paga el alquiler si el jugador no es el propietario y pertenece a otro
    def tramitar_alquiler (jugador)
      if( tiene_propietario && !es_este_el_propietario(jugador) )
        jugador.paga_alquiler( get_precio_alquiler )
        @propietario.recibe( get_precio_alquiler )
      end
    end
    
    #Hipoteca la propiedad devolviendole al propietario el importe por ello
    def hipotecar jugador
      result = false
      if(!@hipotecado && es_este_el_propietario(jugador))
        jugador.recibe(get_importe_hipoteca)
        @hipotecado = true
        result = true
      end
      return result
    end
    
    # Devuelve si el propietario esta encarcelado
    def propietario_encarcelado
      return (tiene_propietario && @propietario.encarcelado)
    end
    
    # Devuelve la cantidad total de casas y hoteles
    def cantidad_casas_hoteles
      return ( @num_casas + @num_hoteles )
    end
    
    # Calcula el precio de venta
    def get_precio_venta
       return ( @precio_compra + ((( @num_casas + @num_hoteles ) * @precio_edificar) * @factor_revalorizacion))
    end
    
    # Se derruyen las casas si hay las suficientes para ello
    def derruir_casas (n , jugador)
        if( es_este_el_propietario(jugador) && ( n<=@num_casas ) )
            @num_casas -= n
            return true
        else
            return false
        end
    end
    
    # Se derruyen los hoteles si hay las suficientes para ello
    def derruir_hoteles (n , jugador)
        if( es_este_el_propietario(jugador) && ( n<=@num_hoteles ) )
            @num_hoteles -= n
            return true
        else
            return false
        end
    end
    
    # Se cambia al propietario que se pasa por argumento
    def actualiza_propietario_por_conversion jugador
      @propietario = jugador
    end
    
    # El propietario ingresa el precio de venta y se desvincula de la propiedad
    def vender jugador
      if(es_este_el_propietario(jugador) && !@hipotecado)
        jugador.recibe(get_precio_venta)
        actualiza_propietario_por_conversion(nil) 
        derruir_casas(@num_casas, jugador)
        derruir_hoteles(@num_hoteles, jugador)
        return true
      else
        return false
      end
    end
    
    #Si la propiedad no tiene propietario el jugador paga la propiedad
    def comprar jugador
      if(!tiene_propietario)
        @propietario = jugador
        @propietario.paga(@precio_compra)
        return true
      else
        return false
      end
    end
    
    #Si es el propietario se construye una casa
    def construir_casa jugador
      if(es_este_el_propietario(jugador))
        jugador.paga(@precio_edificar)
        @num_casas += 1
        return true
      else
        return false
      end
    end
    
    #Si es el propietario se construye un hotel
    def construir_hotel jugador
      if(es_este_el_propietario(jugador))
        jugador.paga(@precio_edificar)
        @num_hoteles += 1
        return true
      else
        return false
      end
    end
    
  end
end
