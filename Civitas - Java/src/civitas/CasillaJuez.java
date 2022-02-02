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
public class CasillaJuez extends Casilla {
    
    //Tipo JUEZ
    CasillaJuez(int numCasillaCarcel, String nombre){
        super(nombre);
        Casilla.carcel = numCasillaCarcel;
    }
    
    //Se encarcela al jugador actual
    @Override
    protected void recibeJugador(int iactual, ArrayList<Jugador> todos){
        if( jugadorCorrecto(iactual, todos) == true ){
            informe(iactual, todos);
            todos.get(iactual).encarcelar(carcel);
        }
    }
    

}
