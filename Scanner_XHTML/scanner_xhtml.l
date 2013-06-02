%{
	//Variables de conteo de la cantidad de lineas y la columna para cada 		token encontrado
	int num_lineas = 1, columna_Inicial = 1, columna_Final = 1;
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
	int T_COMMENT = 0;
	int T_COMMENT_CLOSE = 1000;
	int T_TAG_OPEN = 1;
	int T_TAG_CLOSE_CLOSE = 2;
	int T_TAG_CLOSE_OPEN = 3;
	int T_TAG_CLOSE = 4;
	int T_CDATA = 5;
	int T_CDATA_CLOSE = 5000;
	int T_DOCTYPE = 6;

	/* TOKENS Etiquetas Generales */
	int T_TAG_HTML = 7;
	int T_TAG_HEAD = 8;
	int T_TAG_BODY = 9;

	/* TOKENS Etiquetas de Cabecera */
	int T_TAG_BASE = 10;
	int T_TAG_LINK = 11;
	int T_TAG_META = 12;
	int T_TAG_NOSCRIPT = 13;
	int T_TAG_SCRIPT = 14;
	int T_TAG_STYLE = 15;
	int T_TAG_TITLE = 16;

	/* TOKENS Etiquetas Variadas */
	int T_TAG_A = 17;
	int T_TAG_BLOCKQUOTE = 18;
	int T_TAG_BR = 19;
	int T_TAG_DIV = 20;
	int T_TAG_HR = 21;
	int T_TAG_IMG = 22;
	int T_TAG_SPAN = 23;

	/* TOKENS Etiquetas Bloques */
	int T_TAG_ADDRESS = 24;
	int T_TAG_H1 = 25;
	int T_TAG_H2 = 26;
	int T_TAG_H3 = 27;
	int T_TAG_H4 = 28;
	int T_TAG_H5 = 29;
	int T_TAG_H6 = 30;
	int T_TAG_P = 31;
	int T_TAG_PRE = 32;

	/* TOKENS Etiquetas Texto */
	int T_TAG_ABBR = 33;
	int T_TAG_ACRONYM = 34;
	int T_TAG_BDO = 35;
	int T_TAG_CITE = 36;
	int T_TAG_CODE = 37;
	int T_TAG_DEL = 38;
	int T_TAG_DFN = 39;
	int T_TAG_EM = 40;
	int T_TAG_INS = 41;
	int T_TAG_KBD = 42;
	int T_TAG_Q = 43;
	int T_TAG_SAMP = 44;
	int T_TAG_STRONG = 45;
	int T_TAG_SUB = 46;
	int T_TAG_SUP = 47;
	int T_TAG_VAR = 48;

	/* TOKENS Etiquetas Listas */
	int T_TAG_OL = 49;
	int T_TAG_UL = 50;
	int T_TAG_LI = 51;
	int T_TAG_DL = 52;
	int T_TAG_DT = 53;
	int T_TAG_DD = 54;

	/* TOKENS Etiquetas Tablas */
	int T_TAG_TABLE = 55;
	int T_TAG_CAPTION = 56;
	int T_TAG_COL = 57;
	int T_TAG_COLGROUP = 58;
	int T_TAG_THEAD = 59;
	int T_TAG_TBODY = 60;
	int T_TAG_TFOOT = 62;
	int T_TAG_TR = 62;
	int T_TAG_TH = 63;
	int T_TAG_TD = 64;

	/* TOKENS Etiquetas Formularios */
	int T_TAG_FORM = 65;
	int T_TAG_FIELDSET = 66;
	int T_TAG_LEGEND = 67;
	int T_TAG_LABEL = 68;
	int T_TAG_BUTTON = 69;
	int T_TAG_INPUT = 70;
	int T_TAG_OPTION = 71;
	int T_TAG_OPTGROUP = 72;
	int T_TAG_SELECT = 73;
	int T_TAG_TEXTAREA = 74;

	/* TOKENS Etiquetas Mapas de imagen */
	int T_TAG_MAP = 75;
	int T_TAG_AREA = 76;

	/* TOKENS Etiquetas de Objetos */
	int T_TAG_IFRAME = 77;
	int T_TAG_OBJECT = 78;
	int T_TAG_PARAM = 79;

	/* TOKENS Etiquetas de Frames */
	int T_TAG_FRAMESET = 80;
	int T_TAG_FRAME = 81;
	int T_TAG_NOFRAMES = 82;

	/* TOKENS Otras Etiquetas*/
	int T_TAG_B = 83;
	int T_TAG_BIG = 84;
	int T_TAG_I = 85;
	int T_TAG_SMALL = 86;
	int T_TAG_TT = 87;
	int T_TAG_ACCESS = 88;

	/* TOKENS Etiquetas Obsoletas
	int T_TAG_APPLET = 88;
	int T_TAG_BASEFONT = 89;
	int T_TAG_CENTER = 90;
	int T_TAG_FONT = 91;
	int T_TAG_ISINDEX = 92;
	int T_TAG_MENU = 93;
	int T_TAG_S = 94;
	int T_TAG_STRIKE = 95;
	int T_TAG_U = 96;
	int T_TAG_DIR = 97;*/

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
	int T_ATR_UNKNOWN = 173;

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
	int T_IGUAL = 300;
	int T_COMILLA = 301;

	/* TOKEN DE STRING */
	int T_STRING = 400;

	/* TOKEN DE ATTRIBUTE VALUE */
	int T_VALUE = 500;

	/* Error */
	int T_ERROR = 600;

	/* TOKEN IGNORADO*/
	int T_IGNORE = 700;
%}
DOCTYPE "<!DOCTYPE"[^>]*">"
simbolos [^ \]\-=\"<>a-zA-Z0-9\t\n]+
palabras [a-zA-Z]+
numeros [0-9]+
complejos ({palabras}|{simbolos}|{numeros})*
%%

 	/*Caracteres especiales*/
