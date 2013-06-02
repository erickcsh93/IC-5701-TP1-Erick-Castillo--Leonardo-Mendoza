%{
	#include "y.tab.h"
	#include <stdio.h>
	//Variables de conteo de la cantidad de lineas y la columna para cada 		token encontrado
	int num_lineas = 1,num_lineasF = 1, columna_Inicial = 1, columna_Final = 1;
	//variable estado, posee 3 estados
	//	0: estado normal
	//	1: indica que encontro un < que abre un tag asi que cualquier 
	//		palabra que encuentre van a ser la etiqueta y los atributos que posea, 
	//		cada =" que encuentre implica que ese va a ser el valor del atributo
	//	2: indica que despues de encontrar un < o un </ encontro un tag valido
	//	3: indica que encontro un </
	//	4: indica que encontro un = en estado 2 por lo tanto va a esperar un "
	//	5: indica que encontro un " despues de un = por lo tanto va a recibir el valor de un atributo		
	//		cualquier < que encuentre
	//	6: indica que se encuentra entre CDATA o <!-- y no se considera token
	int estado = 0;

	//Definicion de TOKENS, cada token se va a ver representado por un entero
	/*int T_COMMENT = 0;
	int T_COMMENT_CLOSE = 1000;
	int T_TAG_OPEN = 1;
	int T_TAG_CLOSE_CLOSE = 2;
	int T_TAG_CLOSE_OPEN = 3;
	int T_TAG_CLOSE = 4;*/

	/* TOKENS Etiquetas Generales */
	/*int T_DOCTYPE = 6;
	int T_TAG_A = 7;
	int T_TAG_B = 8;
	int T_TAG_BLOCKQUOTE = 9;
	int T_TAG_BODY = 10;
	int T_TAG_BR = 11;
	int T_TAG_BUTTON = 12;
	int T_TAG_CAPTION = 13;
	int T_TAG_CODE = 14;
	int T_TAG_DIV = 15;
	int T_TAG_DL = 16;
	int T_TAG_DT = 17;
	int T_TAG_DD = 18;
	int T_TAG_EM = 19;
	int T_TAG_FORM = 22;
	int T_TAG_H1 = 23;
	int T_TAG_H2 = 24;
	int T_TAG_H3 = 25;
	int T_TAG_H4 = 26;
	int T_TAG_H5 = 27;
	int T_TAG_H6 = 28;
	int T_TAG_HEAD = 29;
	int T_TAG_HR = 31;
	int T_TAG_HTML = 32;
	int T_TAG_IMG = 33;
	int T_TAG_INPUT = 34;
	int T_TAG_LI = 35;
	int T_TAG_LINK = 36;
	int T_TAG_META = 37;
	int T_TAG_OBJECT = 38;
	int T_TAG_OL = 39;
	int T_TAG_P = 41;
	int T_TAG_PRE = 42;
	int T_TAG_SCRIPT = 43;
	int T_TAG_SPAN = 44;
	int T_TAG_STRONG = 45;
	int T_TAG_STYLE = 46;
	int T_TAG_TABLE = 47;
	int T_TAG_TD = 48;
	int T_TAG_TH = 49;
	int T_TAG_TR = 50;
	int T_TAG_TEXTAREA = 51;
	int T_TAG_TITLE = 52;
	int T_TAG_UL = 53;*/


	/* TOKENS Atributos*/
	int T_ATR_ABBR = 100;
	int T_ATR_ABOUT = 101;
	int T_ATR_ACTIVATE = 102;
	int T_ATR_ALT = 103;
	int T_ATR_ARCHIVE = 104;
	int T_ATR_AXIS = 105;
	int T_ATR_CHARSET = 106;
	int T_ATR_CITE = 107;
	int T_ATR_CLASS = 108;
	int T_ATR_COLSPAN = 109;
	int T_ATR_CONTENL = 110;
	int T_ATR_CONTENT = 111;
	int T_ATR_COORDS = 112;
	int T_ATR_DATATYPE = 113;
	int T_ATR_DATETIME = 114;
	int T_ATR_DECLARE = 115;
	int T_ATR_DEFAULTACT = 116;
	int T_ATR_DEFER = 117;
	int T_ATR_DIR = 118;
	int T_ATR_DISABLED = 119;
	int T_ATR_EDIT = 120;
	int T_ATR_ENCODING = 121;
	int T_ATR_EVENTTARGET = 122;
	int T_ATR_EVENT = 123;
	int T_ATR_FULL = 124;
	int T_ATR_HANDLER = 125;
	int T_ATR_HEIGHT = 126;
	int T_ATR_HREF = 127;
	int T_ATR_HREFLANG = 128;
	int T_ATR_HREFMEDIA = 129;
	int T_ATR_HREFTYPE = 130;
	int T_ATR_ID = 131;
	int T_ATR_IMPLEMENTS = 132;
	int T_ATR_ISMAP = 133;
	int T_ATR_ITSTRANS = 134;
	int T_ATR_KEY = 135;
	int T_ATR_LAYOUT = 136;
	int T_ATR_MEDIA = 137;
	int T_ATR_NAME = 138;
	int T_ATR_NEXTFOCUS = 139;
	int T_ATR_OBSERVER = 140;
	int T_ATR_ORDER = 141;
	int T_ATR_PHASE = 142;
	int T_ATR_PREVFOCUS = 143;
	int T_ATR_PROFILE = 144;
	int T_ATR_PROPAGATE = 145;
	int T_ATR_PROPERTY = 146;
	int T_ATR_REL = 147;
	int T_ATR_RESOURCE = 148;
	int T_ATR_REV = 149;
	int T_ATR_ROLE = 150;
	int T_ATR_ROWSPAN = 151;
	int T_ATR_SCOPE = 152;
	int T_ATR_SHAPE = 153;
	int T_ATR_SPAN = 154;
	int T_ATR_SRC = 155;
	int T_ATR_SRCTYPE = 156;
	int T_ATR_STYLE = 157;
	int T_ATR_TARGET = 158;
	int T_ATR_TARGETID = 158;
	int T_ATR_TARGETROLE = 160;
	int T_ATR_TITLE = 161;
	int T_ATR_TYPE = 162;
	int T_ATR_TYPEOF = 163;
	int T_ATR_USEMAP = 164;
	int T_ATR_VALUE = 165;
	int T_ATR_VALUETYPE = 166;
	int T_ATR_VERSION = 167;
	int T_ATR_WIDTH = 168;
	int T_ATR_XMLBASE = 169;
	int T_ATR_XMLID = 170;
	int T_ATR_XMLLANG = 171;
	int T_ATR_XSI = 172;
	int T_ATR_XMLNS = 173;
	int T_ATR_LANG = 174;
	int T_ATR_UNKNOWN = 175;

	/* TOKENS Atributos de Accion*/
	int T_ATR_ONABORT = 200;
	int T_ATR_ONBLUR = 201;
	int T_ATR_ONCHANGE = 202;
	int T_ATR_ONERROR = 203;
	int T_ATR_ONFOCUS = 204;
	int T_ATR_ONHELP = 205;
	int T_ATR_ONLOAD = 206;
	int T_ATR_ONMOVE = 207;
	int T_ATR_ONRESET = 208;
	int T_ATR_ONRESIZE = 209;
	int T_ATR_ONSUBMIT = 210;
	int T_ATR_ONUNLOAD = 211;
	int T_TAG_ONCLICK = 212;
	int T_TAG_ONDBLCLICK = 213;
	int T_TAG_ONMOSUEDOWN = 214;
	int T_TAG_ONMOUSEUP = 215;
	int T_TAG_ONMOUSEOVER = 216;
	int T_TAG_ONMOUSEMOVE = 217;
	int T_TAG_ONMOUSEOUT = 218;
	int T_TAG_ONKEYPRESS = 219;
	int T_TAG_ONKEYDOWN = 220;
	int T_TAG_ONKEYUP = 221;

	/* TOKENS DE SIMBOLOS = " */
	//int T_IGUAL = 300;
	//int T_COMILLA = 301;

	/* TOKEN DE STRING */
	//int T_STRING = 400;

	/* TOKEN DE ATTRIBUTE VALUE */
	//int T_VALUE = 500;

	/* Error */
	//int T_ERROR = 600;
	//int T_ERROR_EOF = -2;

	/* TOKEN IGNORADO*/
	//int T_IGNORE = 700;

	/*TOKEN EOF*/
	//int T_EOF = -1;
	//int T_ATR = 10654;
%}
DOCTYPE "<!DOCTYPE"[^>]*">"
simbolos [^ \-=\"<>a-zA-Z0-9\t\n]+
palabras [a-zA-Z]+
numeros [0-9]+
complejos ({palabras}|{simbolos}|{numeros})*
%%

 	/*Caracteres especiales*/
"-" {if(estado!=6) return funcion_general(define_guion(T_STRING));}
"<!--" {estado=6;conteo();}
"-->" {estado=0;conteo();}
"<" {if(estado!=6){estado = 1;} if(estado!=6) return funcion_general(T_TAG_OPEN);}
"/>" {if(estado!=6){estado = 0;} if(estado!=6) return funcion_general(T_TAG_CLOSE_CLOSE);}
"</" {if(estado!=6){estado = 3;} if(estado!=6) return funcion_general(T_TAG_CLOSE_OPEN);}
">" {if(estado!=6){estado = 0;} if(estado!=6) return funcion_general(T_TAG_CLOSE);}
{DOCTYPE} {if(estado!=6) return funcion_general(T_DOCTYPE);}

	/* Etiquetas Generales */
"html" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_HTML,0));}
"head" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_HEAD,0));}
"body" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_BODY,0));}

	/* Etiquetas de Cabecera */
