/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

import java.util.ArrayList;
import GUI.CSO;

/**
 *
 * @author juanc
 */
public class TestP4 {

    public static void main(String[] args) {
        System.out.println("TEST P4 __________________________________");
        
        ArrayList<Jugador> todos = new ArrayList<>();
        
        todos.add(new Jugador("Paco")); 
        
        todos.get(0).getPropiedades().add( new TituloPropiedad("escarbuto", 0, 0, 0, 0, 0)  );
        System.out.println( todos.get(0).toString() );
        System.out.println( todos.get(0).getPropiedades().get(0).toString() );
        
        
        todos.set(0, new JugadorEspeculador( todos.get(0), 50) ) ;
        System.out.println( todos.get(0).toString() );
        System.out.println( todos.get(0).getPropiedades().get(0).toString() );
        
        System.out.println( CSO.ANSI_RED_BACKGROUND + CSO.ANSI_CYAN + "Son iguales los propietarios " + todos.get(0).getPropiedades().get(0).esEsteElPropietario(todos.get(0)) );
    
    }
    
}
