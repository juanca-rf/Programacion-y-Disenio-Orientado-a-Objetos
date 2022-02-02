# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require './Operaciones_juego'
require './Operacion_inmobiliaria'
require './Salidas_carcel'

module Civitas
  class Controlador                                  
                                   
    def initialize(juego, vista)
      @juego = juego
      @vista = vista
    end
    
    def juega
      @vista.set_civitas_juego(@juego);

      while(!@juego.final_del_juego())
          @vista.actualizar_vista()
          @vista.pausa 
          operacion = @juego.siguiente_paso
          @vista.mostrar_siguiente_operacion(operacion)
          if( @juego.siguiente_paso != Operaciones_juego::PASAR_TURNO )
              @vista.mostrar_eventos
          end

          if(!@juego.final_del_juego)
            case (operacion)
              when Operaciones_juego::COMPRAR
                if(@vista.comprar == Respuestas::SI)
                  @juego.comprar
                end
                @juego.siguiente_paso_completado(operacion)
                
              when Operaciones_juego::GESTIONAR
                @vista.gestionar
                op_inmobiliaria = Operacion_inmobiliaria.new( Lista_gestiones_inmobiliarias[@vista.i_gestion], @vista.i_propiedad )

                case(Lista_gestiones_inmobiliarias[@vista.i_gestion])
                  when Gestiones_inmobiliarias::VENDER
                    @juego.vender(op_inmobiliaria.num_propiedad)
                  when Gestiones_inmobiliarias::HIPOTECAR
                    @juego.hipotecar(op_inmobiliaria.num_propiedad)

                  when Gestiones_inmobiliarias::CANCELAR_HIPOTECA
                    @juego.cancelar_hipoteca(op_inmobiliaria.num_propiedad)

                  when Gestiones_inmobiliarias::CONSTRUIR_CASA
                    @juego.construir_casa(op_inmobiliaria.num_propiedad)

                  when Gestiones_inmobiliarias::CONSTRUIR_HOTEL
                    @juego.construir_hotel(op_inmobiliaria.num_propiedad)

                  when Gestiones_inmobiliarias::TERMINAR
                    @juego.siguiente_paso_completado(operacion)
                end

              when Operaciones_juego::SALIR_CARCEL
                n = @vista.menu( "Elige como salir carcel", Lista_salir_carcel)
                if( Lista_salir_carcel[n] == Salidas_carcel::PAGANDO )
                    @juego.salir_carcel_pagando
                else @juego.salir_carcel_tirando
                end
                @juego.siguiente_paso_completado(operacion)
            end
          end
        end
        jugadores_ordenados = @juego.ranking
        puts "\n\n\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n       RANKING DE JUGADORES\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        jugadores_ordenados.each do |jugador|
          puts jugador.to_s
          puts "-----------------"
        end
        puts "\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n         FIN DEL JUEGO    \n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    end
    
  end
end