"-" {return funcion_general(T_STRING);}
"]" {return funcion_general(T_STRING);}
"<!--" {estado=6;conteo();printf("%d\n",T_COMMENT);return T_COMMENT;}
"--!>" {estado=0;return funcion_general(T_COMMENT_CLOSE);}
"<![CDATA[" {estado=6;conteo();printf("%d\n",T_CDATA);return T_CDATA;}
"]]>" {estado=0;return funcion_general(T_CDATA_CLOSE);}
"<" {if(estado!=6){estado = 1;}return funcion_general(T_TAG_OPEN);}
"/>" {if(estado!=6){estado = 0;}return funcion_general(T_TAG_CLOSE_CLOSE);}
"</" {if(estado!=6){estado = 3;}return funcion_general(T_TAG_CLOSE_OPEN);}
">" {if(estado!=6){estado = 0;}return funcion_general(T_TAG_CLOSE);}
{DOCTYPE} {return funcion_general(T_DOCTYPE);}

	/* Etiquetas Generales */
"html" {return funcion_general(define_Etiqueta(T_TAG_HTML,0));}
"head" {return funcion_general(define_Etiqueta(T_TAG_HEAD,0));}
"body" {return funcion_general(define_Etiqueta(T_TAG_BODY,0));}

	/* Etiquetas de Cabecera */
"base" {return funcion_general(define_Etiqueta(T_TAG_BASE,0));}
"link" {return funcion_general(define_Etiqueta(T_TAG_LINK,0));}
"meta" {return funcion_general(define_Etiqueta(T_TAG_META,0));}
"noscript" {return funcion_general(define_Etiqueta(T_TAG_NOSCRIPT,0));}
"script" {return funcion_general(define_Etiqueta(T_TAG_SCRIPT,0));}
"style" {return funcion_general(define_Etiqueta_Atributo(T_TAG_STYLE,T_ATR_STYLE));}
"title" {return funcion_general(define_Etiqueta_Atributo(T_TAG_TITLE,T_ATR_TITLE));}

	/* Etiquetas Variadas */
"a" {return funcion_general(define_Etiqueta(T_TAG_A,0));}
"blockquote" {return funcion_general(define_Etiqueta(T_TAG_BLOCKQUOTE,0));}
"br" {return funcion_general(define_Etiqueta(T_TAG_BR,0));}
"div" {return funcion_general(define_Etiqueta(T_TAG_DIV,0));}
"hr" {return funcion_general(define_Etiqueta(T_TAG_HR,0));}
"img" {return funcion_general(define_Etiqueta(T_TAG_IMG,0));}
"span" {return funcion_general(define_Etiqueta_Atributo(T_TAG_SPAN,T_ATR_SPAN));}
	/* Etiquetas Bloques */
