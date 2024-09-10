package com.mycompany.trivianormal;
import java_cup.runtime.*;
%%
%class Lexico
%public
%unicode
%standalone
%cup
%line
%column
%ignorecase
%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
    
    private LinkedList<String> listaErrores;
%}
%init{
    yyline = 1;
    yycolumn = 1;
    listaErrores = new LinkedList<>();
    yybegin(YYINITIAL);
%init}
SaltosLinea     = \r|\n|\r\n
EspaciosBlancos = {SaltosLinea} | [ \t\f]
Identificador   = [a-zA-Z_$][a-zA-Z0-9_$]*
Enteros         = 0 | ([1-9][0-9]*)
Decimal         = {Enteros}\.[0-9]+
ComentarioLinea = "//".*
ComentarioMultilinea = "/*" ~"*/"
NumeroNegativo  = -({Enteros}|{Decimal})

// XSON tokens
XSON_VERSION = "<?xson version=\"1.0\" ?>"
REALIZAR_SOLICITUD = "<!realizar_solicitud:"
FIN_SOLICITUD = "<fin_solicitud_realizada!>"
LLAVE_ABRE = "{"
LLAVE_CIERRA = "}"
CORCHETE_ABRE = "["
CORCHETE_CIERRA = "]"
COMA = ","
DOS_PUNTOS = ":"

// SQLKV tokens
SELECCIONAR = "SELECCIONAR"
REPORTE = "REPORTE"
FILTRAR = "FILTRAR"
POR = "POR"
AND = "AND"
OR = "OR"
NOT = "NOT"

// Solicitudes específicas
USUARIO_NUEVO = "USUARIO_NUEVO"
MODIFICAR_USUARIO = "MODIFICAR_USUARIO"
ELIMINAR_USUARIO = "ELIMINAR_USUARIO"
LOGIN_USUARIO = "LOGIN_USUARIO"
NUEVA_TRIVIA = "NUEVA_TRIVIA"
ELIMINAR_TRIVIA = "ELIMINAR_TRIVIA"
MODIFICAR_TRIVIA = "MODIFICAR_TRIVIA"
AGREGAR_COMPONENTE = "AGREGAR_COMPONENTE"
ELIMINAR_COMPONENTE = "ELIMINAR_COMPONENTE"
MODIFICAR_COMPONENTE = "MODIFICAR_COMPONENTE"

// Parámetros comunes
ID_TRIVIA = "ID_TRIVIA"
USUARIO = "USUARIO"
PASSWORD = "PASSWORD"
NOMBRE = "NOMBRE"
TIEMPO_PREGUNTA = "TIEMPO_PREGUNTA"
TEMA = "TEMA"
FECHA_CREACION = "FECHA_CREACION"
FECHA_MODIFICACION = "FECHA_MODIFICACION"

// Clases de componentes
CAMPO_TEXTO = "CAMPO_TEXTO"
AREA_TEXTO = "AREA_TEXTO"
CHECKBOX = "CHECKBOX"
RADIO = "RADIO"
FICHERO = "FICHERO"
COMBO = "COMBO"

// Common tokens
STRING = \"[^\"]*\" | \'[^\']*\'
NUMBER = {Enteros} | {Decimal} | {NumeroNegativo}
OPERADOR = "<" | ">" | "=" | ">=" | "<=" | "!="

