/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package civitas;
import java.util.ArrayList;
import GUI.Dado;
/**
 * @author juanca
 * @author german
 */
public class CivitasJuego {
    private int indiceJugadorActual;
    private EstadosJuego estado;
    private GestorEstados gestorEstados;
    private ArrayList<Jugador> jugadores;
    private MazoSorpresas mazo;
    private Tablero tablero;
    private final int numCarcel = 5;

    public CivitasJuego(ArrayList<String> nombres){
        estado = EstadosJuego.INICIO_TURNO;
        jugadores = new ArrayList<>();
        for(int i = 0; i < nombres.size(); i++)
            jugadores.add( new Jugador( nombres.get(i) ) );
        
        gestorEstados = new GestorEstados();
        gestorEstados.estadoInicial();
        indiceJugadorActual = Dado.getInstance().quienEmpieza(jugadores.size());
        mazo = new MazoSorpresas();
        inicializarTablero(mazo);
        inicializarMazoSorpresas(tablero);
    }
    
    //Avanza el jugador aplicandole las casillas correspondientes
    private void avanzaJugador(){
        Jugador jugadorActual = getJugadorActual();
        int posicionActual = jugadorActual.getNumCasillaActual();
        int tirada = Dado.getInstance().tirar();
        int posicionNueva = tablero.nuevaPosicion(posicionActual, tirada);
        Casilla casilla = tablero.getCasilla(posicionNueva);
        contabilizarPasosPorSalida(jugadorActual);
        jugadorActual.moverACasilla(posicionNueva);
        casilla.recibeJugador(indiceJugadorActual, jugadores);
        contabilizarPasosPorSalida(jugadorActual);
    }
    
    
    //Llama a cancelarhipoteca del jugador
    public boolean cancelarHipoteca(int ip){
        return jugadores.get(indiceJugadorActual).cancelarHipoteca(ip);
    }
    
    //Devuelve si el jugador actual puede comprar la casilla actual
    public boolean comprar(){
        Jugador jugadorActual = getJugadorActual();
        int numCasillaActual = jugadorActual.getNumCasillaActual();
        CasillaCalle casilla = (CasillaCalle)tablero.getCasilla(numCasillaActual);
        TituloPropiedad titulo = casilla.getTituloPropiedad();
        return jugadorActual.comprar(titulo);
    }
    
    //Llama a construirCasa del jugador
    public boolean construirCasa(int ip){
        return jugadores.get(indiceJugadorActual).construirCasa(ip);
    }
    
    //Llama a construirHotel del jugador
    public boolean construirHotel(int ip){
        return jugadores.get(indiceJugadorActual).construirHotel(ip);
    }
    
    //El jugador cobra por todas las veces que ha pasado por la casilla de salida
    private void contabilizarPasosPorSalida(Jugador jugadorActual){
        while(tablero.getPorSalida() > 0){
            jugadorActual.pasaPorSalida();
        }
    }
    
    //Indica si se acaba el juego (cuando un jugador esté en bancarrota)
    public boolean finalDelJuego(){
        boolean fin = false;
        for(int i = 0; i < jugadores.size() && fin==false; i++){
            if(jugadores.get(i).enBancarrota()){
                fin = true;
            }
        }
        return fin;
    }
    
    //Devuelve la casilla actial del jugador
    public Casilla getCasillaActual(){
        return tablero.getCasilla(jugadores.get(indiceJugadorActual).getNumCasillaActual());
    }
    
    //Devuelve el jugador actual
    public Jugador getJugadorActual(){
        return jugadores.get(indiceJugadorActual);
    }
    
    //Llama al metodo hipotecar de Jugador
    public boolean hipotecar(int ip){
        return jugadores.get(indiceJugadorActual).hipotecar(ip);
    }
    
    //Muestra por pantalla la informacion asociada al jugador
    public String infoJugadorTexto(){
        return jugadores.get(indiceJugadorActual).toString();
    }
    
    //Crea las cartas sorpresa y las añade al mazo
    private void inicializarMazoSorpresas(Tablero tablero){
        //PAGARCOBRAR
        mazo.alMazo(new SorpresaPagarCobrar( 200, "Recibe 200 por herencia"));
        mazo.alMazo(new SorpresaPagarCobrar( -150, "Paga 150 por impuesto de herencia"));
        //IRCASILLA
        mazo.alMazo(new SorpresaCasilla( tablero, 7, "Vas a la calle C7"));
        mazo.alMazo(new SorpresaCasilla( tablero, 12, "Vas a la calle C12"));
        mazo.alMazo(new SorpresaCasilla( tablero, tablero.getCarcel(), "Vas a la carcel"));
        //PORCASAHOTEL
        mazo.alMazo(new SorpresaCasaHotel( 300, "Recibe 300 por tener casa/hotel"));
        mazo.alMazo(new SorpresaCasaHotel( -300, "Paga 300 por tener casa/hotel"));
        //PORJUGADOR
        mazo.alMazo(new SorpresaJugador( 100, "Recibe 100 del jugador"));
        mazo.alMazo(new SorpresaJugador( -100, "Paga 100 al jugador"));
        //SALIRCARCEL
        mazo.alMazo(new SorpresaSalirCarcel( mazo));
        //IRCARCEL
        mazo.alMazo(new SorpresaCarcel(tablero));
        //Conversion
        mazo.alMazo(new SorpresaConvertirEspeculador(1000, "Se convierte jugador a especulador"));
    }
    
