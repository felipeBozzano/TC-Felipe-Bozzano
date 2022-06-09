grammar compiladores;

@header {
package compiladores;
}

fragment LETRA : [A-Za-z] ;
fragment DIGITO : [0-9] ;

SUMA : '+';
RESTA : '-';
MULT : '*';
DIV : '/';
MOD : '%';
AND : '&&';
OR : '||';
PA: '(';
PC: ')';
CA: '[';
CC: ']';
LA: '{';
LC: '}';
IGUALDAD : '==';
DESIGUALDAD : '!=';
MENOR : '<';
MAYOR : '>';
MENOR_IGUAL : '<=';
MAYOR_IGUAL : '>=';
INT: 'int' ;
DOUBLE: 'double' ;
COMA: ',' ;
PUNTOYCOMA: ';' ;
IGUAL: '=';
tipoDato: INT | DOUBLE ;
comparador : IGUALDAD | DESIGUALDAD | MENOR | MAYOR | MENOR_IGUAL | MAYOR_IGUAL;
ENTERO : DIGITO+;
ID : (LETRA | '_')(LETRA | DIGITO | '_')* ;

WS : [ \t\n\r] -> skip;


/*-----------------------------               INICIO                ----------------------------------*/

si: instrucciones EOF;

/*-----------------------------             INSTRUCCIONES           ----------------------------------*/

instrucciones: instruccion instrucciones
             | 
             ;

instruccion: inst_simple
           | bloque
           | funcion
           | bloqueDeControl
           ;

inst_simple: declaracion
           | asignacion
           ;

bloque: LA instrucciones LC ;

/*-----------------------------      DECLARACIONES ASIGNACIONES      ----------------------------------*/

/* declaracion : tipoDato expresion PUNTOYCOMA ; */

declaracion: tipoDato ID listaDeclaracion PUNTOYCOMA ;

/*  int x;
    double y;
    int z = 0;
    double w, q, t;
    int a = 5, b, c = 10; */

listaDeclaracion: IGUAL opal listaDeclaracion
                | COMA ID listaDeclaracion
                |
                ;

/* expresion: ID expresion
         | COMA expresion
         | asignar expresion
         |
         ; */

asignacion: ID IGUAL (opal|invocacionFuncion) PUNTOYCOMA ;

/*-----------------------------               FUNCIONES              ----------------------------------*/

funcion: declaracionFuncion
       | invocacionFuncion PUNTOYCOMA
       ;

declaracionFuncion: tipoDato ID PA param PC;

param: tipoDato ID listaParams
     |
     ;

listaParams: COMA param listaParams
           |
           ;

invocacionFuncion: ID PA args PC;

args: opal listaArgs
    | 
    ;

listaArgs: COMA opal listaArgs
         |
         ;

/*-----------------------------           WHILE, IF, FOR             ----------------------------------*/

bloqueDeControl: iwhile
               | iif
               | ifor
               ;

iwhile: 'while' PA opal PC (bloque|inst_simple);

iif: 'if' PA opal PC (bloque|inst_simple);

ifor: 'for' PA condicionFor PC (bloque|inst_simple);

condicionFor: (ID|asignacion) PUNTOYCOMA opal PUNTOYCOMA asignacion;

/*-----------------------------                OPAL                  ----------------------------------*/

opal : term or;

term : factor t;

factor : ENTERO
       | ID
       | invocacionFuncion
       | PA opal PC
       |
       ;

t : MULT factor t
  | DIV factor t
  | MOD factor t
  |
  ; 

exp : SUMA term exp
    | RESTA term exp
    | 
    ;

comp : exp c
     |
     ;

c : comparador term exp
  |
  ;

and : comp a
    |
    ;

a : AND term and
  |
  ;

or : and o
   |
   ;

o : OR term or
  |
  ;