"link" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_LINK,0));}
"meta" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_META,0));}
"script" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_SCRIPT,0));}
"style" {if(estado!=6) return funcion_general(define_Etiqueta_Atributo(T_TAG_STYLE,T_ATR_STYLE));}
"title" {if(estado!=6) return funcion_general(define_Etiqueta_Atributo(T_TAG_TITLE,T_ATR_TITLE));}

	/* Etiquetas Variadas */
"a" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_A,0));}
"blockquote" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_BLOCKQUOTE,0));}
"br" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_BR,0));}
"div" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_DIV,0));}
"hr" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_HR,0));}
"img" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_IMG,0));}
"span" {if(estado!=6) return funcion_general(define_Etiqueta_Atributo(T_TAG_SPAN,T_ATR_SPAN));}

	/* Etiquetas Bloques */
"h1" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H1,0));}
"h2" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H2,0));}
"h3" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H3,0));}
"h4" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H4,0));}
"h5" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H5,0));}
"h6" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_H6,0));}
"p" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_P,0));}
"pre" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_PRE,0));}

	/* Etiquetas Texto */
"code" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_CODE,0));}
"em" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_EM,0));}
"strong" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_STRONG,0));}

	/* Etiquetas Listas */
"ol" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_OL,0));}
"ul" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_UL,0));}
"li" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_LI,0));}
"dl" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_DL,0));}
"dt" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_DT,0));}
"dd" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_DD,0));}

	/* Etiquetas Tablas */