    //Crea el tablero añadiendo las casillas
    private void inicializarTablero(MazoSorpresas mazo){
        tablero = new Tablero(numCarcel);
        //SALIDA
        //Salida añadida en constructor de tablero
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C1", 50f, 1.1f, 75f, 150f, 50f)));
        
        //IMPUESTO
        tablero.añadeCasilla(new CasillaImpuesto((float)500, "Impuesto"));
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C2", 75f, 1.1f, 90f, 200f, 75f)));
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C3", 75f, 1.1f, 90f, 200f, 75f)));
        
        //CARCEL
        //Carcel se ha creado automaticamente en numCarcel
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C4", 90f, 1.2f, 120f, 300f, 90f)));
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C5", 90f, 1.2f, 120f, 300f, 90f)));
        
        //SORPRESA
        tablero.añadeCasilla(new CasillaSorpresa(mazo, "SORPRESA1"));
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C6", 110f, 1.2f, 130f, 350f, 110f)));
       
       //PARKING
        tablero.añadeCasilla(new Casilla("Parking"));
       
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C7", 150f, 1.3f, 160f, 450f, 150f)));
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C8", 150f, 1.3f, 160f, 450f, 150f)));
        
        //SORPRESA
        tablero.añadeCasilla(new CasillaSorpresa(mazo, "SORPRESA2"));
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C9", 170f, 1.3f, 190f, 500f, 170f)));
        
        //JUEZ
        tablero.añadeJuez();
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C10", 220f, 1.4f, 250f, 700f, 220f)));
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C11", 220f, 1.4f, 250f, 700f, 220f)));
       
        //SORPRESA
        tablero.añadeCasilla(new CasillaSorpresa(mazo, "SORPRESA3"));
        
        //CALLE
        tablero.añadeCasilla(new CasillaCalle(new TituloPropiedad("C12", 260f, 1.5f, 300f, 1000f, 260f)));
               
        //Imprimir casillas para comprobar que se crean bien
        //tablero.printcasillas();
    }
    
    //Actualiza el indice del jugador actual
    private void pasarTurno(){
        if(indiceJugadorActual < (jugadores.size()-1) ){
            indiceJugadorActual ++;
        }else{
            indiceJugadorActual = 0;
        }
    }
    
    //Produce una lista de los jugadores en funcion de su saldo
    public ArrayList <Jugador> ranking(){
        ArrayList <Jugador> ranking = new ArrayList<Jugador>();
        for(int i = 0; i < jugadores.size(); ++i)
            ranking.add(jugadores.get(i));
        
        for(int i = 0; i < ranking.size() - 1; ++i){
            for(int j = i + 1; j < ranking.size(); ++j){
                if(ranking.get(i).compareTo(ranking.get(j)) < 0){
                    Jugador aux = new Jugador(ranking.get(i));
                    ranking.set(i, ranking.get(j));
                    ranking.set(j, aux);
                }
            }
        }
        return ranking;
    }
    
    //Llama a salirCarcelPagando de la clase jugador
    public boolean salirCarcelPagando(){
        return jugadores.get(indiceJugadorActual).salirCarcelPagando();
    }
    
    //Llama a salirCarcelTirando de la clase jugador
    public boolean salirCarcelTirando(){
        return jugadores.get(indiceJugadorActual).salirCarcelTirando();
    }
    
    //Realiza el siguiente paso del jugador activo dependiendo de las operaciones del juego
    public OperacionesJuego siguientePaso(){
        Jugador actual = getJugadorActual();
        OperacionesJuego operacion = gestorEstados.operacionesPermitidas(actual, estado);
        if(operacion == OperacionesJuego.PASAR_TURNO){
            pasarTurno();
            siguientePasoCompletado(operacion);
        }
        if(operacion == OperacionesJuego.AVANZAR){
            avanzaJugador();
            siguientePasoCompletado(operacion);
        }
        return operacion;
    }
    
    //Se actualiza el estado del juego, obteniendo el siguiente estado
    public void siguientePasoCompletado(OperacionesJuego operacion){
        estado = gestorEstados.siguienteEstado(jugadores.get(indiceJugadorActual), estado, operacion);
    }
    
    //Llama al metodo vender de Jugador
    public boolean vender(int ip){
        return jugadores.get(indiceJugadorActual).vender(ip);
    }    
}