/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;
import GUI.CSO;
import GUI.Dado;
import java.util.ArrayList;
import static java.lang.Float.compare;

/**
 * @author juanca
 * @author german
 */
public class Jugador implements Comparable<Jugador>{
    protected static int CasasMax = 4;
    protected static int CasasPorHotel = 4;
    public boolean encarcelado;
    protected static int HotelesMax = 4;
    protected String nombre;
    private int numCasillaActual;
    protected static float PasoPorSalida = 1000f;
    protected static float PrecioLibertad = 200f;
    private boolean puedeComprar;
    private float saldo;
    private static float SaldoInicial = 7500f;
    private Sorpresa salvoconducto = null;
    private ArrayList<TituloPropiedad> propiedades;
    
    
    Jugador(String nombre){
        this.nombre = nombre;
        propiedades = new ArrayList<>();
        saldo = SaldoInicial;
        numCasillaActual = 0;
        puedeComprar = true;
    }
    
    protected Jugador(Jugador otro){
        encarcelado      = otro.isEncarcelado();
        nombre           = otro.getNombre();
        numCasillaActual = otro.getNumCasillaActual();
        puedeComprar     = otro.getPuedeComprar();
        saldo            = otro.getSaldo();
        salvoconducto    = otro.getSalvoconducto();
        propiedades      = otro.getPropiedades();
    }
    
    public JugadorEspeculador convertirJugador( int fianza ){
        return new JugadorEspeculador(this,fianza);
    }
    
    //Cancela la hipoteca del juagdor si no esta encarcelado, es suya la propiedad y puede pagarla
    boolean cancelarHipoteca(int ip){
        boolean devolver = false;   
        float cantidad;
        TituloPropiedad propiedad;
        if(!encarcelado && existeLaPropiedad(ip)){
            propiedad = propiedades.get(ip);
            cantidad = propiedad.getImporteCancelarHipoteca();
            if(puedoGastar(cantidad)){
                devolver = propiedad.cancelarHipoteca(this);
            }
            if(devolver)
                Diario.getInstance().ocurreEvento("El jugador" + nombre + " cancela la hipoteca de la propiedad " + ip );
        }
        return devolver;
    }
    
    //Devuelve la cantidad de casas y hoteles que tiene el jugador
    int cantidadCasasHoteles(){
        int total = 0;
        for(int i = 0; i < propiedades.size(); i++)
            total += propiedades.get(i).cantidadCasasHoteles();
        return total;
    }
    
    //Compara el saldo de dos jugadores
    @Override
    public int compareTo(Jugador otro){
        return compare(saldo, otro.getSaldo());
    }
    
    //Compra propiedad si puede
    boolean comprar(TituloPropiedad titulo){
        boolean result = false;
        float precio;
        if(!encarcelado && puedeComprar){
            precio = titulo.getPrecioCompra();
            if(puedoGastar(precio)){
                result = titulo.comprar(this);
                if(result){
                    propiedades.add(titulo);
                    Diario.getInstance().ocurreEvento("El jugador " + nombre + " compra la propiedad " + titulo.toString());
                }
                puedeComprar = false;
            }
        }
        return result;
    }
    
    //Construye casa
    boolean construirCasa(int ip){
        boolean devolver = false;  
        boolean puedoEdificarCasa;
        TituloPropiedad propiedad;
        float precio;

        if(!encarcelado && existeLaPropiedad(ip)){
            propiedad = propiedades.get(ip);
            
            if(puedoEdificarCasa(propiedad))
                devolver = propiedad.construirCasa(this);
            
            if(devolver)
                Diario.getInstance().ocurreEvento("El jugador " + nombre + " construye casa en la propiedad " + ip);
        }
        return devolver;
    }
    
    //Construye hotel
    boolean construirHotel(int ip){
        boolean devolver = false;   
        boolean puedoEdificarHotel;
        TituloPropiedad propiedad;
        if(!encarcelado && existeLaPropiedad(ip)){
            propiedad = propiedades.get(ip);
            puedoEdificarHotel = puedoEdificarHotel(propiedad); //Entiendo que a partir de 2.2 en el diagrama 6 se implementa en el metodo puedoedificar
            if(puedoEdificarHotel){
                devolver = propiedad.construirHotel(this);
                propiedad.derruirCasas(CasasPorHotel, this);
                Diario.getInstance().ocurreEvento("El jugador " + nombre + " construye hotel en la propiedad " + ip);
            }
        }
        return devolver;
    }
    
    //Devuelve false si el jugador está encarcelado y true si no tiene la carta que le evita ir a la carcel
    protected boolean debeSerEncarcelado(){
        boolean devolver;
        if(encarcelado){
            devolver = false;
        }else if(tieneSalvoconducto()){
            perderSalvoConducto();
            devolver = false;
            Diario.getInstance().ocurreEvento("El jugador " + nombre + " usa la carta Salvoconducto y no va a la cárcel.");
        }else
            devolver = true;
        return devolver;
    }
    
