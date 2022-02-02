/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

import java.util.ArrayList;
import java.util.*;
/**
 *
 */
public class MazoSorpresas {
    private ArrayList<Sorpresa> sorpresas;
    private boolean barajada;
    private int usadas;
    private boolean debug;
    private ArrayList<Sorpresa> cartasEspeciales;
    private Sorpresa ultimaSorpresa;
    
    private void init(){
        sorpresas = new ArrayList<>();
        cartasEspeciales = new ArrayList<>();
        barajada = false;
        usadas = 0;
    }
    
    //Constructor con parámetros
    MazoSorpresas(boolean deb){
        debug = deb;
        this.init();
        if (debug)
            Diario.getInstance().ocurreEvento("El modo debug está activo");
    }
    
    //Constructor sin parámetros
    MazoSorpresas(){
        this.init();
        debug = false;
    }
    
    //Si el mazo no se ha barajado, se añade la sorpresa al mazo
    void alMazo(Sorpresa s){
        if(!barajada)
            sorpresas.add(s);
    }
    
    //Si el mazo no ha sido barajado o si el numero de cartas usadas es igual al tamaño del mazo, se baraja
    Sorpresa siguiente(){
        if(!barajada || usadas == sorpresas.size() && !debug){
            Collections.shuffle(sorpresas);  //Sirve para barajar el mazo
            barajada = true;
            usadas=0;
        }
        usadas ++;
        ultimaSorpresa = sorpresas.get(0);
        sorpresas.remove(0);
        sorpresas.add(ultimaSorpresa);
        
        return ultimaSorpresa;    
    }
    
    //Si la sorpresa es carta especial y está en el mazo, se quita y se añade a cartasEpeciales
    void inhabilitarCartaEspecial (Sorpresa sorpresa){
        if(sorpresas.contains(sorpresa)){
            cartasEspeciales.add(sorpresa);
            sorpresas.remove(sorpresa);
            Diario.getInstance().ocurreEvento("Se ha inhabilitado una carta especial");
        }
    }
    
    //Si la sorpresa está en cartaEspecial se saca y se añade al final de la coleccion de sorpresas
    void habilitarCartaEspecial(Sorpresa sorpresa){
      if(cartasEspeciales.contains(sorpresa)){
            cartasEspeciales.remove(sorpresa);
            sorpresas.add(sorpresa);
            Diario.getInstance().ocurreEvento("Se ha habilitado una carta especial");
        }    
    }

    Sorpresa getSorpresas(int i){
        return sorpresas.get(i);
    }
    
    int getTamSorpresas(){
        return sorpresas.size();
    }
}