"table" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_TABLE,0));}
"caption" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_CAPTION,0));}
"tr" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_TR,0));}
"th" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_TH,0));}
"td" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_TD,0));}

	/* Etiquetas Formularios */
"form" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_FORM,0));}
"button" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_BUTTON,0));}
"input" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_INPUT,0));}
"textarea" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_TEXTAREA,0));}


	/* Etiquetas de Objetos */
"object" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_OBJECT,0));}


	/* Otras Etiquetas*/
"b" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_B,0));}

	/*Atributos*/
"abbr" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ABBR,1));}
"cite" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_CITE,1));}
"about" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ABOUT,1));}
"activate" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ACTIVATE,1));}
"alt" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ALT,1));}
"archive" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ARCHIVE,1));}
"axis" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_AXIS,1));}
"charset" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_CHARSET,1));}
"class" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_CLASS,1));}
"colspan" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_COLSPAN,1));}
"content-length" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_CONTENL,1));}
"content" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_CONTENT,1));}
"coords" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_COORDS,1));}
"datatype" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DATATYPE,1));}
"datetime" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DATETIME,1));}
"declare" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DECLARE,1));}
"defaultAction" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DEFAULTACT,1));}
"defer" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DEFER,1));}
"dir" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DIR,1));}
"disabled" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_DISABLED,1));}
"edit" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_EDIT,1));}
"encoding" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ENCODING,1));}
"eventTarget" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_EVENTTARGET,1));}
"event" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_EVENT,1));}
"full" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_FULL,1));}
"handler" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HANDLER,1));}
"height" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HEIGHT,1));}
"href" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HREF,1));}
"hreflang" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HREFLANG,1));}
"hrefmedia" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HREFMEDIA,1));}
"hreftype" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_HREFTYPE,1));}
"id" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ID,1));}
"implements" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_IMPLEMENTS,1));}
"ismap" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ISMAP,1));}
"its:translate" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ITSTRANS,1));}
"key" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_KEY,1));}
"layout" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_LAYOUT,1));}
"media" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_MEDIA,1));}
"name" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_NAME,1));}
"nextfocus" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_NEXTFOCUS,1));}
"observer" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_OBSERVER,1));}
"order" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ORDER,1));}
"phase" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_PHASE,1));}
"prevfocus" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_PREVFOCUS,1));}
"profile" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_PROFILE,1));}
"propagate" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_PROPAGATE,1));}
"property" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_PROPERTY,1));}
"rel" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_REL,1));}
"resource" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_RESOURCE,1));}
"rev" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_REV,1));}
"role" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ROLE,1));}
"rowspan" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ROWSPAN,1));}
"scope" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_SCOPE,1));}
"shape" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_SHAPE,1));}
"src" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_SRC,1));}
"srctype" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_SRCTYPE,1));}
"target" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_TARGET,1));}
"targetid" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_TARGETID,1));}
"targetrole" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_TARGETROLE,1));}
"type" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_TYPE,1));}
"typeof" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_TYPEOF,1));}
"usemap" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_USEMAP,1));}
"value" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_VALUE,1));}
"valuetype" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_VALUETYPE,1));}
"version" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_VERSION,1));}
"width" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_WIDTH,1));}
"xml:base" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_XMLBASE,1));}
"xml:id" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_XMLID,1));}
"xml:lang" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_XMLLANG,1));}
"xsi:schemaLocation" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_XSI,1));}
"xmlns" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_XMLNS,1));}
"lang" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_LANG,1));}

	/*Atributos de Accion*/
