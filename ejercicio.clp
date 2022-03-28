(deffacts fabrica
    (pedido cajas naranjas 2 cajas manzanas 3 cajas uva 1)
    (palets cantidad 4)
    (fabrica robot pos 0 cajas maxcajas 3 lineapedido palet 1 naranjas stock 5 palet 2 manzanas stock 5 palet 3 caquis stock 6 palet 4 uva stock 8)
)

(defrule mover-derecha
    (fabrica robot pos ?pos $?resto)
    (palets cantidad ?cantidad)
    (test (<= (+ ?pos 1) ?cantidad))
    =>
    (assert (fabrica robot pos (+ ?pos 1) $?resto))
)

(defrule mover-izquierda
    (fabrica robot pos ?pos $?resto)
    (palets cantidad ?cantidad)
    (test (<= (- ?pos 1) ?cantidad))
    =>
    (assert (fabrica robot pos (- ?pos 1) $?resto))
)

(defrule recoger-caja
    (fabrica robot pos ?pos cajas $?cajas maxcajas ?maxcajas lineapedido $?lineapedido palet $?ini palet ?pospalet ?tipo stock ?stock $?fin)
    (pedido $?inip cajas ?tipopedido ?cantidadpedido $?finp)
    ; comprobaciones de que el palet en el que está el robot está en los pedidos
    (test (= ?pos ?pospalet))
    (test (= ?tipo ?tipopedido))
    ; comprueba que haya cajas y pueda coger una
    (test (>= ?cantidad 1))
    (test (< (length$ $?cajas) ?maxcajas))
    =>
    ; se añade la caja al robot y se resta del stock del palet
    (assert (fabrica robot pos ?pos cajas $?cajas ?tipo maxcajas ?maxcajas lineapedido $?lineapedido palet $?ini palet ?pospalet ?tipo stock (- ?stock 1) $?fin))
)