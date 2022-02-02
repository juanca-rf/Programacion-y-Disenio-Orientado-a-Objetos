# encoding:utf-8

#require './Tipo_sorpresa'

module Civitas
  class Sorpresa
    private_class_method :new
    
    def initialize texto
      @texto = texto
    end
       
    #Comprueba si el primer parametro es un indice valido para acceder a los elementos del segundo
    def jugador_correcto(actual, todos)
      if(actual < todos.length && actual >= 0)
        return true
      else
        return false
      end
    end
    
    #Informa al diario que se está aplicando una sorpresa
    def informe(actual, todos)
      Diario.instance.ocurre_evento("Se está aplicando una sorpresa a" + todos[actual].nombre)
    end
    
    def aplicar_a_jugador(actual, todos)
      #vacio
    end

    
    #Devuelve el nombre de la sorpresa
    def to_s
      return @texto
    end
    
  end
end