"onabort" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONABORT,1));}
"onblur" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONBLUR,1));}
"onchange" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONCHANGE,1));}
"onerror" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONERROR,1));}
"onfocus" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONFOCUS,1));}
"onhelp" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONHELP,1));}
"onload" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONLOAD,1));}
"onmove" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONMOVE,1));}
"onreset" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONRESET,1));}
"onresize" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONRESIZE,1));}
"onsubmit" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONSUBMIT,1));}
"onunload" {if(estado!=6) return funcion_general(define_Etiqueta(T_ATR_ONUNLOAD,1));}
"onclick" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONCLICK,1));}
"ondblclick" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONDBLCLICK,1));}
"onmousedown" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONMOSUEDOWN,1));}
"onmouseup" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONMOUSEUP,1));}
"onmouseover" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONMOUSEOVER,1));}
"onmousemove" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONMOUSEMOVE,1));}
"onmouseout" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONMOUSEOUT,1));}
"onkeypress" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONKEYPRESS,1));}
"onkeydown" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONKEYDOWN,1));}
"onkeyup" {if(estado!=6) return funcion_general(define_Etiqueta(T_TAG_ONKEYUP,1));}

	/*Espacios*/
[ \t\n] {conteo(); }

	/*Otros valores*/