"address" {return funcion_general(define_Etiqueta(T_TAG_ADDRESS,0));}
"h1" {return funcion_general(define_Etiqueta(T_TAG_H1,0));}
"h2" {return funcion_general(define_Etiqueta(T_TAG_H2,0));}
"h3" {return funcion_general(define_Etiqueta(T_TAG_H3,0));}
"h4" {return funcion_general(define_Etiqueta(T_TAG_H4,0));}
"h5" {return funcion_general(define_Etiqueta(T_TAG_H5,0));}
"h6" {return funcion_general(define_Etiqueta(T_TAG_H6,0));}
"p" {return funcion_general(define_Etiqueta(T_TAG_P,0));}
"pre" {return funcion_general(define_Etiqueta(T_TAG_PRE,0));}

	/* Etiquetas Texto */
"abbr" {return funcion_general(define_Etiqueta_Atributo(T_TAG_ABBR,T_ATR_ABBR));}
"acronym" {return funcion_general(define_Etiqueta(T_TAG_ACRONYM,0));}
"bdo" {return funcion_general(define_Etiqueta(T_TAG_BDO,0));}
"cite" {return funcion_general(define_Etiqueta_Atributo(T_TAG_CITE,T_ATR_CITE));}
"code" {return funcion_general(define_Etiqueta(T_TAG_CODE,0));}
"del" {return funcion_general(define_Etiqueta(T_TAG_DEL,0));}
"dfn" {return funcion_general(define_Etiqueta(T_TAG_DFN,0));}
"em" {return funcion_general(define_Etiqueta(T_TAG_EM,0));}
"ins" {return funcion_general(define_Etiqueta(T_TAG_INS,0));}
"kbd" {return funcion_general(define_Etiqueta(T_TAG_KBD,0));}
"q" {return funcion_general(define_Etiqueta(T_TAG_Q,0));}
"samp" {return funcion_general(define_Etiqueta(T_TAG_SAMP,0));}
"strong" {return funcion_general(define_Etiqueta(T_TAG_STRONG,0));}
"sub" {return funcion_general(define_Etiqueta(T_TAG_SUB,0));}
"sup" {return funcion_general(define_Etiqueta(T_TAG_SUP,0));}
"var" {return funcion_general(define_Etiqueta(T_TAG_VAR,0));}

	/* Etiquetas Listas */
"ol" {return funcion_general(define_Etiqueta(T_TAG_OL,0));}
"ul" {return funcion_general(define_Etiqueta(T_TAG_UL,0));}
"li" {return funcion_general(define_Etiqueta(T_TAG_LI,0));}
"dl" {return funcion_general(define_Etiqueta(T_TAG_DL,0));}
"dt" {return funcion_general(define_Etiqueta(T_TAG_DT,0));}
"dd" {return funcion_general(define_Etiqueta(T_TAG_DD,0));}

	/* Etiquetas Tablas */
"table" {return funcion_general(define_Etiqueta(T_TAG_TABLE,0));}
"caption" {return funcion_general(define_Etiqueta(T_TAG_CAPTION,0));}
"col" {return funcion_general(define_Etiqueta(T_TAG_COL,0));}
"colgroup" {return funcion_general(define_Etiqueta(T_TAG_COLGROUP,0));}
"thead" {return funcion_general(define_Etiqueta(T_TAG_THEAD,0));}
"tbody" {return funcion_general(define_Etiqueta(T_TAG_TBODY,0));}
"tfoot" {return funcion_general(define_Etiqueta(T_TAG_TFOOT,0));}
"tr" {return funcion_general(define_Etiqueta(T_TAG_TR,0));}
"th" {return funcion_general(define_Etiqueta(T_TAG_TH,0));}
"td" {return funcion_general(define_Etiqueta(T_TAG_TD,0));}

	/* Etiquetas Formularios */
