# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Civitas
  class Sorpresa
    def initialize  (tipo, mazotablero, *tercero) 
      @valor = -1
      @mazo = nil
      @tablero = nil
      @tipo = tipo
      
      if mazotablero.is_a?(MazoSorpresa) #Evitar ir carcel
        self.new_evitar_carcel  mazotablero
        
      elsif mazotablero.is_a?(Tablero) # ir carcel u otra casilla
        if tercero.size == 0 || tercero == nil
          self.new_ir_carcel  mazotablero 
        else
          self.new_ir_casilla(mazotablero, tercero[0], tercero [1])
        end
        
      else # Resto de sorpresas
        self.new_resto_sorpresas(mazotablero, tercero[0])
      end
      
    end
    
    #Para evitar ir a la carcel
    def self.new_evitar_carcel(mazo)
      @mazo = mazo
    end
    
    #Para ir a la carcel
    def self.new_ir_carcel(tablero)
      @tablero = tablero
    end

    #Para ir a otra casilla
    def self.new_ir_casilla(tablero, valor, texto)
      @tablero = tablero
      @valor = valor
      @texto = texto
    end
    
    #Para el resto de sorpresas
    def self.new_resto_sorpresas(valor, texto)
      @valor = valor
      @texto = texto
    end
    
    #Comprueba si el primer parametro es un indice valido para acceder a los elementos del segundo
    def jugador_correcto(actual, todos)
      if(actual < todos.length && actual >= 0)
        return true
      else
        return false
      end
    end
    
    #Informa al diario que se está aplicando una sorpresa
    def informe(actual, todos)
      Diario.instance.ocurre_evento("Se está aplicando una sorpresa a" + todos[actual].nombre)
    end
    
    #Llama al metodo aplicarAJugador oportuno segun el tipo de sorpresa que sea
    def aplicar_jugador(actual, todos)
      case @tipo
        when Civitas::TipoSorpresa::IRCARCEL
          aplicar_a_jugador_ir_carcel(actual, todos)
        when Civitas::TipoSorpresa::IRCASILLA
          aplicar_a_jugador_ir_a_casilla(actual, todos)
        when Civitas::Tipo_sorpresa::PAGAR_COBRAR
          aplicar_a_jugador_pagar_cobrar(actual, todos)
        when Civitas::Tipo_sorpresa::POR_CASA_HOTEL
          aplicar_a_jugador_por_casa_hotel(actual, todos)
        when Civitas::Tipo_sorpresa::POR_JUGADOR
          aplicar_a_jugador_por_jugador(actual, todos)
        else 
          aplicar_a_jugador_salir_carcel(actual, todos)
      end
    end
    
    #Aplica la carta de ir a la carcel
    def aplicar_a_jugador_ir_carcel(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].encarcelar(@tablero.numCasillaCarcel)
      end
    end
    
    #Aplica la carta de ir a la casilla especificada por la carta
    def aplicar_a_jugador_ir_a_casilla(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].encarcelar(@tablero.numCasillaCarcel)
        casilla_act = todos[actual].numCasillaActual
        tirada = @tablero.calcularTirada(casilla_act, @valor)
        nueva_pos = @tableto.nuevaPosicion(casilla_act, tirada)
        todos[actual].mover_a_casilla(nueva_pos)
        @tablero[nueva_pos].recibeJugador(actual, todos)
      end
    end
    
    #Aplica la carta de pagar o cobrar con el valor de la carta
    def aplicar_a_jugador_pagar_cobrar(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modifica_saldo(@valor)
      end
    end
    
    #Aplica la carta de pagar por casas y hoteles
    def aplicar_a_jugador_por_casa_hotel(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modifica_saldo(@valor * (todos[actual].cantidad_casas_hoteles))
      end
    end
    
    #Aplica la carta de pagar al jugador por parte de los demas jugadores
    def aplicar_a_jugador_por_jugador(actual, todos)
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        sorpresa1 = new_resto_sorpresas(Civitas::TipoSorpresa::PAGARCOBRAR, @valor * -1, "")
        sorpresa2 = new_resto_sorpresas(Civitas::TipoSorpresa::PAGARCOBRAR, @valor * (todos.lenght -1), "")
        
        for i in (0..todos.lenght)
          if i != actual
            sorpresa1.aplicar_a_jugador_pagar_cobrar(i,todos)
          else
            sorpresa2.aplicar_a_jugador_pagar_cobrar(i,todos)
          end
        end
      end
    end
    
    #Aplica la carta para salir de la carcel
    def aplicar_a_jugador_salir_carcel(actual, todos)
      contador = 0
      if(jugador_correcto(actual, todos))
        informe(actual, todos)
        for i in (0..todos.lenght)
          if(todos[i].tiene_salvoconducto)
            contador += 1
          end
        end
        if(contador == 0)
          sorpresa = new_evitar_carcel(Civitas::TipoSorpresa::SALIRCARCEL, @mazo)
          todos[actual].obtener_salvoconducto(sorpresa)
          sorpresa.salir_del_mazo          
        end
      end
    end
    
    #Si el tipo de sorpresa es evitar la carcel, se inhabilita en el mazo de cartas sorpresa
    def salir_del_mazo
      if(@tipo = Civitas::TipoSorpresa::SALIRCARCEL)
        @mazo.inhabilitar_carta_especial(self)
      end
    end
    
    #Si el tipo de sorpresa es evitar la carcel, se habilita en el mazo de cartas sorpresa
    def usada
      if(@tipo = Civitas::TipoSorpresa::SALIRCARCEL)
        @mazo.habilitar_carta_especial(self)
      end
    end
    
    #Devuelve el nombre de la sorpresa
    def to_string
      string = "\nNombre de la sorpresa: " + @tipo.nombre 
      return string
    end
    
  end
end