"=" {if(estado!=6) return funcion_general(define_token_igual());}
["] {if(estado!=6) return funcion_general(define_token_comilla());}
{complejos} {int token = define_token_value();
	     if(estado!=6) return funcion_general(token);}
<<EOF>>  {int token = endOfFile();
		if((token==T_ERROR_EOF&&estado==100)||token == T_EOF){return 0;}
		else if(token == T_ERROR_EOF){estado=100;return T_ERROR_EOF;}}
%%
void conteo()
{
	//se encarga de actualizar la linea y las columnas
	//entre las que se encuentra despues de cada
	//token leido
	int i;
	columna_Inicial = columna_Final;
	num_lineasF = num_lineas;
	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n'){
			columna_Final = 1;
			num_lineas++;
		}
		else if (yytext[i] == '\t')
			columna_Final += 8 - (columna_Final % 8);
		else
			columna_Final++;

}

int getCol_inicial(){
	return columna_Inicial;
}

int getCol_final(){
	return columna_Final;
}

int getLine_inicial(){
	return num_lineasF;
}

int getLine_final(){
	return num_lineas;
}

int endOfFile(){
	if(estado == 6){
		fprintf(stderr,"Line: %d col: %d lexical error unclosed comment %s\n", num_lineas,columna_Final,yytext);
		return T_ERROR_EOF; 
	}
	return T_EOF;
}

int funcion_general(int tok){
	//funcion que se realiza despues de encontrar cada token
	int token = tok;
	if(estado == 6){
		token = T_IGNORE;
	}
	conteo();
	yylval.str = (char *)malloc(strlen(yytext)+1);
	strcpy(yylval.str,yytext);
	return token;
}

int define_Etiqueta(int token,int modo){
	//define si el token encontrado es una etiqueta
	//o parte del texto
	int etiqueta = T_STRING;
		if(estado){
			etiqueta = token;
		}
		if(estado == 5){
			etiqueta = T_VALUE;
		}
		if(estado == 1 || estado == 3){
			estado = 2;
		}
		if(modo && estado == 2){
			etiqueta = T_ATR;
		}
	return etiqueta;
}

int define_Etiqueta_Atributo(int token,int token_atribute){
	//define si es una etiqueta o un atributo
	// solo para etiquetas abbr, style, title, span, cite
	int etiqueta = T_ATR;
	if(estado == 1 || estado == 3){
		etiqueta = token;
		estado = 2;
	}
	if(estado == 5){
			etiqueta = T_VALUE;
	}
	return etiqueta;
}

int define_token_igual(){
	//determina si al encontrar un igual es parte del texto
	//o se encuentra dentro de una etiqueta
	int etiqueta = T_STRING;
	if(estado == 2){
		etiqueta = T_IGUAL;
		estado = 4;
	}
	if(estado==5){
		etiqueta = T_VALUE;
	}
	return etiqueta;
}

int define_guion(){
	//determina si un guion es parte de un valor de atributo
	//o un string
	int token = T_STRING;
	if(estado == 5){
		token = T_VALUE;
	}
	return token;
}

int define_token_comilla(){
	//determina si al encontrar una comilla es parte del texto
	//o se encuentra dentro de una etiqueta
	int etiqueta = T_STRING;
	if(estado == 4){
		etiqueta = T_COMILLA;
		estado = 5;
	}
	else if(estado == 5){
		etiqueta = T_COMILLA;
		estado = 2;
	}
	return etiqueta;
}

int define_token_value(){
	//determina si el token encontrado es parte del texto
	//valor de un atributo
	//o un error
	int etiqueta = T_STRING;
	if(estado == 5){
		etiqueta = T_VALUE;
	}
	else if (estado == 2){
		etiqueta = T_ATR;
	}
	else if(estado == 1 || estado == 3){
		etiqueta = T_ERROR;
		fprintf(stderr,"Line: %d col: %d lexical error, invalid tag %s\n", num_lineas,columna_Final,yytext);
	}
	return etiqueta;
}
