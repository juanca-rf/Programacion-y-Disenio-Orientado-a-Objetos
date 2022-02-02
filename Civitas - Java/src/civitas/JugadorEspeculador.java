/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

/**
 *
 * @author juanc
 */
public class JugadorEspeculador extends Jugador {
    private float fianza;
    private static int factorEspeculador = 2;
    
    public JugadorEspeculador(Jugador conversion, float fianza){
        super(conversion);
        this.fianza = fianza;
        for(TituloPropiedad titulo : conversion.getPropiedades())
            titulo.actualizaPropietarioPorConversion(this);
    }
    
    public JugadorEspeculador convertirJugador( int fianza){
        System.out.println("________________________JUGADOR YA CONVERTIDO________________________");
        return this;
    }
    
    @Override
    protected int getCasasMax(){
        return factorEspeculador*CasasMax ;
    }
    
    @Override
    protected int getHotelesMax(){
        return factorEspeculador*HotelesMax ;
    }
    
    @Override
    boolean pagaImpuesto(float cantidad){
       return super.pagaImpuesto(cantidad/2) ;
    }
    
    @Override
    protected boolean puedoEdificarCasa(TituloPropiedad propiedad){
        boolean result=false;
        float precio = propiedad.getPrecioEdificar();
        
        if(puedoGastar(precio) && (propiedad.getNumCasas() < this.getCasasMax()) )
            result = true;
        
        return result; 
    }
    
    @Override
    protected boolean puedoEdificarHotel(TituloPropiedad propiedad){
        boolean puedoEdificarHotell=false;
        float precio = propiedad.getPrecioEdificar();
        
        if(puedoGastar(precio) && (propiedad.getNumHoteles()<this.getHotelesMax()) && (propiedad.getNumCasas()>=getCasasPorHotel()) )
            puedoEdificarHotell = true;
        
        return puedoEdificarHotell;
    }
    
    @Override
    protected boolean debeSerEncarcelado(){
        boolean debeSerEncarcelado = super.debeSerEncarcelado();
        boolean puedoPagar = puedoGastar(this.fianza);
        
        if(puedoPagar)
            super.paga(fianza);    
       
        return !puedoPagar && debeSerEncarcelado;
    }
    
    @Override
    public String toString(){
        String devolver = super.toString();
        devolver = devolver.replaceAll("JUGADOR", "JUGADOR ESPECULADOR");
        devolver += "\n     -Fianza " + this.fianza;
        return devolver;
    }
    
}
