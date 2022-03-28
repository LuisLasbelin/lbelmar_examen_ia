(deffacts fabrica
    (palets cantidad 4)
    (movimientos 20)
    (fabrica robot pos 0 cajas maxcajas 3 pedido naranjas naranjas naranjas uva manzanas manzanas lineapedido palets palet 1 naranjas stock 5 palet 2 manzanas stock 5 palet 3 caquis stock 6 palet 4 uva stock 8 movimientos 0)
)

(defrule terminar-pedido
    (salience 99)
    (fabrica robot pos ?pos cajas $?cajas maxcajas ?maxcajas pedido $?pedido lineapedido $?lineapedido palets $?palets)
    (test (eq $?pedido $?lineapedido))
    =>
    (halt)
)

(defrule dejar-cajas
    (salience 10)
    (fabrica robot pos ?pos cajas $?cajas maxcajas ?maxcajas pedido $?inip ?tipopedido $?finp lineapedido $?lineapedido palets $?ini palet ?pospalet ?tipo stock ?stock $?fin movimientos ?movs)
    (movimientos ?maxmovs)
    (test (< ?movs ?maxmovs))
    ; la linea de pedido es la posicion 0
    (test (= ?pos 0))
    ; tiene que tener al menos una caja encima
    (test (> (length$ $?cajas) 0))
    =>
    ; quita las cajas del robot y las pone en la linea de pedido
    (assert (fabrica robot pos ?pos cajas maxcajas ?maxcajas pedido $?inip ?tipopedido $?finp lineapedido $?lineapedido $?cajas palets $?ini palet ?pospalet ?tipo stock ?stock $?fin movimientos (+ ?movs 1)))
)

(defrule recoger-caja
    (fabrica robot pos ?pos cajas $?cajas maxcajas ?maxcajas pedido $?inip ?tipopedido $?finp lineapedido $?lineapedido palets $?ini palet ?pospalet ?tipo stock ?stock $?fin movimientos ?movs)
    (movimientos ?maxmovs)
    (test (< ?movs ?maxmovs))
    ; comprobaciones de que el palet en el que está el robot está en los pedidos
    (test (= ?pos ?pospalet))
    (test (eq ?tipo ?tipopedido))
    ; comprueba que haya cajas y pueda coger una
    (test (>= ?stock 1))
    (test (< (length$ $?cajas) ?maxcajas))
    =>
    ; se añade la caja al robot y se resta del stock del palet y del pedido
    (assert (fabrica robot pos ?pos cajas $?cajas ?tipo maxcajas ?maxcajas pedido $?inip ?tipopedido $?finp lineapedido $?lineapedido palets $?ini palet ?pospalet ?tipo stock (- ?stock 1) $?fin movimientos (+ ?movs 1)))
)


(defrule mover-derecha
    (fabrica robot pos ?pos $?resto movimientos ?movs)
    (palets cantidad ?cantidad)
    (movimientos ?maxmovs)
    (test (<= (+ ?pos 1) ?cantidad))
    (test (< ?movs ?maxmovs))
    =>
    (assert (fabrica robot pos (+ ?pos 1) $?resto movimientos (+ ?movs 1)))
)

(defrule mover-izquierda
    (fabrica robot pos ?pos $?resto movimientos ?movs)
    (palets cantidad ?cantidad)
    (movimientos ?maxmovs)
    (test (< ?movs ?maxmovs))
    (test (>= (- ?pos 1) 0))
    =>
    (assert (fabrica robot pos (- ?pos 1) $?resto movimientos (+ ?movs 1)))
)