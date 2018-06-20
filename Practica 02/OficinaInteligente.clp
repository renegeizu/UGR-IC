;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Hechos Estaticos ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Habitaciones
	(Habitacion Recepcion)
	(Luz Recepcion OFF)
	(Habitacion Pasillo)
	(Luz Pasillo OFF)
	(Habitacion Oficina1)
	(Luz Oficina1 OFF)
	(Habitacion Oficina2)
	(Luz Oficina2 OFF)
	(Habitacion Oficina3)
	(Luz Oficina3 OFF)
	(Habitacion Oficina4)
	(Luz Oficina4 OFF)
	(Habitacion Oficina5)
	(Luz Oficina5 OFF)
	(Habitacion OficinaDoble)
	(Luz OficinaDoble OFF)
	(Habitacion Gerencia)
	(Luz Gerencia OFF)
	(Habitacion Papeleria)
	(Luz Papeleria OFF)
	(Habitacion Aseos)
	(Luz Aseos OFF)
	(Habitacion AseoHombres)
	(Luz AseoHombres OFF)
	(Habitacion AseoMujeres)
	(Luz AseoMujeres OFF)
)

(deffacts Puertas
	(Puerta Recepcion Pasillo)
	(Puerta Pasillo Oficina1)
	(Puerta Pasillo Oficina2)
	(Puerta Pasillo Oficina3)
	(Puerta Pasillo Oficina4)
	(Puerta Pasillo Oficina5)
	(Puerta Pasillo Gerencia)
	(Puerta Pasillo OficinaDoble)
	(Puerta Pasillo Papeleria)
)

(deffacts Empleados
	(Empleado G1 Oficina1)
	(TramitesRealizados G1 0)
	(OficinaAsignada G1 Oficina1)
	(Empleado G2 Oficina2)
	(TramitesRealizados G2 0)
	(OficinaAsignada G2 Oficina2)
	(Empleado G3 Oficina3)
	(TramitesRealizados G3 0)
	(OficinaAsignada G3 Oficina3)
	(Empleado G4 Oficina4)
	(TramitesRealizados G4 0)
	(OficinaAsignada G4 Oficina4)
	(Empleado G5 Oficina5)
	(TramitesRealizados G5 0)
	(OficinaAsignada G5 Oficina5)
	(Empleado E1 OficinaDoble-1)
	(TramitesRealizados E1 0)
	(OficinaAsignada E1 OficinaDoble)
	(Empleado E2 OficinaDoble-2)
	(TramitesRealizados E2 0)
	(OficinaAsignada E2 OficinaDoble)
	(Empleado Recepcionista Recepcion)
	(Empleado Director Gerencia)
)

(deffacts Codificacion
	(Code TG "Tramites Generales")
	(Code TE "Tramites Especiales")
)

(deffacts Tareas
	(Tarea G1 TG)
	(Tarea G2 TG)
	(Tarea G3 TG)
	(Tarea G4 TG)
	(Tarea G5 TG)
	(Tarea E1 TE)
	(Tarea E2 TE)
)

(deffacts Inicializacion
	(Personas 0)
	(Usuarios TG 0)
	(UltimoUsuarioAtendido TG 0)
	(Usuarios TE 0)
	(UltimoUsuarioAtendido TE 0)
	(Empleados 0)
	(Ejecutar)
	(Contar TG 0)
	(Contar TE 0)
)

(defrule cargarconstantes
	(declare (salience 10000))
	=>
	(load-facts Constantes.txt)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Ejercicio 01 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule EncolarUsuario
	?g <- (Solicitud ?tipotramite)
	?f <- (Usuarios ?tipotramite ?n)
	(MaximoEsperaParaSerAtendido ?tipotramite ?time);Para calcular el tiempo de espera
	(HoraActualizada ?trns)
	=>
	(assert (Usuario ?tipotramite (+ ?n 1)) (Usuarios ?tipotramite (+ ?n 1)))
	(bind ?incre (* 60 ?time));Tiempo en minutos-segundos
	(bind ?timpofin (+ ?trns ?incre));Limite de tiempo
	(printout t "Su turno es " ?tipotramite " " (+ ?n 1) " maximo para ser atendido "  ?timpofin  crlf)
	(assert (TimeUser ?tipotramite ?n ?timpofin) (TIMECOLA ?tipotramite ?n ?trns ?timpofin))
	(retract ?f ?g)
)

