# encoding:utf-8
require './dado'
require './tipo_casilla'
require './tipo_sorpresa'
require './diario'
require './mazo_sorpresas'
require './tablero'
require './casilla'

module Civitas
  class TestP1
      dado = Dado.instance
      diario = Diario.instance
      mazo = MazoSorpresa.new
      tablero = Tablero.new(7)
      
      #Creacion de jugadores variable
      jugadores = 4
      listJugadores = []
      for i in 0..(jugadores-1) do
        listJugadores[i] = 0        #Iniciamos todas las variables a 0
      end
      
      #Tarea 1
      for i in 0 .. 99 do
        valor = dado.quienEmpieza(4)
        listJugadores[ valor ] = listJugadores[ valor ] + 1 #Cada posicion el array pertenece a un jugador y lo incrementamos en uno cuando coincida
      end    
      
        #Sacamos por pantalla los resultados
      puts "        TAREA 1 "
      for i in 0..(jugadores-1) do
        puts "El jugador #{i} empieza: #{listJugadores[ i ]} veces" 
      end 
      
      #Tarea 2
      puts "
        TAREA 2 "
      puts "Dado Debug activado"
      dado.setDebug( true )
      for i in 0..5 do
        puts "Tirada: " + dado.tirar.to_s
      end
      puts "Debug dado desactivado"
      dado.setDebug( false )
      for i in 0..5 do
        puts "Tirada: " + dado.tirar.to_s
      end
    
      #Punto 3 del TestP1 
      puts "
        TAREA 3 "
      puts "El ultimo resultado es: #{dado.ultimoResultado}" 
      if dado.salgoDeLaCarcel 
        puts "Salgo de la carcel porque he sacado un: #{dado.ultimoResultado}" 
      else 
        puts "No salgo de la carcel porque he sacado un: #{dado.ultimoResultado}" 
      end 

      #Punto 4 del TestP1 
      puts "
        TAREA 4 "
      puts "Un valor de TipoCasilla es #{TipoCasilla::IMPUESTO}" 
      puts "Un valor de TipoSorpresa es #{TipoSorpresa::IRCASILLA}" 
      
      #Punto 5 del TestP1
      puts "
        TAREA 5 "
      mazo.alMazo TipoSorpresa::IRCASILLA 
      mazo.alMazo TipoSorpresa::IRCARCEL
      mazo.alMazo TipoSorpresa::PAGARCOBRAR
      puts "Carta de sorpresa: #{mazo.siguiente}"
    
      #Punto 6 del TestP1 
      puts "
        TAREA 6 "
      diario.ocurre_evento("Has pasado por la casilla de salida") 
      puts "Elementos pendientes " + diario.eventos_pendientes.to_s 
      puts diario.leer_evento
      
      #Punto 7 del TestP1 
      puts "
        TAREA 7 "
      for i in 'a'..'i' do
        tablero.añadeCasilla(Casilla.new(i))
      end 
      tablero.añadeJuez
      
      dado.setDebug(true)
      puts "Casillas aniadidas: "
      for j in 0..(tablero.casillas.size-1) do
        puts "  " + tablero.getCasilla(j).getNombre
      end
    
    
  end    
end