# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.



module Civitas
  class Sorpresa_convertir_especulador < Sorpresa
    public_class_method :new
    def initialize(valor, texto)
      super texto
      @valor = valor
    end
    
    def aplicar_a_jugador(actual, todos)  
      informe(actual, todos)
      todos[actual] = todos[actual].convertir_especulador @valor
    end
    
  end
end
