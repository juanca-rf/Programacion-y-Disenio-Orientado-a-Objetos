# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module Civitas
  class Operacion_inmobiliaria
    attr_reader :gestion
    attr_reader :num_propiedad
      
    def initialize (gest, ip)
      @gestion = gest
      @num_propiedad = ip
    end
  end
end