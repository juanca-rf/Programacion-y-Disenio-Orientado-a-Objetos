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
public class CasillaImpuesto extends Casilla{
    
   //Tipo IMPUESTO
    CasillaImpuesto(float cantidad, String nombre){
        super(nombre);
        this.importe = cantidad;
    }
    
    //El jugador paga el impuesto que indique la casilla
    @Override
    protected void recibeJugador(int iactual, ArrayList<Jugador> todos){
        if(jugadorCorrecto(iactual, todos) == true){
            informe(iactual, todos);
            todos.get(iactual).pagaImpuesto(importe);
        }
    }
    
    @Override
    public String toString(){
      return this.nombre + "\nCantidad a pagar: " + this.importe;  
    }
    
}
