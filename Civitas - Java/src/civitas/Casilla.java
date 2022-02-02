/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;
import java.util.ArrayList;

public class Casilla {
    protected static int carcel;
    protected float importe;
    protected String nombre;
    protected TituloPropiedad tituloPropiedad;

       
    //Tipo DESCANSO
    Casilla (String nombre){
        init();
        this.nombre= nombre;
    }
    
    //Getter de nombre
    public String getNombre(){
        return nombre;
    }
    
    //Informa que jugador ha caido en qué casilla
    protected void informe(int iactual, ArrayList<Jugador> todos){
        Diario.getInstance().ocurreEvento("Ha caido en la casilla " + nombre + " el jugador: " + todos.get(iactual).getNombre());
    }
    
    //Método de inicializar a vacio
    protected void init(){
        importe = 0;
        nombre = "";
        tituloPropiedad = null;
    }
    
    //Comprueba si el jugador es correcto
    public boolean jugadorCorrecto(int iactual, ArrayList<Jugador> todos){
        return (iactual < todos.size() && iactual >= 0);
    }
    
    // OVERRIDED Recibe el jugador el efecto de la casilla actual dependiendo del tipo
    void recibeJugador(int iactual, ArrayList<Jugador> todos){}
    
    //Imprime la información de la casilla
    @Override
    public String toString(){
        return nombre;
    }
    
}