"form" {return funcion_general(define_Etiqueta(T_TAG_FORM,0));}
"fieldset" {return funcion_general(define_Etiqueta(T_TAG_FIELDSET,0));}
"legend" {return funcion_general(define_Etiqueta(T_TAG_LEGEND,0));}
"label" {return funcion_general(define_Etiqueta(T_TAG_LABEL,0));}
"button" {return funcion_general(define_Etiqueta(T_TAG_BUTTON,0));}
"input" {return funcion_general(define_Etiqueta(T_TAG_INPUT,0));}
"option" {return funcion_general(define_Etiqueta(T_TAG_OPTION,0));}
"optgroup" {return funcion_general(define_Etiqueta(T_TAG_OPTGROUP,0));}
"select" {return funcion_general(define_Etiqueta(T_TAG_SELECT,0));}
"textarea" {return funcion_general(define_Etiqueta(T_TAG_TEXTAREA,0));}

	/* Etiquetas Mapas de imagen */
"map" {return funcion_general(define_Etiqueta(T_TAG_MAP,0));}
"area" {return funcion_general(define_Etiqueta(T_TAG_AREA,0));}

	/* Etiquetas de Objetos */
"iframe" {return funcion_general(define_Etiqueta(T_TAG_IFRAME,0));}
"object" {return funcion_general(define_Etiqueta(T_TAG_OBJECT,0));}
"param" {return funcion_general(define_Etiqueta(T_TAG_PARAM,0));}

	/* Etiquetas de Frames */
"frameset" {return funcion_general(define_Etiqueta(T_TAG_FRAMESET,0));}
"frame" {return funcion_general(define_Etiqueta(T_TAG_FRAME,0));}
"noframes" {return funcion_general(define_Etiqueta(T_TAG_NOFRAMES,0));}

	/* Otras Etiquetas*/
"b" {return funcion_general(define_Etiqueta(T_TAG_B,0));}
"big" {return funcion_general(define_Etiqueta(T_TAG_BIG,0));}
"i" {return funcion_general(define_Etiqueta(T_TAG_I,0));}
"small" {return funcion_general(define_Etiqueta(T_TAG_SMALL,0));}
"tt" {return funcion_general(define_Etiqueta(T_TAG_TT,0));}
"access" {return funcion_general(define_Etiqueta(T_TAG_ACCESS,0));}


	/*Atributos*/
