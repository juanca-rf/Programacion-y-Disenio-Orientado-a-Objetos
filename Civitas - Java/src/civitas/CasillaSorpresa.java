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
public class CasillaSorpresa extends Casilla {
    private Sorpresa sorpresa;
    private MazoSorpresas mazo;
    
    //Tipo SORPRESA
    CasillaSorpresa(MazoSorpresas mazo, String nombre){
        super(nombre);
        this.mazo = mazo;
        this.nombre = nombre;
    }
    
    //Aplica al jugador la sorpresa y genera un informe
    @Override
    protected void recibeJugador(int iactual, ArrayList<Jugador> todos){
        if(jugadorCorrecto(iactual, todos)){
            //1:
            sorpresa = mazo.siguiente();
            //2:
            informe(iactual, todos);
            //3:
            sorpresa.aplicarAJugador(iactual, todos);
        }
    }
    
}