(defrule AsignarEmpleado
	?g <- (Disponible ?empl)
	(Tarea ?empl ?tipotramite)
	(Empleado ?empl ?ofic)
	?f <- (UltimoUsuarioAtendido ?tipotramite ?atendidos)
	(Usuarios ?tipotramite ?total)
	(MaximoTiempoGestion ?tipotramite ?minuto);Para el control del inicio de la gestión
	(HoraActualizada ?trns)
	(test (< ?atendidos ?total))
	=>
	(bind ?a (+ ?atendidos 1))
	(bind ?timemax (+ ?trns (* ?minuto 60)))
	(assert (Asignado ?empl ?tipotramite ?a) (UltimoUsuarioAtendido ?tipotramite ?a) (EnTramite ?tipotramite ?a ?timemax) (TIMETRAMITADO ?tipotramite ?a ?trns ?timemax))
	(printout t "Usuario " ?tipotramite ?a ", por favor pase a " ?ofic crlf)
	(retract ?f ?g )
)

(defrule RegistrarCaso
	(declare (salience 10))
	(Disponible ?empl)
	?f <- (Asignado ?empl ?tipotramite ?n)
	?g <- (EnTramite ?tipotramite ?n ?timemax)
	?h <- (TramitesRealizados ?empl ?p)
	?y <- (TIMETRAMITADO ?tipotramite ?n ?trns ?timemax)
	?z <- (TIMECOLA ?tipotramite ?n ?timeInicio ?timeLimite)
	(HoraActualizada ?acttime)
	=>
	(assert (Tramitado ?empl ?tipotramite ?n))
	(assert (TramitesRealizados ?empl (+ ?p 1)) (TIMETRAMITADO ?tipotramite ?n ?trns ?acttime) (TIMECOLA ?tipotramite ?n ?timeInicio ?trns))
	(printout t "FIN TRAMITE:Empleado " ?empl ", a realizado " (+ ?p 1) " tramites. " crlf)
	(retract ?f ?g ?h ?y ?z)
)

(defrule MuchoTiempoDeGestion
	(MaximoTiempoGestion ?tipotramite ?minuto)
	?f <- (EnTramite ?tipotramite ?n ?timemax)
	(HoraActualizada ?t)
	(test (< ?timemax ?t))
	=>
	(printout t "Usuario " ?tipotramite ?n ", por favor termine " crlf)
	(retract ?f)
)

(defrule Se_Va_En_Tramite
	?f <- (Asignado ?empl ?tipotramite ?n)
	(not (Trabajando ?empl))
	?y <- (TIMETRAMITADO ?tipotramite ?n ?trns ?timemax)
	?g <- (EnTramite ?tipotramite ?n ?timemax)
	(HoraActualizada ?acttime)
	=>
    (assert (Tramitado ?empl ?tipotramite ?n) (TIMETRAMITADO ?tipotramite ?n ?trns ?acttime))
	(printout t "Usuario " ?tipotramite ?n ", ha terminado el tramite forzosamente " crlf)
	(retract ?f ?y ?g )
)

(defrule NoposibleEncolarUsuario
	(declare (salience 20))
	?g <- (Solicitud ?tipotramite)
	(Usuarios ?tipotramite ?n)
	(UltimoUsuarioAtendido ?tipotramite ?atendidos)
	(TiempoMedioGestion ?tipotramite ?m)
	(FinalJornada ?h)
	(test (> (* (- ?n ?atendidos) ?m) (mrest ?h)))
	(Code  ?tipotramite ?texto)
	=>
	(printout t "Lo siento pero por hoy no podremos atender mas " ?texto crlf)
	(bind ?a (- ?n ?atendidos))
	(printout t "Hay ya  " ?a " personas esperando y se cierra a las " ?h "h. No nos dara tiempo a atenderle." crlf)
	(retract ?g)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Ejercicio 02 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ContadorAtendiendo
	(declare (salience 10))
	?f <- (Ficha ?ID)
	(not (Trabajando ?ID))
	(Tarea ?ID ?tramite)
	?g <- (Contar ?tramite ?n)
	=>
	(retract ?g ?f)
	(assert (Trabajando ?ID) (Contar ?tramite (+ ?n 1)))
)

