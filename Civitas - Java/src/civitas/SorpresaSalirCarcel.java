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
public class SorpresaSalirCarcel extends Sorpresa {
    protected MazoSorpresas mazo;
    
    //Para evitar ir a la carcel
    SorpresaSalirCarcel (MazoSorpresas mazo){
        super(-1,"SalirCarcel");
        this.mazo = mazo;
    }
    
    //Aplica la carta para salir de la carcel
    @Override
    protected void aplicarAJugador(int actual, ArrayList<Jugador> todos){
        
        boolean salvocond = false;
        if(jugadorCorrecto(actual, todos)){
            informe(actual, todos);
            
            for(int i = 0; i < todos.size() && !salvocond; i++)
                if(todos.get(i).tieneSalvoconducto())
                    salvocond = true;
            
            if(salvocond){
                SorpresaSalirCarcel sorpresa = new SorpresaSalirCarcel(mazo);
                todos.get(actual).obtenerSalvoconducto(sorpresa);
                sorpresa.salirDelMazo();
            }
            
        }
        
    }
    
    //Si el tipo de sorpresa es evitar la carcel, se inhabilita en el mazo de cartas sorpresa
    void salirDelMazo(){
        mazo.inhabilitarCartaEspecial(this);
        
    }
    
   //Si el tipo de sorpresa es evitar la carcel, se habilita en el mazo de cartas sorpresa
    void usada(){
        mazo.habilitarCartaEspecial(this);     
    }
    
}
