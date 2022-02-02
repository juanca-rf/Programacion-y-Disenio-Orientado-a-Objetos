# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Casilla
    att_reader :nombre, :titulo_propiedad
    
    def initialize *args
      @importe          = 0
      @nombre           = ""
      @titulo_propiedad = nil
      @mazo             = nil
      @sorpresa         = nil
      @tipo             = nil
      @carcel           = nil
      
      if args[0].instance_of? String #Constructor por nombre
        case args[0] # NOMBRE
        when "Salida", "salida"
          @tipo = Operaciones_juego::DESCANSO
        when "Cárcel", "Carcel", "cárcel", "carcel"
          @tipo = Operaciones_juego::DESCANSO
        when "Juez", "juez"
          @tipo = Operaciones_juego::JUEZ
        when "Parking", "parking"
          @tipo = Operaciones_juego::DESCANSO
        else
          @tipo = Operaciones_juego::CALLE
        end
        
      elsif args[0].is_a?(TituloPropiedad) #Constructor por tipoPropiedad
        @titulo_propiedad = args[0]
        @nombre  = args[0].getNombre
        @importe = args[0].getPrecioCompra
        @tipo    = Operaciones_juego::CALLE
        
      elsif args[0].kind_of? Float #Constructor IMPUESTO
        @importe = args[0] #Cantidad
        @nombre  = args[1] #Nombre string
        @tipo    = Operaciones_juego::IMPUESTO
        
      elsif args[0].kind_of? Integer #Constructor CARCEL
        @carcel  = args[0] #numcasillacarcel
        @nombre  = args[1] #Nombre string
        @tipo    = Operaciones_juego::DESCANSO
        
      elsif args[0].is_a? MazoSorpesas #Constructor SORPRESA
        @mazo    = args[0]
        @nombre  = args[1] #String nombre
        @tipo    = Operaciones_juego::SORPESA
      end
      
    end
    
    #Informa qué jugador ha caido en qué casilla    
    def informe(actual, todos)
      Diario.instance.ocurre_evento("Ha caido en la casilla " + + @nombre + " el jugador: " + todos[actual].nombre)
    end
    
    #Comprueba si el jugador es correcto
    def jugador_correcto(iactual, todos)
      if(iactual < todos.length && iactual >= 0)
        return true
      else
        return false
      end
    end
    
    #No implementar aun***************************************
    def recibe_jugador(iactual, todos)
      
    end
    
    #No implementar aun***************************************
    def recibe_jugador_calle(iactual, todos)
      
    end
    
    #El jugador paga el impuesto que indique la casilla
    def recibe_jugador_impuesto(iactual, todos)
      if jugador_correcto(iactual, todos)
        informe(iactual, todos)
        todos[iactual].paga_impuesto(@importe)
      end
    end
    
    #Se encarcela al jugador actual
    def recibe_jugador_juez(iactual, todos)
      if jugador_correcto(iactual, todos)
        informe(iactual, todos)
        todos[iactual].mover_a_casilla(@carcel)
        todos[iactual].encarcelar(@carcel)
      end
    end
    
    #No implementar aun***************************************
    def recibe_jugador_sorpresa(iactual, todos)
      
    end
    
    #Imprime la información de la casilla
    def to_string
      if(@titulo_propiedad != nil)
        string = @titulo_propiedad.toString
        else if(@tipo == Civitas::TipoCasilla::IMPUESTO)
          string = "\n" + @nombre + "\nCantidad a pagar: " + @importe
        else
          string = "\n" + @nombre
        end
      end 
      return string
    end   
    
    
  end
end