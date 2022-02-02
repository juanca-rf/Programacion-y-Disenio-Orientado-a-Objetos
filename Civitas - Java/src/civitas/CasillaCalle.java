
package civitas;

import java.util.ArrayList;


public class CasillaCalle extends Casilla {
    private TituloPropiedad titulo;
    
    //Tipo CALLE
    CasillaCalle(TituloPropiedad titulo){
        super( titulo.getNombre() );
        this.tituloPropiedad = titulo;
        this.nombre = titulo.getNombre();
        this.importe = titulo.getPrecioCompra();
    }
    
    //Si el jugador existe se genera un informe, y se le permite comprar si no tiene propietario o paga el aquiler si lo hay.
    @Override
    protected void recibeJugador(int iactual, ArrayList<Jugador> todos){
        Jugador jugador;
        if( jugadorCorrecto(iactual, todos) ){
            //1:
            informe(iactual, todos);
            //2:
            jugador = todos.get(iactual);
            
            //alt 3:
            if( !tituloPropiedad.tienePropietario() )
                jugador.puedeComprarCasilla();
            else{
                //4:
                tituloPropiedad.tramitarAlquiler(jugador);
            }
        }
    }
      
    //Getter de TituloPropiedad
    TituloPropiedad getTituloPropiedad(){
        return tituloPropiedad;
    }
    
    @Override
    public String toString(){
        return tituloPropiedad.toString();
    }
    
}