"about" {return funcion_general(define_Etiqueta(T_ATR_ABOUT,1));}
"activate" {return funcion_general(define_Etiqueta(T_ATR_ACTIVATE,1));}
"alt" {return funcion_general(define_Etiqueta(T_ATR_ALT,1));}
"archive" {return funcion_general(define_Etiqueta(T_ATR_ARCHIVE,1));}
"axis" {return funcion_general(define_Etiqueta(T_ATR_AXIS,1));}
"charset" {return funcion_general(define_Etiqueta(T_ATR_CHARSET,1));}
"class" {return funcion_general(define_Etiqueta(T_ATR_CLASS,1));}
"colspan" {return funcion_general(define_Etiqueta(T_ATR_COLSPAN,1));}
"content-length" {return funcion_general(define_Etiqueta(T_ATR_CONTENL,1));}
"content" {return funcion_general(define_Etiqueta(T_ATR_CONTENT,1));}
"coords" {return funcion_general(define_Etiqueta(T_ATR_COORDS,1));}
"datatype" {return funcion_general(define_Etiqueta(T_ATR_DATATYPE,1));}
"datetime" {return funcion_general(define_Etiqueta(T_ATR_DATETIME,1));}
"declare" {return funcion_general(define_Etiqueta(T_ATR_DECLARE,1));}
"defaultAction" {return funcion_general(define_Etiqueta(T_ATR_DEFAULTACT,1));}
"defer" {return funcion_general(define_Etiqueta(T_ATR_DEFER,1));}
"dir" {return funcion_general(define_Etiqueta(T_ATR_DIR,1));}
"disabled" {return funcion_general(define_Etiqueta(T_ATR_DISABLED,1));}
"edit" {return funcion_general(define_Etiqueta(T_ATR_EDIT,1));}
"encoding" {return funcion_general(define_Etiqueta(T_ATR_ENCODING,1));}
"eventTarget" {return funcion_general(define_Etiqueta(T_ATR_EVENTTARGET,1));}
"event" {return funcion_general(define_Etiqueta(T_ATR_EVENT,1));}
"full" {return funcion_general(define_Etiqueta(T_ATR_FULL,1));}
"handler" {return funcion_general(define_Etiqueta(T_ATR_HANDLER,1));}
"height" {return funcion_general(define_Etiqueta(T_ATR_HEIGHT,1));}
"href" {return funcion_general(define_Etiqueta(T_ATR_HREF,1));}
"hreflang" {return funcion_general(define_Etiqueta(T_ATR_HREFLANG,1));}
"hrefmedia" {return funcion_general(define_Etiqueta(T_ATR_HREFMEDIA,1));}
"hreftype" {return funcion_general(define_Etiqueta(T_ATR_HREFTYPE,1));}
"id" {return funcion_general(define_Etiqueta(T_ATR_ID,1));}
"implements" {return funcion_general(define_Etiqueta(T_ATR_IMPLEMENTS,1));}
"ismap" {return funcion_general(define_Etiqueta(T_ATR_ISMAP,1));}
"its:translate" {return funcion_general(define_Etiqueta(T_ATR_ITSTRANS,1));}
"key" {return funcion_general(define_Etiqueta(T_ATR_KEY,1));}
"layout" {return funcion_general(define_Etiqueta(T_ATR_LAYOUT,1));}
"media" {return funcion_general(define_Etiqueta(T_ATR_MEDIA,1));}
"name" {return funcion_general(define_Etiqueta(T_ATR_NAME,1));}
"nextfocus" {return funcion_general(define_Etiqueta(T_ATR_NEXTFOCUS,1));}
"observer" {return funcion_general(define_Etiqueta(T_ATR_OBSERVER,1));}
"order" {return funcion_general(define_Etiqueta(T_ATR_ORDER,1));}
"phase" {return funcion_general(define_Etiqueta(T_ATR_PHASE,1));}
"prevfocus" {return funcion_general(define_Etiqueta(T_ATR_PREVFOCUS,1));}
"profile" {return funcion_general(define_Etiqueta(T_ATR_PROFILE,1));}
"propagate" {return funcion_general(define_Etiqueta(T_ATR_PROPAGATE,1));}
"property" {return funcion_general(define_Etiqueta(T_ATR_PROPERTY,1));}
"rel" {return funcion_general(define_Etiqueta(T_ATR_REL,1));}
"resource" {return funcion_general(define_Etiqueta(T_ATR_RESOURCE,1));}
"rev" {return funcion_general(define_Etiqueta(T_ATR_REV,1));}
"role" {return funcion_general(define_Etiqueta(T_ATR_ROLE,1));}
"rowspan" {return funcion_general(define_Etiqueta(T_ATR_ROWSPAN,1));}
"scope" {return funcion_general(define_Etiqueta(T_ATR_SCOPE,1));}
"shape" {return funcion_general(define_Etiqueta(T_ATR_SHAPE,1));}
"src" {return funcion_general(define_Etiqueta(T_ATR_SRC,1));}
"srctype" {return funcion_general(define_Etiqueta(T_ATR_SRCTYPE,1));}
"target" {return funcion_general(define_Etiqueta(T_ATR_TARGET,1));}
"targetid" {return funcion_general(define_Etiqueta(T_ATR_TARGETID,1));}
"targetrole" {return funcion_general(define_Etiqueta(T_ATR_TARGETROLE,1));}
"type" {return funcion_general(define_Etiqueta(T_ATR_TYPE,1));}
"typeof" {return funcion_general(define_Etiqueta(T_ATR_TYPEOF,1));}
"usemap" {return funcion_general(define_Etiqueta(T_ATR_USEMAP,1));}
"value" {return funcion_general(define_Etiqueta(T_ATR_VALUE,1));}
"valuetype" {return funcion_general(define_Etiqueta(T_ATR_VALUETYPE,1));}
"version" {return funcion_general(define_Etiqueta(T_ATR_VERSION,1));}
"width" {return funcion_general(define_Etiqueta(T_ATR_WIDTH,1));}
"xml:base" {return funcion_general(define_Etiqueta(T_ATR_XMLBASE,1));}
"xml:id" {return funcion_general(define_Etiqueta(T_ATR_XMLID,1));}
"xml:lang" {return funcion_general(define_Etiqueta(T_ATR_XMLLANG,1));}
"xsi:schemaLocation" {return funcion_general(define_Etiqueta(T_ATR_XSI,1));}

	/*Atributos de Accion*/
