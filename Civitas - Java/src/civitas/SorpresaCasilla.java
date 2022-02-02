/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

import java.util.ArrayList;

/**
 *
 * @author juanc
 */
public class SorpresaCasilla extends Sorpresa{
    
    //Para ir a otra casilla
    SorpresaCasilla (Tablero tablero, int valor, String texto){
        super(valor,texto,tablero);
    }
        
    //Aplica la carta de ir a la casilla especificada por la carta
    @Override
    void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        if(jugadorCorrecto(actual, todos) ){
            informe(actual, todos);
            int cas_actual = todos.get(actual).getNumCasillaActual();
            int tirada = tablero.calcularTirada(cas_actual, valor);
            int nueva_pos = tablero.nuevaPosicion(cas_actual, tirada);
            
            todos.get(actual).moverACasilla(nueva_pos);
            tablero.getCasilla(nueva_pos).recibeJugador(actual, todos);
        }
        
    }
}
