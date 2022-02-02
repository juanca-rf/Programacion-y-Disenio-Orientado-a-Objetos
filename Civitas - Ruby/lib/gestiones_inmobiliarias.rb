# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  module Gestiones_inmobiliarias
    Lista = [
      VENDER = :vender,
      HIPOTECAR = :hipotecar,
      CANCELAR_HIPOTECA = :cancelar_hipoteca,
      CONSTRUIR_CASA = :construir_casa,
      CONSTRUIR_HOTEL = :construir_hotel,
      TERMINAR = :terminar
    ]
   end
   Lista_gestiones_inmobiliarias = Gestiones_inmobiliarias::Lista
end
