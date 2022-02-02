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
public class SorpresaCarcel extends Sorpresa {
    
    //Para ir a la carcel
    SorpresaCarcel (Tablero tablero){
        super(tablero);
    }
    
    //Aplica la carta de ir a la carcel
    @Override
    void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        if(jugadorCorrecto(actual, todos) ){
            System.out.println("SE VA APLICAR UNA SORPRESA DE TIPO CARCEL");
            informe(actual, todos);
            todos.get(actual).encarcelar(tablero.getCarcel());
        }
        
    }
    
}
