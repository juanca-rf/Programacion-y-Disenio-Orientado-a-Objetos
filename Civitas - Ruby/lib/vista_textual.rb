#encoding:utf-8
require './operaciones_juego'
require 'io/console'
require './Respuestas'
require './gestiones_inmobiliarias'
require './Civitas_juego'

module Civitas
  class Vista_textual
     attr_reader :i_gestion
     attr_reader :i_propiedad
     
     
    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end


    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l.to_s
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opcion: ",
                          tab+"Valor erroneo")
      return opcion
    end

    
    def comprar
      titulo = "¿Quieres comprar la calle?: " + @juego_model.get_casilla_actual.to_s
      
      arr = Array.new
      Lista_respuestas.each do |x|
       arr << x.to_s
      end
      
      opcion = menu(titulo, arr)
      return Lista_respuestas[opcion]
      
    end

    def gestionar
      
      arr = Array.new
      Lista_gestiones_inmobiliarias.each do |x|
       arr << x.to_s
      end
      
      @i_gestion = menu( "Elige tipo de gestion a realizar:", arr )
      
      if Lista_gestiones_inmobiliarias[@i_gestion] != Gestiones_inmobiliarias::TERMINAR
        lista_propiedades = Array.new
        @juego_model.get_jugador_actual.propiedades.each do |propiedad|
           lista_propiedades << propiedad.to_s
        end
        
        @i_propiedad = menu("Selecciona propiedad a gestionar: ", lista_propiedades)
        
      end
      
    end

    def mostrar_siguiente_operacion operacion
      puts "Siguiente operacion a realizar es: " + operacion.to_s #REVISAR QUE SEA CORRECTO
    end

    def mostrar_eventos
      while Diario.instance.eventos_pendientes
        puts Diario.instance.leer_evento
      end
    end

    def set_civitas_juego(civitas)
         @juego_model=civitas
         #self.actualizarVista
    end

    def actualizar_vista
      estado = @juego_model.info_jugador_texto + "\n En la Casilla: " + @juego_model.get_casilla_actual.nombre + "\n----------------------------------------------------------------"
      self.mostrar_estado(estado)
    end

  end

end
