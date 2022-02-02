# encoding:utf-8

require './Jugador'
require './gestor_estados'
require './dado'
require './mazo_sorpresas'
require './tablero'
require './Titulo_propiedad'
require './Sorpresa'
require './Casilla_calle'
require './Casilla_sorpresa'
require './Casilla_impuesto'
require './Casilla_sorpresa'
require './Sorpresa_pagar_cobrar'
require './Sorpresa_carcel'
require './Sorpresa_casa_hotel'
require './Sorpresa_casilla'
require './Sorpresa_jugador'
require './Sorpresa_salir_carcel'
require './Sorpresa_convertir_especulador'

require './Estados_juego'

module Civitas
  class Civitas_juego
    @@num_carcel = 6
    
    def initialize nombres
      @estado = Estados_juego::INICIO_TURNO
      @jugadores = Array.new
      nombres.each do |nombre|
        @jugadores.push( Jugador.new(nombre) )
      end
      
      @gestor_estados = Gestor_estados.new
      @gestor_estados.estado_inicial
      @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.size)
      @mazo = Mazo_sorpresa.new
      inicializar_tablero @mazo
      inicializar_mazo_sorpresas @tablero
    end
    
    #No implementar aun***************************************hecho
    def avanza_jugador
        jugador_actual = get_jugador_actual
        
        posicion_actual = jugador_actual.num_casilla_actual
        
        tirada = Dado.instance.tirar
        
        posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
        
        casilla = @tablero.get_casilla(posicion_nueva)
        
        contabilizar_pasos_por_salida(jugador_actual)
        
        jugador_actual.mover_a_casilla(posicion_nueva)
        
        casilla.recibe_jugador(@indice_jugador_actual, @jugadores)
        
        contabilizar_pasos_por_salida(jugador_actual)
    end
    
    #Llama a cancelarhipoteca del jugador
    def cancelar_hipoteca ip
      return @jugadores[@indice_jugador_actual].cancelar_hipoteca(ip)
    end
    
    #No implementar aun***************************************hecho
    def comprar
        jugador_actual = get_jugador_actual
        num_casilla_actual = jugador_actual.num_casilla_actual
        casilla = @tablero.get_casilla(num_casilla_actual)
        titulo = casilla.titulo_propiedad #mirar src
        return jugador_actual.comprar(titulo)
    end
    
    #Llama a construirCasa del jugador
    def construir_casa ip
      return @jugadores[@indice_jugador_actual].construir_casa(ip)
    end
    
    #Llama a construirHotel del jugador
    def construir_hotel ip
      return @jugadores[@indice_jugador_actual].construir_hotel(ip)
    end
    
    #El jugador cobra por todas las veces que ha pasado por la casilla de salida
    def contabilizar_pasos_por_salida jugador_actual
      while @tablero.get_por_salida > 0
        jugador_actual.pasa_por_salida
      end
    end
    
    #Indica si se acaba el juego (cuando un jugador esté en bancarrota)
    def final_del_juego
      fin = false
      @jugadores.each do |jugador|
        if jugador.en_bancarrota
          fin = true
        end
      end
      return fin
    end
    
    #Devuelve la casilla actial del jugador
    def get_casilla_actual
      return @tablero.get_casilla( @jugadores[@indice_jugador_actual].num_casilla_actual )
    end
    
    #Devuelve el jugador actual
    def get_jugador_actual
      return @jugadores[@indice_jugador_actual]
    end
    
    #Llama al metodo hipotecar de Jugador
    def hipotecar ip
      return @jugadores[@indice_jugador_actual].hipotecar(ip)
    end
    
    #Muestra por pantalla la informacion asociada al jugador
    def info_jugador_texto
      return @jugadores[@indice_jugador_actual].to_s
    end
    
    #Crea las cartas sorpresa y las añade al mazo
    def inicializar_mazo_sorpresas tablero
      #PAGARCOBRAR
      @mazo.al_mazo(Sorpresa_pagar_cobrar.new( 200, "Recibe 200 por herencia"  ) )
      @mazo.al_mazo(Sorpresa_pagar_cobrar.new( -150, "Paga 150 por impuesto de herencia"))
      #IRCASILLA
      @mazo.al_mazo(Sorpresa_casilla.new( tablero, 7, "Vas a la calle C7"))
      @mazo.al_mazo(Sorpresa_casilla.new( tablero, 12, "Vas a la calle C12"))
      @mazo.al_mazo(Sorpresa_casilla.new( tablero, tablero.num_casilla_carcel, "Vas a la carcel"))
      #PORCASAHOTEL
      @mazo.al_mazo(Sorpresa_casa_hotel.new( 300, "Recibe 300 por tener casa/hotel"))
      @mazo.al_mazo(Sorpresa_casa_hotel.new( -300, "Paga 300 por tener casa/hotel"))
      #PORJUGADOR
      @mazo.al_mazo(Sorpresa_jugador.new( 100, "Recibe 100 del jugador"))
      @mazo.al_mazo(Sorpresa_jugador.new( -100, "Paga 100 al jugador"))
      #SALIRCARCEL
      @mazo.al_mazo(Sorpresa_salir_carcel.new( @mazo))
      #IRCARCEL
      @mazo.al_mazo(Sorpresa_carcel.new( tablero))
      #conversion
      @mazo.al_mazo(Sorpresa_convertir_especulador.new(800, "CONVERTIR JUGADOR A ESPECULADOR"))
    end
    
    #Crea el tablero añadiendo las casillas
    def inicializar_tablero mazo
      @tablero = Tablero.new(@@num_carcel)
      #SALIDA creada en constructor
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C1", 50, 1.1, 75, 150, 50)))
      
      #IMPUESTO
      @tablero.añade_casilla(Casilla_impuesto.new("Impuesto",500))
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C2", 75, 1.1, 90, 200, 75)))
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C3", 75, 1.1, 90, 200, 75)))
      
      #Carcel añadida automaticamente 
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C4", 90, 1.2, 120, 300, 90)))
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C5", 90, 1.2, 120, 300, 90)))
      
      #SORPRESA
      @tablero.añade_casilla(Casilla_sorpresa.new(mazo, "SORPRESA1"))
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C6", 110, 1.2, 130, 350, 110)))
      
      #PARKING
      @tablero.añade_casilla(Casilla.new("Parking"))
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C7", 150, 1.3, 160, 450, 150)))
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C8", 150, 1.3, 160, 450, 150)))
      
      #SORPRESA
      @tablero.añade_casilla(Casilla_sorpresa.new(mazo, "SORPRESA2"))
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C9", 170, 1.3, 190, 500, 170)))
      
      #JUEZ
      @tablero.añade_juez
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C10", 220, 1.4, 250, 700, 220)))
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C11", 220, 1.4, 250, 700, 220)))
      
      #SORPRESA
      @tablero.añade_casilla(Casilla_sorpresa.new(mazo, "SORPRESA3"))
      
      #CALLE
      @tablero.añade_casilla(Casilla_calle.new(Titulo_propiedad.new("C12", 260, 1.5, 300, 1000, 260)))

    end
    
    #Actualiza el indice del jugador actual
    def pasar_turno
      if(@indice_jugador_actual < (@jugadores.length-1))
        @indice_jugador_actual = @indice_jugador_actual + 1
      else
        @indice_jugador_actual = 0
      end
    end
        
    #Produce una lista de los jugadores en funcion de su saldo
    def ranking
      ranking = @jugadores
      ranking.sort_by { |jugador| -jugador.saldo  }
      ranking
    end
        
    #Llama a salirCarcelPagando de la clase jugador
    def salir_carcel_pagando
      return @jugadores[@indice_jugador_actual].salir_carcel_pagando
    end
        
    #Llama a salirCarcelTirando de la clase jugador
    def salir_carcel_tirando
      return @jugadores[@indice_jugador_actual].salir_carcel_tirando
    end
       
    #No implementar aun***************************************hecho
    def siguiente_paso
        actual = get_jugador_actual
        operacion = @gestor_estados.operaciones_permitidas(actual, @estado)
        if(operacion == Operaciones_juego::PASAR_TURNO)
            pasar_turno
            siguiente_paso_completado(operacion)
        end
        
        if(operacion == Operaciones_juego::AVANZAR)
            avanza_jugador
            siguiente_paso_completado(operacion)
        end
        
        return operacion
    end
    
    #Se actualiza el estado del juego, obteniendo el siguiente estado
    def siguiente_paso_completado operacion
      @estado = @gestor_estados.siguiente_estado(@jugadores[@indice_jugador_actual], @estado, operacion)
    end
       
    #Llama al metodo vender de Jugador
    def vender ip
      return @jugadores[@indice_jugador_actual].vender(ip)
    end
        
  end
end