/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package GUI;
import civitas.CivitasJuego;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.Arrays;

/**
 *
 * @author juanc
 */
public class JuegoTexto {
    
    public static void main(String[] args) {
        VistaTextual vista = new VistaTextual();
        CivitasJuego civitas;
        Controlador controlador;
        Scanner in = new Scanner(System.in);
        int numJugadores;
        
        ArrayList<String> nombres = new ArrayList<>();
        
        System.out.println("¿Cuantos jugadores quieres?");
        numJugadores = in.nextInt();
        in.nextLine();
        
        if( numJugadores >= 2 && numJugadores <=4 ){
            for(int i = 0; i < numJugadores; i++){
                System.out.println("Nombre del juagdor " + i + ": ");
                nombres.add( in.nextLine() );
            }
            civitas = new CivitasJuego(nombres);
            Dado.getInstance().setDebug(false);
//            controlador = new Controlador(civitas, vista);  
//            controlador.juega();
        }
        else System.err.println("Numero de jugadores erroneo");
    }
}