# Civitas

Civitas es el juego recreado en la asignatura Programación y Diseño Orientado a Objetos el cual recrea el famoso Monopoly. Éste ha sido implementado con el entorno de desarrollo NetBeans 8.2, se recomienda su instalación en esa versión si se quiere probar su funcionamiento.

## El juego

El siguiente texto se ha extraido del guion de la practica por el profesorado:

> En Civitas hay un tablero con 20 casillas de distintos tipos, un dado de 6 caras, casas, hoteles y tarjetas sorpresa y pueden jugar de 2 a 4 jugadores. Los jugadores tratarán de amasar una gran cantidad de dinero hasta que alguno caiga en bancarrota. En ese momento se nombra al ganador, que será el que tenga mayor capital.
>
> Todos los jugadores comienzan en la primera casilla (SALIDA) y tienen un saldo inicial de 7.500€. El primero en jugar se determina por sorteo (de forma aleatoria). En adelante, los jugadores irán recibiendo el turno consecutivamente. Cuando se llegue al último, retomará el turno el primero en jugar y así sucesivamente siempre en el mismo orden. 
>
> Cuando le toque el turno, el jugador tirará el dado y avanzará en el tablero tantas posiciones como indique el mismo. Según sea el tipo de la casilla a la que va a parar, tendrá derecho a comprar títulos de propiedad, estará obligado a pagar alquileres o impuestos, tendrá que descubrir una tarjeta sorpresa o se podrá ver obligado a ir a la cárcel, tal y como se explica más adelante
>
> El juego acaba cuando algún jugador cae en bancarrota, lo que implica que ese jugador queda con un saldo negativo. Cuando esto ocurre, se calcula un ranking de los jugadores según su saldo, siendo el ganador el jugador con mayor saldo. No influyen por tanto las propiedades de las que dispone cada jugador para establecer si está o no en bancarrota o para determinar si es el ganador de la partida.
>
> ### Casillas
>
> Cada posición del tablero del juego corresponde a una casilla. Hay 7 tipos de casillas: SALIDA, CALLE, SORPRESA, JUEZ, CÁRCEL, IMPUESTO y PARKING. Sólo las de tipo CALLE tienen títulos de propiedad. 
>
> El título de propiedad indica información referente al precio de compra, el precio de edificación, factor de revalorización de la venta, precio base del alquiler, precio base de hipoteca y nombre de la calle asociada a dicha casilla. El título de propiedad de una casilla es el objeto de las compras y ventas, de forma que podemos decir que un jugador es “propietario de una casilla” cuando es propietario de su título de propiedad.
>
> ### Eventos
>
> #### SALIDA 
>
> Hay una única casilla de este tipo y está al inicio del tablero. Es la casilla desde la que parten todos los jugadores al inicio de la partida.
>
> Cada vez que un jugador pasa por la casilla de SALIDA se le abonan 1.000€, a no ser que sea para ir a la cárcel, en cuyo caso no recibe dinero aunque haya pasado por la SALIDA. Es importante resaltar que el hecho que hace merecedores a los jugadores de la cantidad anteriormente indicada es que se le ha dado una vuelta completa al tablero y no el hecho de llegar a la salida en sí.
>
> #### CALLE 
>
> Hay 12 casillas de tipo calle en el juego y cada una tiene asociado un título de propiedad. El coste de la casilla se toma del precio de compra de su título de propiedad. Cuando un jugador va a parar a una de estas casillas puede ocurrir:
>
> - Que la casilla no tenga dueño. El jugador tendrá la opción de comprar su título de propiedad. Si lo compra, el jugador será el propietario de esa casilla.
> - Que otro jugador sea el dueño de la casilla. El jugador tendrá que pagar el alquiler correspondiente al propietario de la casilla.
>
> #### SORPRESA 
>
> Hay 3 casillas de tipo SORPRESA. Cuando un jugador cae en una casilla sorpresa, levantará una carta del mazo de sorpresas y tendrá que hacer lo que esta indique. Si la carta es la de evitar la cárcel, se la podrá guardar para usarla más adelante. Todas las demás se tienen que devolver al mazo una vez cumplida la acción especificada en ellas.
>
> #### JUEZ 
>
> Hay una única casilla de este tipo. Cuando un jugador cae en esta casilla, el juez le envía a la cárcel y el jugador debe irse a la casilla CÁRCEL del tablero.
>
> #### CÁRCEL 
>
> Hay una única casilla de este tipo. En esta casilla estarán los jugadores que han sido enviados a la cárcel explícitamente. Si un jugador simplemente pasa por ella o cae en ella al tirar el dado, no se verá encarcelado y no tendrá que realizar ninguna acción.
>
> #### IMPUESTO 
>
> Cada vez que se caiga en una casilla de este tipo, el jugador verá decrementado su saldo en la cantidad que indique el coste de la casilla. Hay una sola casilla de este tipo en el juego.
>
> #### PARKING 
>
> En esta casilla no hay que hacer nada, se trata simplemente de un lugar de descanso. Hay una sola casilla de este tipo en el juego.
>
> ### Compra-venta de títulos de propiedades
>
> *Compra:* Se podrá hacer sólo cuando el jugador caiga en la casilla cuyo título de propiedad quiere comprar y siempre que se cumplan estas dos condiciones: la casilla no debe tener ya dueño y el jugador debe tener un saldo superior o igual al precio de compra.
>
> *Venta:* Un jugador en su turno podrá vender el título de propiedad de cualquiera de las casillas de las que sea propietario (sin tener que estar posicionado sobre ella). El precio de venta será el precio el precio de compra del título de propiedad más el número de edificaciones (casas y hoteles) multiplicado por el precio por edificar y un factor de revalorización. Este último factor puede reflejar una revalorización mediante un número entre [1,x] o también reflejar una devaluación mediante un número del intervalo [0,1].
>
> `PrecioVenta = PrecioCompra+(NumCasas+5*NumHoteles)*PrecioPorEdificar*FactorRevalorización`
>
> Tras la venta, el título de propiedad deja de ser del jugador y la casilla por tanto dejará de tener dueño. Adicionalmente, la venta implica la eliminación de las edificaciones.
>
> ### Edificación de casas y hoteles
>
> Un jugador en su turno puede edificar en cualquier casilla de su propiedad (aunque no esté posicionado sobre ella en ese momento). El número máximo tanto de casas como de hoteles que se pueden edificar en una misma casilla es 4. Es decir, como máximo habrá 8 edificios: 4 casas y 4 hoteles). 
>
> Para edificar una casa, deberá pagarse el precio de edificación que se especifica en el título de propiedad de la casilla. Los hoteles se edifican a cambio de 4 casas edificadas en la casilla más el coste de edificación que se indique en el título de propiedad. Sólo se podrá edificar cuando lo permita el saldo del jugador.
>
> ### Pagar alquiler
>
> Cuando un jugador cae en una casilla con dueño, debe pagar un alquiler. El alquiler se calcula como la suma del alquiler base indicado en el título de propiedad de la casilla, más el precio a pagar correspondiente a cada casa y hotel edificados en dicha casilla.
>
> `PrecioAlquiler=AlquilerBase*(1+(NumCasas*0.5)+(NumHoteles*2.5))`
>
> En el caso de que no tuviera dinero para pagar, entraría en bancarrota y acabaría el juego (no se le da opción a aumentar el saldo hipotecando o vendiendo propiedades).
>
> El alquiler lo recibirá el dueño del título de propiedad de la casilla a no ser que tenga la casilla hipotecada o se encuentre en la cárcel, en cuyo caso el jugador que tiene el turno se ve exento del pago del alquiler.
>
> ### Hipotecar y cancelar hipoteca
>
> Un jugador podrá hipotecar el título de propiedad de una casilla de la cual sea dueño siempre que esté en su turno (no hace falta que esté en esa casilla) y aunque en ese momento no le haga falta el dinero. La cantidad recibida al hipotecar una propiedad se calcula de la siguiente forma:
>
> `CantidadRecibida=HipotecaBase*(1+(numCasas*0.5)+(numHoteles*2.5))`
>
> De la misma forma, un jugador podrá cancelar una hipoteca siempre que esté en su turno (aunque no esté en esa casilla). Para ello tendrá que pagar la cantidad recibida al hipotecar más un 10%.
>
> ### Entrar y salir de la cárcel
>
> Cuando un jugador es enviado a la cárcel mediante una carta sorpresa que se lo indique o porque haya caído en la casilla JUEZ, tendrá que desplazarse a la casilla CÁRCEL, a no ser que posea una carta sorpresa de tipo SALIRCARCEL, en cuyo caso se verá exento de ir. Una vez usada la carta para no ir a la cárcel, el jugador debe devolverla al mazo de cartas sorpresa.
>
> Independientemente de donde se encuentre, en su tránsito hacia la cárcel no podrá cobrar el paso por la SALIDA y no podrá seguir jugando en ese turno.
>
> Cuando le vuelva a tocar el turno, puede intentar salir pagando 200€ o tirando el dado y sacando un número mayor o igual que 5. Si no logra salir, no podrá seguir jugando en ese turno.
>
> ### Cartas sorpresa
>
> Cuando un jugador cae en una casilla de tipo SORPRESA debe coger una carta sorpresa y hacer lo que se indique en ella. En el mazo de cartas Sorpresa hay 10 cartas de 5 tipos diferentes como muestra la tabla siguiente. En la mayoría de ellas se necesita conocer un valor indicado en la propia carta cuya interpretación es diferente según el tipo de carta.
>
> | Tipo de carta sorpresa | Qué debe hacer el jugador cuando le toca                     | Significado del valor de la carta                            | Cuántas hay en el juego                  |
> | ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------- |
> | PAGARCOBRAR            | Sumar o restar una cantidad a su saldo                       | Cantidad a sumar o restar según el valor sea positivo o negativo | 2 (una positiva y otra negativa)         |
> | IRCASILLA              | Ir a una casilla                                             | Número de la casilla a donde se debe trasladar el jugador    | 3 (una de ellas para enviar a la cárcel) |
> | PORCASAHOTEL           | El jugador cobra o paga por cada casa y hotel de su propiedad | Cantidad que debe pagar o cobrar el jugador por casa y hotel que tenga en sus propiedades | 2 (una positiva y otra negativa)         |
> | PORJUGADOR             | El jugador recibe dinero de o paga dinero a cada uno de los demás jugadores | Cantidad que el jugador debe pagar a o recibir de cada uno de los demás jugadores | 2 (una positiva y otra negativa)         |
> | SALIRCARCEL            | El jugador sale de la cárcel si cae en ella y tiene esta carta sorpresa. | No es aplicable                                              | 1                                        |
> | IRCARCEL               | Ir a la casilla “Cárcel”                                     | No es aplicable                                              | 1                                        |



## Versión en Java

La versión en java incluye la ejecución en un entorno de ventanas, programadas en el propio java, para simular el juego. Cabe destacar que no está terminado, el objetivo final era conseguir la representación del tablero pero solo se ha llevado la salida de texto de los eventos a una ventana emergente.

## Versión en Ruby

El funcionamiento es el mismo que en Java pero con dos salvedades. La primera es que no hay un entorno grafico, el juego se ejecuta en modo texto (igual que versiones primitivas del anterior) y la segunda es que alguna funcionalidad no está implementada.

