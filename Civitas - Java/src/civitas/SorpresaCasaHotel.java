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
public class SorpresaCasaHotel extends Sorpresa{
    
    SorpresaCasaHotel (int valor, String texto ){
        super(valor,texto);
    }
    
    //Aplica la carta de pagar por casas y hoteles
    @Override
    protected void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        if(jugadorCorrecto(actual, todos)){
            informe(actual, todos);
            todos.get(actual).modificarSaldo(valor * (todos.get(actual).cantidadCasasHoteles()));
        }
        
    }
    
}
