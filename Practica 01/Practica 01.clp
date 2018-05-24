;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Definicion de Templates ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Template para las Habitaciones
(deftemplate Habitacion 
	(field hab)
)

;;; Template para las Puertas
;;; Se considera que las Habitaciones se conectan
;;; A traves del Pasillo
(deftemplate Puerta 
	(field hab1)
	(field hab2)
)

;;; Template para los Empleados
(deftemplate Empleado 
	(field empl)
	(field hab)
)

;;; Template para las Tareas (TG y TE)
;;; Se relacionan con los Empleados
(deftemplate Tarea 
	(field empl)
	(field tipo)
)

;;; Template para las Colas
;;; Hay dos tipos (TE y TG)
;;; Hay dos por tipo (Total y Atendidos)
(deftemplate Cola
	(field nombre)
	(field tipo)
	(field cantidad)
)

;;; Template para la Ocupacion
;;; Guarda el ultimo atendido por cada Empleado
(deftemplate Ocupacion
	(field empl)
	(field ultimo)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Definicion de Hechos ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Hechos de las Habitaciones
(deffacts Habitaciones 
	(Habitacion
		(hab Recepcion)
	)
	(Habitacion
		(hab Pasillo)
	)
	(Habitacion
		(hab Oficina1)
	)
	(Habitacion
		(hab Oficina2)
	)
	(Habitacion
		(hab Oficina3)
	)
	(Habitacion
		(hab Oficina4)
	)
	(Habitacion
		(hab Oficina5)
	)
	(Habitacion
		(hab OficinaGerencia)
	)
	(Habitacion
		(hab OficinaDoble)
	)
	(Habitacion
		(hab OficinaPapeleria)
	)
	(Habitacion
		(hab BañoHombres1)
	)
	(Habitacion
		(hab BañoHombres2)
	)
	(Habitacion
		(hab BañoHombres3)
	)
	(Habitacion
		(hab BañoMujeres1)
	)
	(Habitacion
		(hab BañoMujeres2)
	)
	(Habitacion
		(hab BañoMujeres3)
	)
)

;;; Hechos de las Puertas
(deffacts Puertas 
	(Puerta
		(hab1 Recepcion)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 Oficina1)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 Oficina2)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 Oficina3)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 Oficina4)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 Oficina5)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 OficinaGerencia)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 OficinaDoble)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 OficinaPapeleria)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoHombres1)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoHombres2)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoHombres3)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoMujeres1)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoMujeres2)
		(hab2 Pasillo)
	)
	(Puerta
		(hab1 BañoMujeres3)
		(hab2 Pasillo)
	)
)

;;; Hechos de los Empleados
(deffacts Empleados 
	(Empleado
		(empl G1)
		(hab Oficina1)
	)
	(Empleado
		(empl G2)
		(hab Oficina2)
	)
	(Empleado
		(empl G3)
		(hab Oficina3)
	)
	(Empleado
		(empl G4)
		(hab Oficina4)
	)
	(Empleado
		(empl G5)
		(hab Oficina5)
	)
	(Empleado
		(empl E1)
		(hab OficinaDoble)
	)
	(Empleado
		(empl E2)
		(hab OficinaDoble)
	)
)

;;; Hechos de las Tareas
(deffacts Tareas 
	(Tarea
		(empl G1)
		(tipo TG)
	)
	(Tarea
		(empl G2)
		(tipo TG)
	)
	(Tarea
		(empl G3)
		(tipo TG)
	)
	(Tarea
		(empl G4)
		(tipo TG)
	)
	(Tarea
		(empl G5)
		(tipo TG)
	)
	(Tarea
		(empl E1)
		(tipo TE)
	)
	(Tarea
		(empl E2)
		(tipo TE)
	)
)

;;; Hechos de las Colas
(deffacts Colas 
	(Cola
		(nombre Total)
		(tipo TG)
		(cantidad 0)
	)
	(Cola
		(nombre Total)
		(tipo TE)
		(cantidad 0)
	)
	(Cola
		(nombre Atendido)
		(tipo TG)
		(cantidad 0)
	)
	(Cola
		(nombre Atendido)
		(tipo TE)
		(cantidad 0)
	)
)

