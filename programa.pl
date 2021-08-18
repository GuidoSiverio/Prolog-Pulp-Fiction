personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

parejas(X,Y):- pareja(X,Y).
parejas(X,Y):- pareja(Y,X).
pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigos(X,Y):- amigo(X,Y).
amigos(X,Y):- amigo(Y,X).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent, elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(marsellus, vincent, ayudar(butch)).


% PUNTO 1

esPeligroso(Personaje):-
    personaje(Personaje, Actividad),
    actividadPeligrosa(Actividad).

esPeligroso(Personaje):-
    personaje(Personaje, _),
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(Lista)):-
    member(licorerias, Lista).
    

:- begin_tests(esPeligroso).
test(persona_peligrosa_por_ser_maton, nondet):-
    esPeligroso(vincent).

test(persona_peligrosa_por_ser_ladron_de_licorerias, nondet):-
    esPeligroso(pumkin).

test(persona_peligrosa_por_tener_empleados_peligrosos, nondet):-
    esPeligroso(marsellus).

test(persona_no_peligrosa, fail):-
    esPeligroso(mia).

:- end_tests(esPeligroso).


% PUNTO 2

duoTemible(Personaje, OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    sonPeligrosos(Personaje, OtroPersonaje),
    esDuo(Personaje, OtroPersonaje).

sonPeligrosos(Personaje, OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje).

esDuo(Personaje, OtroPersonaje):-
    parejas(Personaje, OtroPersonaje).

esDuo(Personaje, OtroPersonaje):-
    amigos(Personaje, OtroPersonaje).

:- begin_tests(duoTemible).
test(amigos_peligrosos, nondet):-
    duoTemible(vincent, jules).

test(pareja_peligrosa, nondet):-
    duoTemible(pumkin, honeyBunny).

test(no_es_duo_temible, fail):-
    duoTemible(marsellus, mia).

:- end_tests(duoTemible).


% PUNTO 3

estaEnProblemas(butch).

estaEnProblemas(Personaje):-
    personaje(Personaje, _),
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, Encargo),
    tieneEncargo(Jefe, Encargo).
    
tieneEncargo(Jefe, cuidar(Novia)):-
    parejas(Jefe, Novia).

tieneEncargo(_, buscar(Boxeador, _)):-
    personaje(Boxeador, boxeador).



:- begin_tests(estaEnProblemas).
test(persona_en_problemas_por_cuidar_pareja_del_jefe, nondet):-
    estaEnProblemas(vincent).

test(persona_en_problemas_por_tener_que_buscar_a_un_boxeador, nondet):-
    estaEnProblemas(vincent).

test(persona_que_no_esta_en_problemas, fail):-
    estaEnProblemas(elVendedor).

:- end_tests(estaEnProblemas).


% PUNTO 4

sanCayetano(Personaje):-
    personaje(Personaje, _),
    forall(esCercano(Personaje, PersonajeCercano), encargo(Personaje, PersonajeCercano, _)),
    Personaje \= PersonajeCercano.

esCercano(Personaje, PersonajeCercano):-
    amigos(Personaje, PersonajeCercano).

esCercano(Personaje, PersonajeCercano):-
    trabajaPara(Personaje, PersonajeCercano).



:- begin_tests(sanCayetano).

test(persona_que_no_es_sanCayetano, fail):-
    sanCayetano(vincent).

:- end_tests(sanCayetano).



% PUNTO 5

masAtareado(Personaje):-
    cantidadDeEncargos(Personaje, Cantidad),
    forall(cantidadDeEncargos(_, OtraCant), Cantidad >= OtraCant).
    

cantidadDeEncargos(Personaje, Cantidad):-
    personaje(Personaje, _),
    findall(Encargo, encargo(_, Personaje, Encargo), Lista),
    length(Lista, Cantidad).
    
cantidadDeEncargos(Personaje, 0):-
    not(encargo(_, Personaje, _)).

% PUNTO 6

personajesRespetables(Lista):-
    listaDePersonajesRespetables(Lista).
    
listaDePersonajesRespetables(Lista):-
    findall(Personaje, esRespetable(Personaje), Lista).

esRespetable(Personaje):-
    personaje(Personaje, Actividad),
    nivelDeActividad(Actividad, Nivel),
    Nivel > 9.

nivelDeActividad(actriz(Pelis), Nivel):-
    length(Pelis, Cant),
    Nivel is Cant / 10.

nivelDeActividad(mafioso(resuelveProblemas), 10).
nivelDeActividad(mafioso(maton), 1).
nivelDeActividad(mafioso(capo), 20).

nivelDeActividad(_, 0).


% PUNTO 7

hartoDe(Personaje, OtroPersonaje):-
    personaje(Personaje, _),
    personaje(OtroPersonaje, _),
    interactuaConElOtro(Personaje, OtroPersonaje).

interactuaConElOtro(Personaje, OtroPersonaje):-
    encargo(_, Personaje, _),
    forall(encargo(_, Personaje, Tipo), tipoEncargo(Tipo, OtroPersonaje)).

tipoEncargo(cuidar(OtroPersonaje), OtroPersonaje).
tipoEncargo(ayudar(OtroPersonaje), OtroPersonaje).
tipoEncargo(buscar(OtroPersonaje, _), OtroPersonaje).

tipoEncargo(Tipo, OtroPersonaje):-
    amigo(OtroPersonaje, PersonajeAmigo),
    tipoEncargo(Tipo, PersonajeAmigo).


% PUNTO 8

