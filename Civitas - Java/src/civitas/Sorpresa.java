/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;
import java.util.ArrayList;

abstract public class Sorpresa {
    protected String texto;
    protected int valor;
    protected Tablero tablero;
    
    Sorpresa(Tablero tablero){
        init();
        this.tablero = tablero;
    }
    
    Sorpresa ( int valor, String texto, Tablero tablero){
        init();
        this.valor = valor;
        this.texto = texto;
        this.tablero = tablero;
    }
    
    Sorpresa ( int valor, String texto){
        init();
        this.valor = valor;
        this.texto = texto;
    }
    
    
    //Metodo para inicializar el objero vacio
    private void init(){
        this.valor = -1;
        this.tablero = null;
    }
    
    //Comprueba si el primer parametro es un indice valido para acceder a los elementos del segundo
    public boolean jugadorCorrecto(int actual, ArrayList<Jugador> todos){
        return (actual < todos.size() && actual >= 0);   
    }
    
    //Informa al diario que se está aplicando una sorpresa
    protected void informe(int actual, ArrayList<Jugador> todos){
        Diario.getInstance().ocurreEvento("Se está aplicando una sorpresa a"+ todos.get(actual).getNombre());
    }
    
    //OVERRIDED Llama al metodo aplicarAJugador oportuno segun el tipo de sorpresa que sea
    void aplicarAJugador(int actual, ArrayList<Jugador> todos){
    }
       
    //Devuelve el nombre de la sorpresa
    @Override
    public String toString(){
        return "\nSorpresa: " 
                + "\n############################################" 
                + "\n# Tipo: " + this.getClass().getSimpleName()
                + "\n# " + texto 
                + "\n# Valor: " + valor ;
    }   
}