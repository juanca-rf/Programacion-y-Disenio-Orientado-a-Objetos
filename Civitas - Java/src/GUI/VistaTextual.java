package GUI;

import civitas.CivitasJuego;
import civitas.Diario;
import civitas.OperacionesJuego;
import civitas.GestionesInmobiliarias;
import civitas.SalidasCarcel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;
import civitas.Casilla;
import civitas.Jugador;
import civitas.OperacionInmobiliaria;
import civitas.TituloPropiedad;


class VistaTextual {
  
  CivitasJuego juegoModel; 
  int iGestion=-1;
  int iPropiedad=-1;
  private static String separador = "=====================";
  
  private Scanner in;
  
  VistaTextual () {
    in = new Scanner (System.in);
  }
  
  void mostrarEstado(String estado) {
    System.out.println (estado);
  }
              
  void pausa() {
    System.out.print (CSO.ANSI_RED_BACKGROUND + "Pulsa una tecla" + CSO.ANSI_RESET );
    in.nextLine();
  }

  int leeEntero (int max, String msg1, String msg2) {
    Boolean ok;
    String cadena;
    int numero = -1;
    do {
      System.out.print (msg1);
      cadena = in.nextLine();
      try {  
        numero = Integer.parseInt(cadena);
        ok = true;
      } catch (NumberFormatException e) { // No se ha introducido un entero
        System.out.println (msg2);
        ok = false;  
      }
      if (ok && (numero < 0 || numero >= max)) {
        System.out.println (msg2);
        ok = false;
      }
    } while (!ok);

    return numero;
  }

  int menu (String titulo, ArrayList<String> lista) {
    String tab = "  ";
    int opcion;
    System.out.println (titulo);
    for (int i = 0; i < lista.size(); i++) {
      System.out.println (tab+i+"-"+lista.get(i));
    }

    opcion = leeEntero(lista.size(),
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo");
    return opcion;
  }

  SalidasCarcel salirCarcel() {
    int opcion = menu ("Elige la forma para intentar salir de la carcel",
      new ArrayList<> (Arrays.asList("Pagando","Tirando el dado")));
    return (SalidasCarcel.values()[opcion]);
  }

  Respuestas comprar() {
    int opcion = menu(  "¿Quieres comprar la calle?: "
                      + juegoModel.getCasillaActual().toString()
                      , new ArrayList<> (Arrays.asList("NO","SI")));
    return Respuestas.values()[opcion];
  }

  void gestionar () {
    ArrayList<String> lista_propiedades = new ArrayList<>();
    
    iGestion = menu("Elige tipo de gestion a realizar:",
              new ArrayList<> (Arrays.asList(
                      "VENDER",             
                      "HIPOTECAR",
                      "CANCELAR_HIPOTECA",
                      "CONSTRUIR_CASA",
                      "CONSTRUIR_HOTEL",
                      "TERMINAR"
                      )));
    if(GestionesInmobiliarias.values()[iGestion] != GestionesInmobiliarias.TERMINAR){
        for(TituloPropiedad propiedad : juegoModel.getJugadorActual().getPropiedades())
            lista_propiedades.add(propiedad.toString());
        iPropiedad = menu("Selecciona propiedad a gestionar: ", lista_propiedades);
    }
  }
  
  public int getGestion(){
      return iGestion;
  }
  
  public int getPropiedad(){
      return iPropiedad;
  }
    
  void mostrarSiguienteOperacion(OperacionesJuego operacion) {
      System.out.println ("Siguiente operacion a realizar es: " + operacion.name() ); 
  }

  void mostrarEventos() {
      while( Diario.getInstance().eventosPendientes() )
          System.out.println ( CSO.ANSI_YELLOW_BACKGROUND+ CSO.ANSI_PURPLE +Diario.getInstance().leerEvento() + CSO.ANSI_RESET );   
  }
  
  public void setCivitasJuego(CivitasJuego civitas){ 
        juegoModel=civitas;
        //this.actualizarVista();

    }
  
  void actualizarVista(){
        this.mostrarEstado(
             juegoModel.infoJugadorTexto()
            + "\n En la Casilla: "
            + juegoModel.getCasillaActual().getNombre()
            + "\n----------------------------------------------------------------"
        );
  } 
}