(defrule EmpleadoSeMarcha
	(declare (salience 10))
	?f <- (Ficha ?ID)
	?g <- (Trabajando ?ID)
	(Tarea ?ID ?tramite)
	?h <- (Contar ?tramite ?n)
	=>
	(retract ?g ?f ?h)
	(assert (Contar ?tramite (- ?n 1)))
)

(defrule NoSuficientesEmpleados
	(declare (salience 20))
	(Contar ?tramite ?n)
	(MinimoEmpleadosActivos ?tramite ?limite)
	(test (< ?n ?limite))
	(not (NOSUFICIENTES ?tramite))
	=>
	(printout t "Hay pocos empleados atendiendo los siguientes tramites." ?tramite crlf)
	(assert (NOSUFICIENTES ?tramite))
)

(defrule SuficientesEmpleados
	(declare (salience 20))
	(Contar ?tramite ?n)
	(MinimoEmpleadosActivos ?tramite ?limite)
	(test (>= ?n ?limite))
	?g <- (NOSUFICIENTES ?tramite)
	=>
	(printout t "Han llegado suficientes empleados de ." ?tramite crlf)
	(retract ?g)
)

(defrule NoAtendidoATiempo
	?f <- (TimeUser ?tipotramite ?n ?timpofin)
	(HoraActualizada ?t)
	(MaximoEsperaParaSerAtendido ?tipotramite ?max)
	(test (> ?t ?timpofin ))
	=>
	(bind ?incre (* 60 ?max))
	(bind ?newFin (+ ?t ?incre))
	(assert (TimeUser ?tipotramite ?n ?newFin))
	(printout t "El usuario " ?tipotramite " " ?n " aun no fue atendido" crlf)
	(retract ?f)
)

