# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Jugador_especulador < Jugador
    @@factor_especulador = 2
    attr_reader :fianza
    
    private_class_method :new
    def initialize(fianza)
      @fianza = fianza
    end
    
    #NECESITA EXPLICACION
    def self.nuevo_especulador(jugador, fianza)
      especulador = new fianza
      especulador.copia(jugador) 
      
      especulador.propiedades.each do |titulo|
        titulo.actualiza_propietario_por_conversion(especulador)
      end
      
      return especulador
    end
    
    def convertir_especulador fianza
      puts "___________________JUGADOR YA CONVERTIDO___________________"
      return self
    end
    
    def paga_impuesto cantidad
      return super(cantidad/2)
    end
    
    def puedo_edificar_casa propiedad
      result=false
      precio = propiedad.precio_edificar
      if( puedo_gastar(precio) && ( propiedad.num_casas < (@@casas_max * @@factor_especulador) ) )
          result = true
      end
      return result;
    end
    
    def puedo_edificar_hotel propiedad
      puedo_edificar_hotell = false
      precio = propiedad.precio_edificar
      
      if( puedo_gastar(precio) && (propiedad.num_hoteles < (@@hoteles_max * @@factor_especulador)) && (propiedad.num_casas >= @@casas_por_hotel) )
          puedo_edificar_hotell = true
      end
      
      return puedo_edificar_hotell
    end
   
    def debe_ser_encarcelado
      debe_ser = super
      #             PREGUNTAR HERENCIA DDE METODOS
      puedo_pagar = puedo_gastar(@fianza)

      if(puedo_pagar)
          #PREGUNTAR
          super.paga(@fianza)   
      end

      return !puedo_pagar && debe_ser
      
    end
    
    def to_s
      devolver = super
      devolver["JUGADOR"] = "JUGADOR ESPECULADOR"
      devolver += "\n     -Fianza #{@fianza}\n"
      return devolver
    end
    
  end
end
