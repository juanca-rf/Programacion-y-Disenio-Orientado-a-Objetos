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
public class SorpresaPagarCobrar extends Sorpresa {
    
    SorpresaPagarCobrar(int valor, String texto){
        super(valor,texto);
    }
    
    //Aplica la carta de pagar o cobrar con el valor de la carta
    @Override
    protected void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        if(jugadorCorrecto(actual, todos)){
            informe(actual, todos);
            todos.get(actual).modificarSaldo(valor);
        }
        
    }
    
}
