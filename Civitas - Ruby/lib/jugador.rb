#encoding:utf-8

module Civitas
  class Jugador
    attr_reader :nombre, 
      :num_casilla_actual,
      :casas_max, 
      :casas_por_hotel, 
      :hoteles_max, 
      :precio_libertad, 
      :paso_por_salida, 
      :propiedades,
      :puede_comprar, 
      :saldo, 
      :encarcelado,
      :salvoconducto
    
    @@casas_max = 4
    @@casas_por_hotel = 4
    @@hoteles_max = 4
    @@paso_por_salida = 1000
    @@precio_libertad = 200
    @@saldo_inicial = 7500
    
    def initialize nombre
      @nombre             = nombre
      @propiedades        = Array.new
      @saldo              = @@saldo_inicial
      @num_casilla_actual = 0
      @puede_comprar      = true
      @salvoconducto      = nil
      @encarcelado        = false
    end
    
    #modificado
    def copia otro
      @nombre             = otro.nombre
      @propiedades        = otro.propiedades
      @saldo              = otro.saldo
      @num_casilla_actual = otro.num_casilla_actual
      @puede_comprar      = otro.puede_comprar
      @salvoconducto      = otro.salvoconducto
      @encarcelado        = otro.encarcelado
    end
    
    def convertir_especulador fianza
      return Jugador_especulador.nuevo_especulador(self , fianza)
    end

    #
    def cancelar_hipoteca ip
      devolver = false
        if( !@encarcelado && existe_la_propiedad(ip) )
            propiedad = @propiedades[ip]
            cantidad = propiedad.get_importe_cancelar_hipoteca
            if(puedo_gastar(cantidad))
                devolver = propiedad.cancelar_hipoteca(self)
            end
            if(devolver)
                Diario.instance.ocurre_evento("El jugador" + @nombre + " cancela la hipoteca de la propiedad " + ip.to_s )
            end  
        end
        return devolver;
    end
    
    # Devuelve la cantidad de casas y hoteles que tiene el jugador
    def cantidad_casas_hoteles
      total = 0
      @propiedades.each do |i|
        total += i.cantidad_casas_hoteles
      end
      return total
    end
    
    #Compara los saldos
    def <=>(otro)
      @saldo <=> otro.saldo      
    end
    
    #nuevo
    def comprar titulo
      result = false
      if( !@encarcelado && @puede_comprar )
          precio = titulo.precio_compra
          if( puedo_gastar(precio) )
              result = titulo.comprar(self)
              if(result)
                  @propiedades.push(titulo)
                  Diario.instance.ocurre_evento("El jugador " + @nombre + " compra la propiedad " + titulo.to_s)
              end
              @puede_comprar = false
          end
      end
      return result
    end
    
    #no implementado###################################################### hecho
    def construir_casa ip
      devolver = false  
      
      if( !@encarcelado && existe_la_propiedad(ip) )
          propiedad = @propiedades[ip]

          if(puedo_edificar_casa(propiedad))
              devolver = propiedad.construir_casa(self);
          end
          
          if(devolver)
              Diario.instance.ocurre_evento("El jugador " + @nombre + " construye casa en la propiedad " + ip.to_s)
          end
      end
      
      return devolver
    end
    
    #no implementado######################################################
    def construir_hotel ip
      devolver = false   
      if( !@encarcelado && existe_la_propiedad(ip) )
          propiedad = @propiedades[ip]
          
          if(puedo_edificar_hotel(propiedad))
              devolver = propiedad.construir_hotel(self)
              propiedad.derruir_casas(@@casas_por_hotel, self)
              Diario.instance.ocurre_evento("El jugador " + @nombre + " construye hotel en la propiedad " + ip.to_s);
          end     
      end
      return devolver;
    end
    
    #Devuelve false si el jugador está encarcelado y true si no tiene la carta que le evita ir a la carcel
    def debe_ser_encarcelado
      if @encarcelado
        devolver = false
      elsif @salvoconducto != nil
        perder_salvoconducto
        devolver = false
        Diario.instance.ocurre_evento("\nEl jugador " + @nombre + " usa la carta Salvoconducto y no va a la cárcel.")
      else
        devolver = true
      end
      return devolver  
    end
    
    # Devuelve true si el jugador tiene saldo negativo
    def en_bancarrota
      return saldo < 0
    end
    
    # Lleva al jugador a la casilla de la carcel
    def encarcelar casilla_carcel
      if debe_ser_encarcelado
        mover_a_casilla(casilla_carcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("El jugador " + @nombre + " ha sido encarcelado.")
      end
      return @encarcelado
    end
    
    # Devuelve true si existe la propiedad pasada como parámetro
    def existe_la_propiedad ip
      return (ip>=0 && ip<@propiedades.size)
    end
    
    #no implementar######################################################
    def hipotecar ip
      devolver = false; 
      if( !@encarcelado && existe_la_propiedad(ip) )
          propiedad = @propiedades[ip]
          devolver = propiedad.hipotecar(self);
      end
      if(devolver)
          Diario.instance.ocurre_evento("El jugador " + @nombre + " hipoteca la propiedad " + ip.to_s)
      end
      return devolver
    end
    
    #Incrementa el saldo del jugador
    def modificar_saldo cantidad
      @saldo += cantidad
      Diario.instance.ocurre_evento("Se ha modificado el saldo del jugador " + @nombre)
      return true
    end
    
    #Devuelve false si está encarcelado, si no se cambia la casilla en la que está el jugador
    def mover_a_casilla num_casilla
      devolver = false
      if !@encarcelado
        @puede_comprar = false
        Diario.instance.ocurre_evento("#{@nombre} se ha movido de #{@num_casilla_actual} a #{num_casilla}")
        @num_casilla_actual = num_casilla
        devolver = true
      end
      return devolver
    end
    
    #Si el jugador no está encarcelado se guarda la sorpresa en salvoconducto
    def obtener_salvoconducto sorpresa
      devolver = false
      if !@encarcelado
        @salvoconducto = sorpresa
        devolver = true
      end
      return devolver
    end
    
    #Paga la cantidad pasada como parámetro
    def paga cantidad
      return modificar_saldo (cantidad*-1)
    end
    
    # Paga el precio de alquiler
    def paga_alquiler cantidad
        devolver = false
        if @encarcelado
            devolver = false
        else
            devolver = paga(cantidad)
        end
        return devolver;
    end
    
    #Si el jugador no está encarcelado paga la cantidad pasada como parámetro
    def paga_impuesto cantidad
        devolver = false
        if @encarcelado
            devolver = false
        else
            devolver = paga(cantidad)
        end
        return devolver
    end
    
    #Incrementa el saldo con PasoPorSalida
    def pasa_por_salida
      modificar_saldo(@@paso_por_salida)
      Diario.instance.ocurre_evento("El jugador " + @nombre + " ha pasado por la salida y cobrado por ello")
      return true
    end
    
    #El jugador pierde la carta salvoconducto
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto = nil
    end
    
    #Devuelve si el jugador puede o no comprar 
    def puede_comprar_casilla
      @puede_comprar = !@encarcelado
      return @puede_comprar
    end
    
    #Indica si el saldo del jugador es mayor al precio para salir de la carcel
    def puede_salir_carcel_pagando
      return (@saldo >= @@precio_libertad)
    end
    
    #*************************************************************
    def puedo_edificar_casa propiedad
      result=false
      precio = propiedad.precio_edificar
      if( puedo_gastar(precio) && ( propiedad.num_casas < @@casas_max ) )
          result = true
      end
      return result;
    end
    
    #*************************************************************
    def puedo_edificar_hotel propiedad
      puedo_edificar_hotell = false
      precio = propiedad.precio_edificar
      
      if( puedo_gastar(precio) && (propiedad.num_hoteles < @@hoteles_max) && (propiedad.num_casas >= @@casas_por_hotel) )
          puedo_edificar_hotell = true
      end
      
      return puedo_edificar_hotell
    end
    
    #Si el jugador no está encarcelado indica si su saldo es mayor que el precio a pagar
    def puedo_gastar precio
      if(@encarcelado)
        devolver = false
      elsif(@saldo >= precio)
        devolver = true
      end
      return devolver
    end
    
    #Si el jugador no está encarcelado recibe la cantidad indicada
    def recibe cantidad
      if(@encarcelado)
        resultado = false
      else resultado = modificar_saldo(cantidad)
      end
      return resultado
    end
    
    #Si el jugador está encarcelado y puede pagar por salir de la carcel lo hace
    def salir_carcel_pagando
      devolver = false
      if(@encarcelado && puede_salir_carcel_pagando)
        paga(@@precio_libertad)
        @encarcelado = false
        Diario.instance.ocurre_evento(@nombre + " ha pagado para salir de la cárcel")
        devolver = true
      end
      return devolver
    end
    
    #Se tira el dado para ver si el jugador sale o no de la carcel
    def salir_carcel_tirando
      devolver = false
      if(Dado.instance.salgo_de_la_carcel)
        @encarcelado = false
        Diario.instance.ocurre_evento(@nombre + " ha tirado para salir de la cárcel")
        devolver = true
      end
      return devolver
    end
    
    #Indica si el jugador tiene propiedades
    def tiene_algo_que_gestionar
      return (@propiedades.size > 0)
    end
    
    #Indica si el jugador tiene la carta para salir de la carcel
    def tiene_salvoconducto
      return (@salvoconducto != nil)
    end
    
    #Imprime la informacion del jugador en cuestión
    def to_s
      devolver = ""
      todas = Array.new
      
      @propiedades.each do |propiedad|
        todas <<  (" " + propiedad.nombre)
      end
      
      devolver =   "\n             JUGADOR #{@nombre}  :\nEncarcelado : #{@encarcelado}\nPuede comprar: #{@puede_comprar }\nSaldo: #{@saldo }\nNumero propiedades: #{@propiedades.length}\nPropiedades: " + todas.to_s + "\nNumero casilla actual: #{@num_casilla_actual}"
                  
      return devolver
    end
    
    #Si el jugador no está encarcelado y existe la propiedad se vende la propiedad numero ip ************************
    def vender ip
      if(@encarcelado)
        devolver = false
      else if (existe_la_propiedad(ip))
          propiedad = @propiedades[ip]
          devolver = propiedad.vender(self)
          Diario.instance.ocurre_evento(@nombre + " ha vendido la propiedad " + @propiedades[ip].to_s)
          @propiedades.delete_at(ip)
        end
      end
      return devolver
    end
    
  end
end