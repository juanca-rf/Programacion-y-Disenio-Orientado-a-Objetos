/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package GUI;

import civitas.CivitasJuego;
import civitas.*;
import civitas.SalidasCarcel;
import java.util.ArrayList;
import java.util.Arrays;

/**
 *
 * @author juanc
 * @author german
 */
public class Controlador {
    private CivitasJuego juego;
    private CivitasView vista;
    
    Controlador(CivitasJuego juego, CivitasView vista){
        this.juego = juego;
        this.vista = vista;
    }
    
    void juega(){
        OperacionesJuego operacion;
        OperacionInmobiliaria opInmobiliaria;
        
        vista.setCivitasJuego(juego);
        
        while(!juego.finalDelJuego()){
            vista.actualizarVista();

            operacion = juego.siguientePaso();
            vista.mostrarSiguienteOperacion( operacion.toString() );

            if( juego.siguientePaso() != OperacionesJuego.PASAR_TURNO )
                vista.mostrarEventos();
            
            if(!juego.finalDelJuego()){
                switch (operacion){
                    case COMPRAR:
                        if( vista.comprar() == Respuestas.SI)
                            juego.comprar();
                        juego.siguientePasoCompletado(operacion);
                        break;
                        
                    case GESTIONAR:
                        vista.gestionar();
                        opInmobiliaria = new OperacionInmobiliaria(GestionesInmobiliarias.values()[vista.getGestion()],vista.getPropiedad());
                        
                        switch(GestionesInmobiliarias.values()[vista.getGestion()]){
                            case VENDER:
                                juego.vender(opInmobiliaria.getNumPropiedad());
                                break;
                                
                            case HIPOTECAR:
                                juego.hipotecar(opInmobiliaria.getNumPropiedad());
                                break;
                                
                            case CANCELAR_HIPOTECA:
                                juego.cancelarHipoteca(opInmobiliaria.getNumPropiedad());
                                break;
                                
                            case CONSTRUIR_CASA:
                                juego.construirCasa(opInmobiliaria.getNumPropiedad());
                                break;
                                
                            case CONSTRUIR_HOTEL:
                                juego.construirHotel(opInmobiliaria.getNumPropiedad());
                                break;
                                
                            case TERMINAR:
                                juego.siguientePasoCompletado(operacion);
                                break;       
                        } 
                        break;
                        
                    case SALIR_CARCEL:                 
                        if( vista.salirCarcel() == SalidasCarcel.PAGANDO )
                            juego.salirCarcelPagando();
                        else juego.salirCarcelTirando();
                        
                        juego.siguientePasoCompletado(operacion);
                        break;
                }
            }
        }
        juego.ranking();
        vista.actualizarVista();
    }   
}
