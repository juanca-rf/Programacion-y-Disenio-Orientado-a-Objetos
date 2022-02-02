/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;

/**
 * @author juanca
 * @author german
 */
public class TituloPropiedad {
    private float alquilerBase;
    static private float factorInteresesHipoteca= 1.1f;
    private float factorRevalorizacion;
    private float hipotecaBase;
    private boolean hipotecado;
    public String nombre;
    private int numCasas;
    private int numHoteles;
    private float precioCompra;
    private float precioEdificar;
    Jugador propietario;
    
    //Constructor de la clase con atributos
    TituloPropiedad(String nom, float ab, float fr,float hb, float pc, float pe){
        this.nombre               = nom;
        this.alquilerBase         = ab;
        this.factorRevalorizacion = fr;
        this.hipotecaBase         = hb;
        this.precioCompra         = pc;
        this.precioEdificar       = pe;
        this.propietario          = null;       
        this.numCasas             = 0;
        this.numHoteles           = 0;
        this.hipotecado           = false;
    }
    
    //Imprime el estado completo de un objeto del tipo TituloPropiedad
    @Override
    public String toString(){
        String propietario_s = propietario==null? "No tiene" : propietario.getNombre();
        return " Titulo Propiedad "+
               "\n          Nombre de la propiedad: "   + nombre + 
               "\n          Alquiler Base: "            + Float.toString(alquilerBase) +
               "\n          Factor de Revalorizacion: " + factorRevalorizacion + 
               "\n          Hipoteca Base: "            + Float.toString(hipotecaBase)+ 
               "\n          Precio Edificar: "          +  Float.toString(precioEdificar) + 
               "\n          Popietario: "               + propietario_s +
               "\n          Numero de casas: "          + Integer.toString(numCasas)+ 
               "\n          Numero de Hoteles: "        + Integer.toString(numHoteles) +  
               "\n          Hipotecado: "               + hipotecado;            
    }
    
    //Devuelve el precio del alquiler calculado segun las reglas del juego
    private float getPrecioAlquiler(){
        float pa;
        if( hipotecado || this.propietarioEncarcelado())
            pa=0;
        else
            pa= (alquilerBase * (1.0f+(numCasas*0.5f)+(numHoteles*2.5f))) ;
        
        return pa;
    }
    
    //Devuelve el importe de la hipoteca
    private float getImporteHipoteca(){
        return (hipotecaBase * (1.0f+(numCasas*0.5f)+(numHoteles*2.5f)) );
    }
    
    //Devuelve el importe que se obtiene al hipotecar el titulo multiplicado por factorInteresesHipoteca
    float getImporteCancelarHipoteca(){
        return (factorInteresesHipoteca * getImporteHipoteca());
    }
    
    
    //Cancela la hipoteca de su dueño si este lo paga
    boolean cancelarHipoteca(Jugador jugador){
        boolean result = false;
        if( hipotecado && esEsteElPropietario(jugador)){
            jugador.paga(getImporteCancelarHipoteca());
            hipotecado = false;
            result = true;
        }
        return result;
    }
    
    
    //Devuelve true si el jugador es propietario del TituloPropiedad
    protected boolean esEsteElPropietario(Jugador jugador){
        return (propietario == jugador);
    }
    
    //Devuelve si el TituloPropiedad tiene propietario
    boolean tienePropietario(){
        return (propietario != null);
    }
    
    //Si el título tiene propietario, y el jugador pasado como parámetro no es el propietario del título,
    //ese jugador paga el alquiler y el propietario recibe ese mismo importe
    void tramitarAlquiler(Jugador jugador){
        if(tienePropietario() && !esEsteElPropietario(jugador)  ){
            jugador.pagaAlquiler( getPrecioAlquiler() );
            propietario.recibe(getPrecioAlquiler());
        }
    }
       
    
    //Hipoteca la propiedad devolviendole al propietario el importe por ello
    boolean hipotecar (Jugador jugador){
        boolean result = false;
        
        if(!hipotecado && esEsteElPropietario(jugador)){
            jugador.recibe(getImporteHipoteca());
            hipotecado = true;
            result = true;
        }
        
        return result;
    }
    
       
    //Devuelve true si el propietario está encarcelado
    private boolean propietarioEncarcelado(){
        return ( tienePropietario() == true && propietario.isEncarcelado() );
    }
    
    //Devuelve la suma de casas y hoteles
    int cantidadCasasHoteles(){
        return (numCasas + numHoteles);
    }
    
    //Devuelve el precio final de venta
    private float getPrecioVenta(){
        return (precioCompra + (((numCasas + numHoteles) * precioEdificar) * factorRevalorizacion));
    }
    
    //En caso de cumplir las condiciones de decrementa en n el contador de casas
    boolean derruirCasas(int n, Jugador jugador){
        boolean derruyeCasas = false;
        
        if(esEsteElPropietario(jugador) && (numCasas >= n)){
            numCasas= numCasas - n;
            derruyeCasas=true;
        }
        return derruyeCasas;
    }
    
    //En caso de cumplir las condiciones de decrementa en n el contador de hoteles
    boolean derruirHoteles(int n, Jugador jugador){
        boolean derruyeHoteles = false;
        
        if(esEsteElPropietario(jugador) && (numHoteles >= n)){
            numHoteles= numHoteles - n;
            derruyeHoteles=true;
        }
        return derruyeHoteles;
    }
       
    //Actualiza el propietario del TituloPropiedad al jugador pasado como parámetro
    void actualizaPropietarioPorConversion(Jugador jugador){
        propietario = jugador;
    }
    
    //Devuelve si el TituloPropiedad está hipotecado
    public boolean getHipotecado(){
        return hipotecado;
    }
    
    //Get de la variable nombre
    public String getNombre(){
        return nombre;
    }
    
    //Get de la variable numCasas
    public int getNumCasas(){
        return numCasas;
    }
    
    //Get de la variable numHoteles
    public int getNumHoteles(){
        return numHoteles;
    }
    
    //Get de la variable precioCompra
    float getPrecioCompra(){
        return precioCompra;
    }
    
    //Get de la variable precioEdificar
    float getPrecioEdificar(){
        return precioEdificar;        
    }
    
    //Si el jugador es el propietario y no está hipotecado, se devuelve el jugador
    boolean vender(Jugador jugador){
        boolean vende = false;
        
        if(esEsteElPropietario(jugador) && !hipotecado){
            jugador.recibe(getPrecioVenta());
            actualizaPropietarioPorConversion(null);  
            derruirCasas(getNumCasas(), jugador);
            derruirHoteles(getNumHoteles(), jugador);
            vende=true;
        }
        return vende;
    }
    
    
    //Si la propiedad no tiene propietario el jugador paga la propiedad
    boolean comprar(Jugador jugador){
        boolean result=false;
        if(!tienePropietario()){
            propietario = jugador;
            result = true;
            propietario.paga(precioCompra);
        }
        return result;
    }
    
    //Si es el propietario se construye una casa
    boolean construirCasa(Jugador jugador){
        boolean result=false;
        
        if(esEsteElPropietario(jugador)){
            jugador.paga(precioEdificar);
            numCasas++;
            result = true;
        }
        return result;
    }
    
    //Si es el propietario se construye un hotel
    boolean construirHotel(Jugador jugador){
        boolean result=false;
        
        if(esEsteElPropietario(jugador)){
            jugador.paga(precioEdificar);
            numHoteles++;
            result = true;
        }
        
        return result;
    }
    
}