"onabort" {return funcion_general(define_Etiqueta(T_ATR_ONABORT,1));}
"onblur" {return funcion_general(define_Etiqueta(T_ATR_ONBLUR,1));}
"onchange" {return funcion_general(define_Etiqueta(T_ATR_ONCHANGE,1));}
"onerror" {return funcion_general(define_Etiqueta(T_ATR_ONERROR,1));}
"onfocus" {return funcion_general(define_Etiqueta(T_ATR_ONFOCUS,1));}
"onhelp" {return funcion_general(define_Etiqueta(T_ATR_ONHELP,1));}
"onload" {return funcion_general(define_Etiqueta(T_ATR_ONLOAD,1));}
"onmove" {return funcion_general(define_Etiqueta(T_ATR_ONMOVE,1));}
"onreset" {return funcion_general(define_Etiqueta(T_ATR_ONRESET,1));}
"onresize" {return funcion_general(define_Etiqueta(T_ATR_ONRESIZE,1));}
"onsubmit" {return funcion_general(define_Etiqueta(T_ATR_ONSUBMIT,1));}
"onunload" {return funcion_general(define_Etiqueta(T_ATR_ONUNLOAD,1));}
"onclick" {return funcion_general(define_Etiqueta(T_TAG_ONCLICK,1));}
"ondblclick" {return funcion_general(define_Etiqueta(T_TAG_ONDBLCLICK,1));}
"onmousedown" {return funcion_general(define_Etiqueta(T_TAG_ONMOSUEDOWN,1));}
"onmouseup" {return funcion_general(define_Etiqueta(T_TAG_ONMOUSEUP,1));}
"onmouseover" {return funcion_general(define_Etiqueta(T_TAG_ONMOUSEOVER,1));}
"onmousemove" {return funcion_general(define_Etiqueta(T_TAG_ONMOUSEMOVE,1));}
"onmouseout" {return funcion_general(define_Etiqueta(T_TAG_ONMOUSEOUT,1));}
"onkeypress" {return funcion_general(define_Etiqueta(T_TAG_ONKEYPRESS,1));}
"onkeydown" {return funcion_general(define_Etiqueta(T_TAG_ONKEYDOWN,1));}
"onkeyup" {return funcion_general(define_Etiqueta(T_TAG_ONKEYUP,1));}

	/*Espacios*/
[ \t\n] {conteo(); }

	/*Otros valores*/
"=" {return funcion_general(define_token_igual());}
["] {return funcion_general(define_token_comilla());}
{complejos} {int token = define_token_value();
	     return funcion_general(token);}
<<EOF>>  {return -1;}
%%
void main(int argc,char *args[]) {
	FILE *file;
	file = fopen(args[1], "r");
	if (!file) {
		printf("-No se pudo abrir archivo\n");
		return;
	}
	yyin = file;
	while(yylex()+1){
	}
}

void conteo()
{
	//se encarga de actualizar la linea y las columnas
	//entre las que se encuentra despues de cada
	//token leido
	int i;
	columna_Inicial = columna_Final;
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

int funcion_general(int tok){
	//funcion que se realiza despues de encontrar cada token
	int token = tok;
	if(estado == 6){
		token = T_IGNORE;
	}
	conteo();
	printf("%d\n",token);
	return token;
}

int define_Etiqueta(int token,int modo){
	//define si el token encontrado es una etiqueta
	//o parte del texto
	int etiqueta = T_STRING;
		if((modo && estado == 2) || estado){
			etiqueta = token;
		}
		if(estado == 5){
			etiqueta = T_VALUE;
		}
		if(estado == 1 || estado == 3){
			estado = 2;
		}
	return etiqueta;
}

int define_Etiqueta_Atributo(int token,int token_atribute){
	//define si es una etiqueta o un atributo
	// solo para etiquetas abbr, style, title, span, cite
	int etiqueta = token_atribute;
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
	return etiqueta;
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
		etiqueta = T_ATR_UNKNOWN;
	}
	else if(estado == 1 || estado == 3){
		etiqueta = T_ERROR;
		fprintf(stderr,"Error lexico en la linea %d columna %d, etiqueta incorrecta %s\n", num_lineas,columna_Final,yytext);
	}
	return etiqueta;
}
