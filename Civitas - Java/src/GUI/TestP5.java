/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package GUI;

import java.util.ArrayList;
import civitas.*;


/**
 *
 * @author juanc
 */
public class TestP5 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        CivitasView vista = new CivitasView();
        Dado.createInstance(vista);
        Dado dado = Dado.getInstance();
        dado.setDebug(Boolean.FALSE);
        CapturaNombres nombre = new CapturaNombres(vista, true);
        ArrayList<String> nombres = nombre.getNombres();
        CivitasJuego juego = new CivitasJuego(nombres);
        Controlador controlador = new Controlador(juego, vista);
        vista.setCivitasJuego(juego);
        vista.actualizarVista();
        controlador.juega();
    }
    
}