    //Devuelve true si el jugador tiene saldo negativo
    boolean enBancarrota(){
        return (saldo < 0);
    }
    
    //Lleva al jugador a la casilla de la carcel
    boolean encarcelar(int numCasillaCarcel){
        if(debeSerEncarcelado()){
            moverACasilla(numCasillaCarcel);
            encarcelado = true;
            Diario.getInstance().ocurreEvento("El jugador "+nombre+" ha sido encarcelado.");
        }
        return encarcelado;
    }
    
    //Devuelve true si existe la propiedad pasada como parámetro
    private boolean existeLaPropiedad(int ip){
        return (ip >= 0 && ip < propiedades.size());
    }
    
    //Este getter lo he creado a pesar de no estar en el guion
    Sorpresa getSalvoconducto(){
        return salvoconducto;
    }
    
    //Devuelve el máximo de casas 
    protected int getCasasMax(){
        return CasasMax;
    }
    
    //Devuelve el numero de casas necesarias para construir un hotel
    int getCasasPorHotel(){
        return CasasPorHotel;
    }
    
    //Devuelve el máximo de hoteles
    protected int getHotelesMax(){
        return HotelesMax;
    }
    
    //Devuelve el nombre
    public String getNombre(){
        return nombre;
    }
    
    //Devuelve el valor de la casilla actual
    public int getNumCasillaActual(){
        return numCasillaActual;
    }
    
    //Devuelve el precio a pagar por salir de la carcel
    private float getPrecioLibertad(){
        return PrecioLibertad;
    }
    
    //Devuelve el dinero que te llevas al pasar por casilla de salida
    private float getPremioPasoSalida(){
        return PasoPorSalida;
    }
    
    //Devuelve el array de TituloPropiedad con las propiedades del jugador
    public ArrayList<TituloPropiedad> getPropiedades(){
        return propiedades;
    }
    
    //Devuelve true si se puede comprar
    boolean getPuedeComprar(){
        return puedeComprar;
    }
    
    //Devuelve el saldo del jugador
    public float getSaldo(){
        return saldo;
    }
    
    //Se hipoteca la propiedad si se puede
    boolean hipotecar(int ip){
        boolean devolver = false; 
        TituloPropiedad propiedad;
        if(!encarcelado && existeLaPropiedad(ip)){
            propiedad = propiedades.get(ip);
            devolver = propiedad.hipotecar(this); 
        }
        if(devolver)
            Diario.getInstance().ocurreEvento("El jugador " + nombre + " hipoteca la propiedad " + ip);
        
        return devolver;
    }
    
    //Devuelve si el jugador está encarcelado
    public boolean isEncarcelado(){
        return encarcelado;
    }
    
    //Incrementa el saldo del jugador
    boolean modificarSaldo(float cantidad){
        this.saldo += cantidad;
        Diario.getInstance().ocurreEvento("Se ha modificado el saldo del jugador " + nombre);
        return true;
    }
    
    //Devuelve false si está encarcelado, si no se cambia la casilla en la que está el jugador
    boolean moverACasilla(int numCasilla){
        boolean devolver = false;
        if(!encarcelado){
            puedeComprar = false;
            Diario.getInstance().ocurreEvento(nombre + " se ha movido de " + numCasillaActual + " a " + numCasilla);
            numCasillaActual = numCasilla;
            devolver = true;
        }
        return devolver;
    }
    
    //Si el jugador no está encarcelado se guarda la sorpresa en salvoconducto
    boolean obtenerSalvoconducto(Sorpresa sorpresa){
        boolean devolver = false;
        if(!encarcelado){
            salvoconducto = sorpresa;
            devolver = true;
        }
        return devolver;
    }
    
    //Paga la cantidad pasada como parámetro
    boolean paga(float cantidad){
        return modificarSaldo(cantidad * -1);
    }
    
    //Paga el precio de alquiler
    boolean pagaAlquiler(float cantidad){
        boolean devolver;
        if(encarcelado){
            devolver = false;
        }else{
            devolver = paga(cantidad);
        }
        return devolver;
    }
    
    //Si el jugador no está encarcelado paga la cantidad pasada como parámetro
    boolean pagaImpuesto(float cantidad){
        boolean devolver;
        if(encarcelado){
            devolver = false;
        }else{
            devolver = paga(cantidad);
        }
        return devolver;
    }
    
    //Incrementa el saldo con PasoPorSalida
    boolean pasaPorSalida(){
        this.modificarSaldo(getPremioPasoSalida());
        Diario.getInstance().ocurreEvento("El jugador " + nombre + " ha pasado por la salida y cobrado por ello");
        return true;
    }
    