%%
<YYINITIAL> {
    // XSON rules
    {XSON_VERSION}      { return symbol(sym.XSON_VERSION); }
    {REALIZAR_SOLICITUD} { return symbol(sym.REALIZAR_SOLICITUD); }
    {FIN_SOLICITUD}     { return symbol(sym.FIN_SOLICITUD); }
    {LLAVE_ABRE}        { return symbol(sym.LLAVE_ABRE); }
    {LLAVE_CIERRA}      { return symbol(sym.LLAVE_CIERRA); }
    {CORCHETE_ABRE}     { return symbol(sym.CORCHETE_ABRE); }
    {CORCHETE_CIERRA}   { return symbol(sym.CORCHETE_CIERRA); }
    {COMA}              { return symbol(sym.COMA); }
    {DOS_PUNTOS}        { return symbol(sym.DOS_PUNTOS); }

    // SQLKV rules
    {SELECCIONAR}       { return symbol(sym.SELECCIONAR); }
    {REPORTE}           { return symbol(sym.REPORTE); }
    {FILTRAR}           { return symbol(sym.FILTRAR); }
    {POR}               { return symbol(sym.POR); }
    {AND}               { return symbol(sym.AND); }
    {OR}                { return symbol(sym.OR); }
    {NOT}               { return symbol(sym.NOT); }

    // Solicitudes específicas
    {USUARIO_NUEVO}     { return symbol(sym.USUARIO_NUEVO); }
    {MODIFICAR_USUARIO} { return symbol(sym.MODIFICAR_USUARIO); }
    {ELIMINAR_USUARIO}  { return symbol(sym.ELIMINAR_USUARIO); }
    {LOGIN_USUARIO}     { return symbol(sym.LOGIN_USUARIO); }
    {NUEVA_TRIVIA}      { return symbol(sym.NUEVA_TRIVIA); }
    {ELIMINAR_TRIVIA}   { return symbol(sym.ELIMINAR_TRIVIA); }
    {MODIFICAR_TRIVIA}  { return symbol(sym.MODIFICAR_TRIVIA); }
    {AGREGAR_COMPONENTE} { return symbol(sym.AGREGAR_COMPONENTE); }
    {ELIMINAR_COMPONENTE} { return symbol(sym.ELIMINAR_COMPONENTE); }
    {MODIFICAR_COMPONENTE} { return symbol(sym.MODIFICAR_COMPONENTE); }

    // Parámetros comunes
    {ID_TRIVIA}         { return symbol(sym.ID_TRIVIA); }
    {USUARIO}           { return symbol(sym.USUARIO); }
    {PASSWORD}          { return symbol(sym.PASSWORD); }
    {NOMBRE}            { return symbol(sym.NOMBRE); }
    {TIEMPO_PREGUNTA}   { return symbol(sym.TIEMPO_PREGUNTA); }
    {TEMA}              { return symbol(sym.TEMA); }
    {FECHA_CREACION}    { return symbol(sym.FECHA_CREACION); }
    {FECHA_MODIFICACION} { return symbol(sym.FECHA_MODIFICACION); }

    // Clases de componentes
    {CAMPO_TEXTO}       { return symbol(sym.CAMPO_TEXTO); }
    {AREA_TEXTO}        { return symbol(sym.AREA_TEXTO); }
    {CHECKBOX}          { return symbol(sym.CHECKBOX); }
    {RADIO}             { return symbol(sym.RADIO); }
    {FICHERO}           { return symbol(sym.FICHERO); }
    {COMBO}             { return symbol(sym.COMBO); }

    // Common rules
    {Identificador}     { return symbol(sym.IDENTIFIER, yytext()); }
    {STRING}            { return symbol(sym.STRING, yytext()); }
    {NUMBER}            { return symbol(sym.NUMBER, Double.parseDouble(yytext())); }
    {OPERADOR}          { return symbol(sym.OPERADOR, yytext()); }
    {EspaciosBlancos}   { /* ignorar */ }
    {ComentarioLinea}   { /* ignorar */ }
    {ComentarioMultilinea} { /* ignorar */ }

    // Error fallback
    [^] { 
        String errorMsg = "Error lexico: Caracter invalido <" + yytext() + "> en linea " + (yyline + 1) + ", columna " + (yycolumn + 1) + ")";
        listaErrores.add(errorMsg);
        System.out.println(errorMsg);
    }
}

<<EOF>> { return symbol(sym.EOF); }