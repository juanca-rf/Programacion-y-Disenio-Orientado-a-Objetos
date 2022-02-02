/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

import java.util.ArrayList;

public class SorpresaJugador extends Sorpresa{
    
    SorpresaJugador (int valor, String texto ){
        super(valor,texto);
    }
    
    //Aplica la carta de pagar al jugador por parte de los demas jugadores
    @Override
    protected void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        if(jugadorCorrecto(actual, todos)){
            informe(actual, todos);
            Sorpresa sorpresa1 = new SorpresaPagarCobrar( (valor * -1), "");
            Sorpresa sorpresa2 = new SorpresaPagarCobrar( (valor * (todos.size() - 1)), "");
            
            for(int i = 0; i < todos.size(); i++){
                if(i != actual){
                    sorpresa1.aplicarAJugador(i, todos);
                }else{
                    sorpresa2.aplicarAJugador(i, todos);
                }
            }
            
        }
        
    }
    
}