    //El jugador pierde la carta salvoconducto
    private void perderSalvoConducto(){
        ((SorpresaSalirCarcel)salvoconducto).usada();
        salvoconducto = null;
    }
    
    //Devuelve si el jugador puede o no comprar 
    boolean puedeComprarCasilla(){
        puedeComprar = !encarcelado;
        return puedeComprar;
    }
    
    //Indica si el saldo del jugador es mayor al precio para salir de la carcel
    private boolean puedeSalirCarcelPagando(){
        return (saldo >= PrecioLibertad);
    }
    
    
    //Calcula privadamente si puede edificar casas
    protected boolean puedoEdificarCasa(TituloPropiedad propiedad){
        boolean result=false;
        float precio = propiedad.getPrecioEdificar();
        if(puedoGastar(precio) && (propiedad.getNumCasas()<getCasasMax()) )
            result = true;
        return result;
    }
    
    //Calcula privadamente si puede edificar hoteles
    protected boolean puedoEdificarHotel(TituloPropiedad propiedad){
        boolean puedoEdificarHotell=false;
        float precio = propiedad.getPrecioEdificar();
        if(puedoGastar(precio) && (propiedad.getNumHoteles()<getHotelesMax()) && (propiedad.getNumCasas()>=getCasasPorHotel()) )
            puedoEdificarHotell = true;
        return puedoEdificarHotell;
    }
    
    
    //Si el jugador no está encarcelado indica si su saldo es mayor que el precio a pagar
    protected boolean puedoGastar(float precio){
        boolean devolver = false;
        if(encarcelado){
            devolver = false;
        }else if(saldo >= precio){
            devolver = true;
        }
        return devolver;
    }
    
    //Si el jugador no está encarcelado recibe la cantidad indicada
    boolean recibe(float cantidad){
        boolean resultado;
        if(encarcelado){
            resultado = false;
        }else{
            resultado = modificarSaldo(cantidad);
        }
        return resultado;
    }
    
    //Si el jugador está encarcelado y puede pagar por salir de la carcel lo hace
    boolean salirCarcelPagando(){
        boolean devolver = false;
        if(encarcelado && puedeSalirCarcelPagando()){
            paga(PrecioLibertad);
            encarcelado = false;
            Diario.getInstance().ocurreEvento(nombre + " ha pagado para salir de la cárcel");
            devolver = true;
        }
        return devolver;
    }
    
    //Se tira el dado para ver si el jugador sale o no de la carcel
    boolean salirCarcelTirando(){
        boolean devolver = false;
        if(Dado.getInstance().salgoDeLaCarcel()){
            encarcelado = false;
            Diario.getInstance().ocurreEvento(nombre + " ha tirado para salir de la cárcel");
            devolver = true;
        }
        return devolver;
    }
    
    //Indica si el jugador tiene propiedades
    boolean tieneAlgoQueGestionar(){
        return (propiedades.size() > 0);
    }
    
    //Indica si el jugador tiene la carta para salir de la carcel
    boolean tieneSalvoconducto(){
        return (salvoconducto != null);
    }
    
    //Imprime la informacion del jugador en cuestión
    @Override
    public String toString(){
        String devolver = "";
        String todas = "";
        String aux;
        for(int i = 0; i < propiedades.size(); ++i){
            aux = propiedades.get(i).getNombre();
            todas = todas + " ";
            todas = todas + aux;
        }
        devolver =  "----------------------------------------------------------------" +
                    CSO.ANSI_CYAN_BACKGROUND + CSO.ANSI_PURPLE +    //Cambio de color
                    "\n         JUGADOR " + getNombre() + ": " + 
                    CSO.ANSI_RESET +                                //Reset de color
                    "\n     -Encarcelado : " + encarcelado+ 
                    "\n     -Puede comprar: " + puedeComprar + 
                    "\n     -Saldo: " + saldo + 
                    "\n     -Número propiedades: " + propiedades.size() + 
                    "\n     -Propiedades: " + todas + 
                    "\n     -Número casilla actual: " + numCasillaActual;
        return devolver;
    }
    
    //Si el jugador no está encarcelado y existe la propiedad se vende la propiedad numero ip
    boolean vender(int ip){
        boolean devolver = false;
        if(encarcelado){
            devolver = false;
        }else if(existeLaPropiedad(ip)){
            TituloPropiedad propiedad = propiedades.get(ip);
            devolver = propiedad.vender(this);
            if(devolver){
                Diario.getInstance().ocurreEvento(nombre + " ha vendido la propiedad " + propiedades.get(ip));
                propiedades.remove(ip);
            }else Diario.getInstance().ocurreEvento(nombre + " no puede vender la propiedad " + propiedades.get(ip));
        }
        return devolver;
    }
       
}