(defrule AtendidoATiempo
	(declare (salience 5))
	?f <-(TimeUser ?tipotramite ?n ?timpofin)
	(UltimoUsuarioAtendido ?tipotramite ?total)
	(test (> ?total ?n))
	=>
	(retract ?f)
	(printout t "El usuario " ?tipotramite " " ?n " esta siendo atendido" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Ejercicio 03 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule LlegoTarde
	(declare (salience 15))
	(HoraActualizada ?t)
	(TiempoMaximoRetraso ?time)
	(Ficha ?ID)
	(ComienzoJornada ?entrada)
	(test (<  (+ (totalsegundos ?entrada 0 0) (* 60 ?time)) ?t))
	(and (not (RETRASADO ?ID ?randTime)) (not (ONTIME ?ID ?randTime)))
	=>
	(printout t "El empleado " ?ID " se ha retrasado en llegar" crlf)
	(assert (RETRASADO ?ID ?t)) ;Se le incluye el tiempo para poder realizar el informe
)

(defrule LlegoATiempo
	(declare (salience 15))
	(HoraActualizada ?t)
	(TiempoMaximoRetraso ?time)
	(Ficha ?ID)
	(ComienzoJornada ?entrada)
	(test (>=  (+ (totalsegundos ?entrada 0 0) (* 60 ?time)) ?t))
	(and (not (RETRASADO ?ID ?randTime)) (not (ONTIME ?ID ?randTime)))
	=>
	(assert (ONTIME ?ID ?t)) ;Se le incluye el tiempo para poder realizar el informe
)

(defrule EmpleadoDescansa
	(declare (salience 15))
	(Ficha ?ID)
	(HoraActualizada ?t)
	(TiempoMaximoDescanso ?max)
	(and (Trabajando ?ID) (not (DESCANSO ?ID ?hora ?horaMax)) (not (FINJORNADA ?ID ?tiempofin)))
	=>
	(bind ?horamax (+ ?t (* 60 ?max)))
	(assert (DESCANSO ?ID ?t ?horamax))
	(printout t "El empleado " ?ID " sale a descansar" crlf)
)

(defrule AvisoDeDescanso
	(declare (salience 20))
	?f <- (DESCANSO ?ID ?horaIni ?horamax)
	(TiempoMaximoDescanso ?max)
	(HoraActualizada ?t)
	(and (not (FINJORNADA ?ID ?tiempofin)) (not (FINDESCANSO ?ID ?horainicial ?tiempofinal)))
	(test (> ?t ?horamax))
	=>
	(printout t "El empleado " ?ID " lleva demasiado descansando" crlf)
	(bind ?nuevomax (+ ?t (* 60 ?max)))
	(assert (DESCANSO ?ID ?horaIni ?nuevomax))
	(retract ?f)
)

(defrule RegresoDescanso
	(declare (salience 15))
	(or (RETRASADO ?ID ?randTime) (ONTIME ?ID ?OtherTime))
	(and (not (FINDESCANSO ?ID )) (not (Trabajando ?ID)) )
    ?f <- (DESCANSO ?ID ?horaIni ?hora)
    (Ficha ?ID)
    (HoraActualizada ?acttime)
    =>
    (retract ?f)
    (assert (FINDESCANSO ?ID ?horaIni ?acttime))
    (printout t "El empleado " ?ID " vuelve de descansar" crlf)
)

(defrule FinJornada
	(declare (salience 25))
	?f <- (Trabajando ?ID)
    (and (FINDESCANSO ?ID ?horaIni ?horaFin) (not (FINJORNADA ?ID ?timeFin)))
    (Ficha ?ID)
    (HoraActualizada ?t)
    =>
    (assert (FINJORNADA ?ID ?t))
    (printout t "El empleado " ?ID " ha terminado la jornada" crlf)
)

(defrule CorregirErrores
	(declare (salience 1000))
    ?f <- (DESCANSO ?ID ?horaIni ?horaFin)
    (HoraActualizada ?t)
    (FinJornada ?fin)
    (test (< (totalsegundos ?fin 0 0) ?t))
    =>
    (assert (FINJORNADA ?ID ?t) (FINDESCANSO ?ID ?horaIni ?t))
    (retract ?f)
)

(defrule MinimoRealizado
	(HoraActualizada ?t)
	(MinimoTramitesPorDia ?tipotramite ?min)
	(FinalJornada ?h)
	(Tarea ?empl ?tipotramite)
	?g <- (TramitesRealizados ?empl ?num)
	(test (< (totalsegundos ?h 0 0) ?t))
	(test (< ?num ?min))
	=>
	(printout t "El empleado " ?empl " ha realizado menos del numero de tramites minimo" crlf)
	(assert (TRAMITESMINIMOS ?empl ?num))
	(retract ?g)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Ejercicio 4 ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule Enciede
	(declare (salience 12))
	?f <- (Luz ?hab OFF)
	(Ficha ?empl)
	(OficinaAsignada ?empl ?hab)
	(HoraActualizada ?t)
	(Tarea ?empl ?tram)
	(not (LucesTemp ?hab ?tp))
	(test (neq ?tram TE))
	=>
	(assert (Luz ?hab ON) (LucesTemp ?hab (+ ?t 5)))
	(retract ?f)
	(printout t "En la habitacion " ?hab " se han encendido las luces" crlf)
)

(defrule Apagar
	(declare (salience 12))
	?f <- (Luz ?hab ON)
	(Ficha ?empl)
	(OficinaAsignada ?empl ?hab)
	(HoraActualizada ?t)
	(Tarea ?empl ?tram)
	(not (LucesTemp ?hab ?tp))
	(test (neq ?tram TE))
	=>
	(assert (Luz ?hab OFF) (LucesTemp ?hab (+ ?t 5)))
	(retract ?f)
	(printout t "En la habitacion " ?hab " se han apagado las luces" crlf)
)

(defrule EncenderDoble
	(declare (salience 12))
	?f <- (Luz ?hab OFF)
	(Ficha ?empl)
	(OficinaAsignada ?empl ?hab)
	(HoraActualizada ?t)
	(Tarea ?empl ?tram)
	(not (LucesTemp ?hab ?tp))
	(test (eq ?tram TE))
	=>
	(assert (Luz ?hab ON) (LucesTemp ?hab (+ ?t 5)))
	(retract ?f)
	(printout t "En la habitacion " ?hab " se han encendido las luces" crlf)
)

(defrule EncenderOtros
	?f <- (Luz Gerencia OFF)
	?g <- (Luz Papeleria OFF)
	(HoraActualizada ?acttime)
	(ComienzoJornada ?ini)
	(test (> ?acttime (totalsegundos ?ini 0 0)))
	=>
	(assert (Luz Papeleria ON) (Luz Gerencia ON))
	(retract ?f ?g)
	(printout t "En las habitaciones Gerencia y Papeleria se han encendido las luces" crlf)
)

(defrule ApagarOtros
	?f <- (Luz Gerencia ON)
	?g <- (Luz Papeleria ON)
	(HoraActualizada ?acttime)
	(FinJornada ?fin)
	(test (>= ?acttime (totalsegundos ?fin 0 0)))
	=>
	(assert (Luz Papeleria OFF) (Luz Gerencia OFF))
	(retract ?f ?g)
	(printout t "En las habitaciones Gerencia y Papeleria se han apagado las luces" crlf)
)

(defrule ApagarDoble
	?f <- (Luz OficinaDoble ON)
	(and (not (Trabajando E1)) (not (Trabajando E2)))
	=>
	(assert (Luz OficinaDoble OFF))
	(retract ?f)
	(printout t "En la habitacion OficinaDoble se han apagado las luces" crlf)
)

(defrule Limpiar
	?f <- (LucesTemp ?hab ?t)
	=>
	(retract ?f)
)

(defrule EnciendePasillo
	?f <- (Luz Pasillo OFF)
	?g <- (Sensor_presencia Pasillo)
	(HoraActualizada ?t)
	=>
	(assert (Luz Pasillo ON) (LuzPasillo ?t))
	(printout t "En el pasillo se han encendido las luces" crlf)
	(retract ?f ?g)
)

(defrule MantenPasillo
	?f <- (LuzPasillo ?la)
	?g <- (Sensor_presencia Pasillo)
	(HoraActualizada ?t)
	=>
	(assert (LuzPasillo ?t))
	(retract ?f ?g)
)

(defrule ApagarPasillo
	?f <- (LuzPasillo ?t)
	?g <- (Luz Pasillo ON)
	(HoraActualizada ?acttime)
	(test (< (+ ?t 100) ?acttime ))
	=>
	(assert (Luz Pasillo OFF))
	(printout t "En el pasillo se han apagado las luces" crlf)
	(retract ?f ?g)
)

(defrule EncenderBano
	?f <- (Luz ?aseo OFF)
	?g <- (Sensor_presencia ?aseo)
	(test (or (eq ?aseo AseoHombres) (eq ?aseo AseoMujeres)))
	=>
	(retract ?f ?g)
	(assert (Luz ?aseo ON) (NPerson ?aseo 1))
	(printout t "En el " ?aseo " se han encendido las luces" crlf)
)

(defrule AmbiguoBano
	(Luz ?aseo ON)
	?g <- (Sensor_puerta ?aseo)
	(or (eq ?aseo AseoHombres) (eq ?aseo AseoMujeres))
    (HoraActualizada ?t)
    =>
    (retract ?g)
    (assert (Ambiguo ?aseo (+ ?t 2)))
)

(defrule DecrementaBano
	?g <- (Ambiguo ?aseo ?time)
    (Sensor_presencia Pasillo)
    ?f <- (NPerson ?aseo ?n)
    =>
    (retract ?g ?f)
    (assert (NPerson ?aseo (- ?n 1)))
)

(defrule IncrementaBano
	?f <- (Ambiguo ?aseo ?time)
    (HoraActualizada ?t)
    ?g <-(NPerson ?aseo ?n)
    (test (< ?time ?t))
    =>
    (retract ?f ?g)
    (assert (NPerson ?aseo (+ ?n 1)))
)

(defrule ApagarBano
    (declare (salience 20))
    ?f <- (Luz ?aseo ON)
    ?g <- (NPerson ?aseo ?n)
    (test (<= ?n 0))
    =>
    (retract ?f ?g)
    (assert (Luz ?aseo OFF))
    (printout t "En el " ?aseo " se han apagado las luces" crlf)
)