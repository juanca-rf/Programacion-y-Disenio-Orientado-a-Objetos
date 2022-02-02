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
public class SorpresaConvertirEspeculador extends Sorpresa {
    
    SorpresaConvertirEspeculador(int valor, String texto){
        super(valor , texto);       
    }
    
    @Override
    void aplicarAJugador (int actual, ArrayList<Jugador> todos ){ 
        informe(actual, todos);
        todos.set( actual, todos.get(actual).convertirJugador(valor) ) ;
    }
    
}