;;; Hechos de las Ocupaciones
(deffacts Ocupaciones 
	(Ocupacion
		(empl G1)
		(ultimo 0)
	)
	(Ocupacion
		(empl G2)
		(ultimo 0)
	)
	(Ocupacion
		(empl G3)
		(ultimo 0)
	)
	(Ocupacion
		(empl G4)
		(ultimo 0)
	)
	(Ocupacion
		(empl G5)
		(ultimo 0)
	)
	(Ocupacion
		(empl E1)
		(ultimo 0)
	)
	(Ocupacion
		(empl E2)
		(ultimo 0)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Definicion de Funciones ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction system-string (?arg)
	(bind ?arg (str-cat ?arg " > temp.txt"))
	(system ?arg)
	(open "temp.txt" temp "r")
	(bind ?rv (readline temp))
	(close temp)
	?rv)
   
(deffunction hora ()
	(bind ?rv (integer (string-to-field (sub-string 1 2  (system-string "time /t")))))
	?rv)
   
(deffunction minutos ()
	(bind ?rv (integer (string-to-field (sub-string 4 5  (system-string "time /t")))))
	?rv)
   
(deffunction mrest (?arg)
	(bind ?rv (+ (* (- (- ?arg 1) (hora)) 60) (- 60 (minutos))))
	?rv)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Definicion de Reglas ;;;;;;;
;;;;;;;;;;;; Solicitud ;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Recibe la Solicitud TG
(defrule SolicitudEntranteTG
	?solicitud <- (Solicitud TG)
	=>
	;;; Comprobamos la hora actual
	;;; Abre a las 8:00, atiende a partir de las 9:00 y cierra a las 20:00
	(bind ?horaAtencion (hora)) 
	(assert (ComprobarHorario TG ?horaAtencion))
	(retract ?solicitud)
)

;;; Recibe la Solicitud TE
(defrule SolicitudEntranteTE
	?solicitud <- (Solicitud TE)
	=>
	;;; Comprobamos la hora actual
	;;; Abre a las 8:00, atiende a partir de las 9:00 y cierra a las 20:00
	(bind ?horaAtencion (hora)) 
	(assert (ComprobarHorario TE ?horaAtencion))
	(retract ?solicitud)
)

;;; La peticion ha llegado fuera del horario de trabajo
(defrule FueraHorario
	?comprobacion <- (ComprobarHorario ?tipo ?horaAtencion)
	;;; Si la hora esta fuera del horario de atencion se rechaza
	(test (< ?horaAtencion 8))
	(test (> ?horaAtencion 20))
	=>
	(printout t " Fuera del Horario de Atencion 8:00-20:00 " crlf)
	(retract ?comprobacion)
)

;;; La peticion ha llegado dentro del horario de trabajo
(defrule DentroHorario
	?comprobacion <- (ComprobarHorario ?tipo ?horaAtencion)
	?colaTotal <- (Cola (nombre Total) (tipo ?tipo) (cantidad ?cantidadTotal))
	?colaAtendido <- (Cola (nombre Atendido) (tipo ?tipo) (cantidad ?cantidadAtendido))
	;;; Si la hora esta dentro del horario de atencion
	(test (>= ?horaAtencion 8))
	(test (<= ?horaAtencion 20))
	=>
	(bind ?incrementoTotal (+ ?cantidadTotal 1))
	;;; Se toma cuanto falta hasta la hora de cierre (20:00)
	(bind ?horaCierre (mrest 20))
	;;; Se calcula la gente que falta por atender
	(bind ?horaAtender (- ?cantidadTotal ?cantidadAtendido))
	;;; Se calcula el tiempo que se tardara en atender (15 minutos)
	(bind ?horaAtender (* ?horaAtender 15))
	;;; Se calcula el tiempo que falta para cerrar menos el tiempo que se consumira en atender
	(bind ?tiempoRestante (- ?horaCierre ?horaAtender))
	(assert (TiempoLimite ?colaTotal ?tipo ?incrementoTotal ?tiempoRestante ?horaCierre))
	(retract ?comprobacion)
)

;;; La peticion es aceptada porque cumple con los requisitos de horario
(defrule TiempoLimiteNoCumplido
	?tiempoLimite <- (TiempoLimite ?colaTotal ?tipo ?incrementoTotal ?tiempoRestante ?horaCierre)
	;;; Empiezan a atender a las 9:00 ((20-9)*60=660
	;;; Si el tiempo hasta el cierre es menor a 660 es que se puede atender
	(test (<= ?horaCierre 660))
	;;; Una nueva solicitud son 15 minutos mas
	;;; Si quedan 15 minutos o mas se puede atender
	(test (>= ?tiempoRestante 15))
	=>
	(printout t ?tipo " aceptado. Su numero es " ?incrementoTotal crlf)
	(assert (Cola (nombre Total) (tipo ?tipo) (cantidad ?incrementoTotal)))
	(retract ?colaTotal)
	(retract ?tiempoLimite)
)

;;; La peticion llega en horario de trabajo pero no hay tiempo para atenderla
(defrule FueraHorarioAtencion
	?tiempoLimite <- (TiempoLimite ?colaTotal ?tipo ?incrementoTotal ?tiempoRestante ?horaCierre)
	;;; Empiezan a atender a las 9:00 ((20-9)*60=660)
	;;; El tiempo que resta hasta las 20:00 es superior al tiempo de atencion total
	;;; Es decir, esta fuera del rango de atencion de 9:00 a 20:00
	(test (> ?horaCierre 660))
	=>
	(printout t "No hay tiempo para atender mas peticiones" crlf)
	(retract ?tiempoLimite)
)


(defrule DentroHorarioAtencion
	?tiempoLimite <- (TiempoLimite ?colaTotal ?tipo ?incrementoTotal ?tiempoRestante ?horaCierre)
	;;; Empiezan a atender a las 9:00 ((20-9)*60=660)
	;;; El tiempo que resta hasta las 20:00 es inferior al tiempo de atencion total
	;;; Es decir, esta dentro del rango de atencion de 9:00 a 20:00
	(test (<= ?horaCierre 660))
	;;; Atender otra solicitud superaria el tiempo de cierre
	(test (< ?tiempoRestante 15))
	=>
	(printout t "No hay tiempo para atender mas peticiones" crlf)
	(retract ?tiempoLimite)
)

;;; Recibe Solicitudes distintas de TG y TE
(defrule SolicitudEquivocada
	?solicitud <- (Solicitud ?tipo)
	;;; La solicitud no es de tipo TG
	(test (neq ?tipo TG))
	;;; La solicitud no es de tipo TE
	(test (neq ?tipo TE))
	=>
	(printout t " No se realiza el tramite " ?tipo crlf)
	(retract ?solicitud)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Definicion de Reglas ;;;
;;;;;; Disponibilidad ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Recibe el aviso de disponibilidad del empleado
(defrule Disponibilidad
	?disponible <- (Disponible ?empl)
	?tarea <- (Tarea (empl ?empl) (tipo ?tipo))
	?colaTotal <- (Cola (nombre Total) (tipo ?tipo) (cantidad ?cantidadTotal))
	?colaAtendido <- (Cola (nombre Atendido) (tipo ?tipo) (cantidad ?cantidadAtendido))
	=>
	(bind ?nuevoAtendido (+ ?cantidadAtendido 1))
	;;; La condicion de comprobacion de que quedan solicitudes es que el ultimo atendido de la cola
	;;; Incrementado en 1 no supera la cola de totales
	(assert (Dispuesto ?cantidadAtendido ?nuevoAtendido ?cantidadTotal ?colaAtendido ?tipo ?empl))
	(retract ?disponible)
)

;;; Hay solicitudes por atender
(defrule Disponible
	?disponible <- (Dispuesto ?cantidadAtendido ?nuevoAtendido ?cantidadTotal ?colaAtendido ?tipo ?empl)
	;;; Se comprueba que quedan solicitudes por atender
	(test (<= ?nuevoAtendido ?cantidadTotal))
	=>
	(assert (Cola (nombre Atendido) (tipo ?tipo) (cantidad ?nuevoAtendido)))
	(assert (Informacion ?empl ?tipo ?nuevoAtendido))
	(retract ?colaAtendido)
	(retract ?disponible)
)

;;; No hay solicitudes por atender
(defrule NoDisponible
	?disponible <- (Dispuesto ?cantidadAtendido ?nuevoAtendido ?cantidadTotal ?colaAtendido ?tipo ?empl)
	;;; Se comprueba que no quedan solicitudes
	(test (> ?nuevoAtendido ?cantidadTotal))
	=>
	(printout t " No quedan mas " ?tipo " por atender " crlf)
	(retract ?disponible)
)

;;; Es la primera vez que el empleado atiende
(defrule DisponibleNuevo
	?info <- (Informacion ?empl ?tipo ?nuevoAtendido)
	?colaPropia <- (Ocupacion (empl ?empl) (ultimo ?enCola)) 
	;;; Si el ultimo que se atendio es 0 es que el nuevo a atender es el primero
	(test (eq ?enCola 0))
	=>
	(assert (Ocupacion (empl ?empl) (ultimo ?nuevoAtendido)))
	(printout t " No habia atendido hasta ahora " crlf)
	(printout t " El siguiente es " ?tipo " " ?nuevoAtendido crlf)
	(retract ?colaPropia)
	(retract ?info)
)

;;; No es la primera vez que el empleado atiende
(defrule DisponibleNoNuevo
	?info <- (Informacion ?empl ?tipo ?nuevoAtendido)
	?colaPropia <- (Ocupacion (empl ?empl) (ultimo ?enCola)) 
	;;; Si el ultimo que se atendio no es 0 es que acaba de salir alguien
	(test (neq ?enCola 0))
	=>
	(assert (Ocupacion (empl ?empl) (ultimo ?nuevoAtendido)))
	(printout t " Ha sido atendido " ?tipo " " ?enCola crlf)
	(printout t " El siguiente es " ?tipo " " ?nuevoAtendido crlf)
	(retract ?colaPropia)
	(retract ?info)
)