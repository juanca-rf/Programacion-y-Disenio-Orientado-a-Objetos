/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

import java.util.ArrayList;
/**
 *
 */
public class Tablero {
    private int numCasillaCarcel;
    private ArrayList<Casilla> casillas;
    private int porSalida;
    private boolean tieneJuez;
    
    
    Tablero(int indice_casillaCarcel){
        if(indice_casillaCarcel >= 1)
            numCasillaCarcel = indice_casillaCarcel;
        else
            numCasillaCarcel = 1;
        
        casillas = new ArrayList<Casilla>();
        casillas.add(new Casilla("Salida"));
        porSalida = 0;
        tieneJuez = false;
    }
    
    boolean correcto(){
        return ( this.casillas.size() > numCasillaCarcel && this.tieneJuez );
    }
    
    boolean correcto(int numCasilla){
        return ( this.correcto() && (numCasilla < this.casillas.size()) );
    }
    
    int getCarcel(){
        return numCasillaCarcel;
    }
    
    int getPorSalida(){
        if(porSalida > 0){
            porSalida--;
            return (porSalida+1);
        }
        else
            return 0; //return porSalida;
    }
    
    void añadeCasilla(Casilla casilla){
        if(this.casillas.size() == this.numCasillaCarcel)
            this.casillas.add(new Casilla("Cárcel"));
        this.casillas.add(casilla);
        //NO ME QUEDA CLARO ¿REPETIR AÑADIR CARCEL?¿HAY 2 CARCELES?
        if(this.casillas.size() == this.numCasillaCarcel)
            this.casillas.add(new Casilla("Cárcel"));
    }
    
    void añadeJuez(){
        if(!tieneJuez){
            tieneJuez = true;
            this.casillas.add(new CasillaJuez(numCasillaCarcel, "Juez"));
        }
    }
    
    Casilla getCasilla(int numCasilla){
        if(correcto(numCasilla))
            return casillas.get(numCasilla);
        else
            return null;
    }
    
    int nuevaPosicion(int actual, int tirada){
        int posFinal = actual + tirada;
        if(!this.correcto())
            return -1;
        else{
            if( (posFinal)>this.casillas.size() )
                porSalida++;
                
            return ((posFinal)%this.casillas.size());
        }
    }
    
    int calcularTirada(int origen, int destino){
        int resta = origen - destino;
        if(resta<0)
            return (resta + this.casillas.size());
        else
            return resta;
    }
    
    public void printcasillas(){
        for( Casilla x : casillas  )
            System.out.println("|||||||||||||||||||||||||||||||||||||||||||||||||||||||\n" + x.toString());
               
    }   
    
}