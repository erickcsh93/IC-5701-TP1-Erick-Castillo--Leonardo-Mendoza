%{
//Parser para archivos XHTML, con una estructura reducida
#include <stdio.h>
#include "arbol.h"
#define YYERROR_VERBOSE 1 //se utiliza para dar mensajes de error completos
//#define YYDEBUG 1
%}
//se redefine la variable yylval para que tenga dos atributos uno de tipo
//char* para los token que van a tener un valor de tipo string y otro de tipo nodo
//(ver arbol.h) para las producciones, las cuales van a ir almacenando
//partes del parseTREE
%union{
	char *str; 
	struct nodo *arb;
}
//Definicion de tokens
%token <str> T_COMMENT T_COMMENT_CLOSE T_TAG_OPEN T_TAG_CLOSE_CLOSE  T_TAG_CLOSE_OPEN T_TAG_CLOSE  T_DOCTYPE T_TAG_A  T_TAG_B  T_TAG_BLOCKQUOTE  T_TAG_BODY  T_TAG_BR  T_TAG_BUTTON  T_TAG_CAPTION  T_TAG_CODE  T_TAG_DIV  T_TAG_DL  T_TAG_DT  T_TAG_DD  T_TAG_EM T_TAG_FORM  T_TAG_H1  T_TAG_H2  T_TAG_H3  T_TAG_H4  T_TAG_H5  T_TAG_H6  T_TAG_HEAD T_TAG_HR  T_TAG_HTML  T_TAG_IMG  T_TAG_INPUT  T_TAG_LI  T_TAG_LINK  T_TAG_META  T_TAG_OBJECT  T_TAG_OL T_TAG_P  T_TAG_PRE  T_TAG_SCRIPT  T_TAG_SPAN  T_TAG_STRONG  T_TAG_STYLE  T_TAG_TABLE  T_TAG_TD  T_TAG_TH  T_TAG_TR  T_TAG_TEXTAREA  T_TAG_TITLE  T_TAG_UL  T_ATR  T_IGUAL  T_COMILLA  T_STRING  T_VALUE T_ERROR  T_ERROR_EOF  T_IGNORE  T_EOF
//Declaracion de los tipos de las producciones no terminales
%type <arb> xhtml_doc DOCTYPE HTML abre_html content_html cierra_html head  abre_head content_head cierra_head content_head2 content_head3 body abre_body content_body cierra_body tag_a abre_a content_a cierra_a tag_b abre_b cierra_b content_b blockquote abre_blockquote cierra_blockquote content_blockquote br button abre_button cierra_button content_button caption abre_caption cierra_caption content_caption code abre_code cierra_code content_code div abre_div cierra_div content_div dl abre_dl cierra_dl content_dl dd abre_dd cierra_dd content_dd dt abre_dt cierra_dt content_dt em abre_em cierra_em content_em form abre_form cierra_form content_form h1 abre_h1 cierra_h1 h2 abre_h2 cierra_h2 h3 abre_h3 cierra_h3 h4 abre_h4 cierra_h4 h5 abre_h5 cierra_h5 h6 abre_h6 cierra_h6 content_h1_h6 hr img input li abre_li cierra_li content_li link meta object abre_object cierra_object content_object ol abre_ol cierra_ol content_ol tag_p abre_p cierra_p content_p pre abre_pre cierra_pre content_pre script abre_script cierra_script content_script span abre_span cierra_span content_span strong abre_strong cierra_strong content_strong style abre_style cierra_style content_style table abre_table cierra_table content_table content_table2 content_table3 td abre_td cierra_td content_td th abre_th cierra_th content_th tr abre_tr cierra_tr content_tr textarea abre_textarea cierra_textarea content_textarea title abre_title cierra_title content_title ul abre_ul cierra_ul content_ul atributos atributos2 atributo value
%%
/*
	Definicion de la gramatica: Se define la gramatica de la forma 
	NO-TERMINAL-> TERMINAL|NO-TERMINAL|TERMINAL NO-TERMINAL|NO-TERMINAL TERMINAL| vacio
	Un no terminal consiste en un token
	Para la forma NO-TERMINAL pueden ser varios no terminales
	Para la forma TERMINAL NO-TERMINAL|NO-TERMINAL TERMINAL puede haber x no terminales y m terminales
	
	La produccion inicial es xhtml_doc la cual se desglosa en DOCTYPE y HTML de las cuales se desprende el 
	resto de la gramatica

	A partir de aqui considere etiqueta en las producciones como el nombre de cualquier etiqueta(ej: html,blockquote,br,...)
	Las producciones son de la forma
	etiqueta: abre_etiqueta content_etiqueta cierra_etiqueta 
	para etiquetas que deben poseer obligatoriamente un tag de cierre de la forma </etiqueta>
	abre_etiqueta tiene la forma abre_etiqueta: T_TAG_OPEN T_TAG_ETIQUETA atributos T_TAG_CLOSE
	cierra_etiqueta tiene la forma cierra_etiqueta: T_TAG_CLOSE_OPEN T_TAG_ETIQUETA T_TAG_CLOSE
	content_etiqueta es el arbol de todo el contenido de la etiqueta, cada etiqueta tiene su produccion 
	especifica, donde se declara cuales etiquetas o valores puede tener y cuales debe para los casos
	de las etiquetas que no pueden ser cerradas hasta que contengan alguna otra en su interior.

	Hay producciones de la forma
	etiqueta: T_TAG_OPEN T_TAG_ETIQUETA T_TAG_CLOSE_CLOSE
	para producciones sin contenido de la forma <etiqueta/>

	Para los atributos se tiene la produccion atributos para determinar si es uno, varios o ningun atributo
	Cada atributo consiste en la produccion atributo: T_ATR T_IGUAL T_COMILLA value T_COMILLA donde value es un
	arbol con el valor del atributo. La produccion de value permite uno o mas valores.

	Ademas hay otras producciones auxiliares para resolver conflictos de shift/reduce y reduce/reduce


*/
xhtml_doc : DOCTYPE HTML	{$$ = creaNodoRedEGG("xhtml_doc",$1,$2);imprimeNodos($$,0);};
DOCTYPE: T_DOCTYPE 	{$$ = creaNodoRedET("DOCTYPE","T_DOCTYPE",$1);};

HTML : abre_html content_html cierra_html {$$ = creaNodoRedEGGG("HTML",$1,$2,$3);};
abre_html: T_TAG_OPEN T_TAG_HTML atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_html","T_TAG_HTML",$2,$3,"T_TAG_CLOSE",$4);};
cierra_html: T_TAG_CLOSE_OPEN T_TAG_HTML T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_html","T_TAG_HTML",$2);};
content_html: head body {$$ = creaNodoRedEGG("content_html",$1,$2);};

head: abre_head content_head cierra_head	{$$ = creaNodoRedEGGG("head",$1,$2,$3);}; 
abre_head: T_TAG_OPEN T_TAG_HEAD atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_head","T_TAG_HEAD",$2,$3,"T_TAG_CLOSE",$4);};
cierra_head: T_TAG_CLOSE_OPEN T_TAG_HEAD T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_head","T_TAG_HEAD",$2);};
content_head: 
	title		{$$ = creaNodoRedEG("content_head",$1);}
	| title content_head2		{$$ = creaNodoRedEGG("content_head",$1,$2);}
	| content_head2 title		{$$ = creaNodoRedEGG("content_head",$1,$2);}
	| content_head2 title content_head2	{$$ = creaNodoRedEGGG("content_head",$1,$2,$3);}
	;
content_head2:
	content_head2 content_head3	{$$ = creaNodoRedEGG("content_head2",$1,$2);}
	| content_head3		{$$ = creaNodoRedEG("content_head2",$1);}
	;
content_head3:
	link		{$$ = creaNodoRedEG("content_head3",$1);}
	| meta		{$$ = creaNodoRedEG("content_head3",$1);}
	| script	{$$ = creaNodoRedEG("content_head3",$1);}
	| style		{$$ = creaNodoRedEG("content_head3",$1);}
	;

body: abre_body content_body cierra_body {$$ = creaNodoRedEGGG("body",$1,$2,$3);};
abre_body: T_TAG_OPEN T_TAG_BODY atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_body","T_TAG_BODY",$2,$3,"T_TAG_CLOSE",$4);};
cierra_body: T_TAG_CLOSE_OPEN T_TAG_BODY T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_body","T_TAG_BODY",$2);};
content_body: 
	content_body tag_a		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body tag_b		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body blockquote	{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body br		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body button		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body code		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body div		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body dl		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body em		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body form		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h1		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h2		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h3		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h4		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h5		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body h6		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body hr		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body img		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body input		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body object		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body ol		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body tag_p		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body pre		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body script		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body span		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body strong		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body table		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body textarea		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| content_body ul		{$$ = creaNodoRedEGG("content_body",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_body");}
	;

tag_a: abre_a content_a cierra_a {$$ = creaNodoRedEGGG("tag_a",$1,$2,$3);};
abre_a: T_TAG_OPEN T_TAG_A atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_a","T_TAG_A",$2,$3,"T_TAG_CLOSE",$4);};
cierra_a: T_TAG_CLOSE_OPEN T_TAG_A T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_a","T_TAG_A",$2);};
content_a: 
	content_a T_STRING	{$$ = creaNodoRedEET("content_a",$1,"T_STRING",$2);}
	| content_a tag_b	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a br		{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a button	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a code	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a em		{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a img		{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a input	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a object	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a script	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a span	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a strong	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| content_a textarea	{$$ = creaNodoRedEGG("content_a",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_a");}
	;

tag_b: abre_b content_b cierra_b {$$ = creaNodoRedEGGG("tag_b",$1,$2,$3);};
abre_b: T_TAG_OPEN T_TAG_B atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_b","T_TAG_B",$2,$3,"T_TAG_CLOSE",$4);};
cierra_b: T_TAG_CLOSE_OPEN T_TAG_B T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_b","T_TAG_B",$2);};
content_b: 
	content_b T_STRING	{$$ = creaNodoRedEET("content_b",$1,"T_STRING",$2);}
	| content_b tag_a	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b tag_b	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b br		{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b button	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b code	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b em		{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b img		{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b input	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b object	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b script	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b span	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b strong	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| content_b textarea	{$$ = creaNodoRedEGG("content_b",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_b");}
	;

blockquote: abre_blockquote content_blockquote cierra_blockquote {$$ = creaNodoRedEGGG("blockquote",$1,$2,$3);};
abre_blockquote: T_TAG_OPEN T_TAG_BLOCKQUOTE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_blockquote","T_TAG_BLOCKQUOTE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_blockquote: T_TAG_CLOSE_OPEN T_TAG_BLOCKQUOTE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_blockquote","T_TAG_BLOCKQUOTE",$2);};
content_blockquote: 
	content_blockquote T_STRING	{$$ = creaNodoRedEET("content_blockquote",$1,"T_STRING",$2);}
	| content_blockquote tag_a	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote tag_b	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote blockquote	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote br		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote button	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote code	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote div	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote dl		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote em		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote form	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h1		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h2		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h3		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h4		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h5		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote h6		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote hr		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote img	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote input	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote object	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote ol		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote tag_p	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote pre	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote script	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote span	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote strong	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote table	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote textarea	{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| content_blockquote ul		{$$ = creaNodoRedEGG("content_blockquote",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_blockquote");}
	;

br: T_TAG_OPEN T_TAG_BR atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("br","T_TAG_BR",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};


button:abre_button content_button cierra_button {$$ = creaNodoRedEGGG("button",$1,$2,$3);};
abre_button: T_TAG_OPEN T_TAG_BUTTON atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_button","T_TAG_BUTTON",$2,$3,"T_TAG_CLOSE",$4);};
cierra_button: T_TAG_CLOSE_OPEN T_TAG_BUTTON T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_button","T_TAG_BUTTON",$2);};
content_button: 
	content_button T_STRING		{$$ = creaNodoRedEET("content_button",$1,"T_STRING",$2);}
	| content_button tag_a		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button tag_b		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button blockquote	{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button code		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button div		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button dl		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button em		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button form		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h1		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h2		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h3		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h4		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h5		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button h6		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button hr		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button img		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button input		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button object		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button ol		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button tag_p		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button pre		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button script		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button span		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button strong		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button table		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button textarea	{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| content_button ul		{$$ = creaNodoRedEGG("content_button",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_button");}
	;

caption: abre_caption content_caption cierra_caption {$$ = creaNodoRedEGGG("caption",$1,$2,$3);};
abre_caption: T_TAG_OPEN T_TAG_CAPTION atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_caption","T_TAG_CAPTION",$2,$3,"T_TAG_CLOSE",$4);};
cierra_caption: T_TAG_CLOSE_OPEN T_TAG_CAPTION T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_caption","T_TAG_CAPTION",$2);};
content_caption: 
	content_caption T_STRING	{$$ = creaNodoRedEET("content_caption",$1,"T_STRING",$2);}
	| content_caption tag_a		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption tag_b		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption br		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption button	{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption code		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption em		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption img		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption input		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption object	{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption script	{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption span		{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption strong	{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| content_caption textarea	{$$ = creaNodoRedEGG("content_caption",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_caption");}
	;

code: abre_code content_code cierra_code {$$ = creaNodoRedEGGG("code",$1,$2,$3);};
abre_code: T_TAG_OPEN T_TAG_CODE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_code","T_TAG_CODE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_code: T_TAG_CLOSE_OPEN T_TAG_CODE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_code","T_TAG_CODE",$2);};
content_code: 
	content_code T_STRING	{$$ = creaNodoRedEET("content_code",$1,"T_STRING",$2);}
	| content_code tag_a	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code tag_b	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code br	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code button	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code code	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code em	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code img	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code input	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code object	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code script	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code span	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| content_code strong	{$$ = creaNodoRedEGG("content_code",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_code");}
	;

div:abre_div content_div cierra_div {$$ = creaNodoRedEGGG("div",$1,$2,$3);};
abre_div: T_TAG_OPEN T_TAG_DIV atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_div","T_TAG_DIV",$2,$3,"T_TAG_CLOSE",$4);};
cierra_div: T_TAG_CLOSE_OPEN T_TAG_DIV T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_div","T_TAG_DIV",$2);};
content_div: 
	content_div T_STRING		{$$ = creaNodoRedEET("content_div",$1,"T_STRING",$2);}
	| content_div tag_a		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div tag_b		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div blockquote	{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div br		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div button		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div code		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div div		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div dl		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div em		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div form		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h1		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h2		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h3		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h4		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h5		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div h6		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div hr		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div img		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div input		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div object		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div ol		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div tag_p		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div pre		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div script		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div span		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div strong		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div table		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div textarea		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| content_div ul		{$$ = creaNodoRedEGG("content_div",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_div");}
	;

dl:abre_dl content_dl cierra_dl {$$ = creaNodoRedEGGG("dl",$1,$2,$3);};
abre_dl: T_TAG_OPEN T_TAG_DL atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_dl","T_TAG_DL",$2,$3,"T_TAG_CLOSE",$4);};
cierra_dl: T_TAG_CLOSE_OPEN T_TAG_DL T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_dl","T_TAG_DL",$2);};
content_dl: 
	dt			{$$ = creaNodoRedEG("content_dl",$1);}
	| dd			{$$ = creaNodoRedEG("content_dl",$1);}
	| content_dl dt		{$$ = creaNodoRedEGG("content_dl",$1,$2);}
	| content_dl dd		{$$ = creaNodoRedEGG("content_dl",$1,$2);}
	;

dd: abre_dd content_dd cierra_dd {$$ = creaNodoRedEGGG("dd",$1,$2,$3);};
abre_dd: T_TAG_OPEN T_TAG_DD atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_dd","T_TAG_DD",$2,$3,"T_TAG_CLOSE",$4);};
cierra_dd: T_TAG_CLOSE_OPEN T_TAG_DD T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_dd","T_TAG_DD",$2);};
content_dd: 
	content_dd T_STRING		{$$ = creaNodoRedEET("content_dd",$1,"T_STRING",$2);}
	| content_dd tag_a		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd tag_b		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd blockquote		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd br			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd button		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd code		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd div		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd em			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd form		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h1			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h2			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h3			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h4			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h5			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd h6			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd hr			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd img		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd input		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd object		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd ol			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd tag_p		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd pre		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd script		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd span		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd strong		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd table		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd textarea		{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| content_dd ul			{$$ = creaNodoRedEGG("content_dd",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_dd");}
	;

dt: abre_dt content_dt cierra_dt {$$ = creaNodoRedEGGG("dt",$1,$2,$3);};
abre_dt: T_TAG_OPEN T_TAG_DT atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_dt","T_TAG_DT",$2,$3,"T_TAG_CLOSE",$4);};
cierra_dt: T_TAG_CLOSE_OPEN T_TAG_DT T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_dt","T_TAG_DT",$2);};
content_dt: 
	content_dt T_STRING		{$$ = creaNodoRedEET("content_dt",$1,"T_STRING",$2);}
	| content_dt tag_a		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt tag_b		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt blockquote		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt br			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt button		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt code		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt div		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt em			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt form		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h1			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h2			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h3			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h4			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h5			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt h6			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt hr			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt img		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt input		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt object		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt ol			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt tag_p		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt pre		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt script		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt span		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt strong		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt table		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt textarea		{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| content_dt ul			{$$ = creaNodoRedEGG("content_dt",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_dt");}
	;

em :abre_em content_em cierra_em {$$ = creaNodoRedEGGG("em",$1,$2,$3);};
abre_em: T_TAG_OPEN T_TAG_EM atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_em","T_TAG_EM",$2,$3,"T_TAG_CLOSE",$4);};
cierra_em: T_TAG_CLOSE_OPEN T_TAG_EM T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_em","T_TAG_EM",$2);};
content_em: 
	content_em T_STRING	{$$ = creaNodoRedEET("content_em",$1,"T_STRING",$2);}
	| content_em tag_a	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em tag_b	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em br		{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em button	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em code	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em em		{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em img	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em input	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em object	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em script	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em span	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em strong	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| content_em textarea	{$$ = creaNodoRedEGG("content_em",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_em");}
	;

form: abre_form content_form cierra_form {$$ = creaNodoRedEGGG("form",$1,$2,$3);};
abre_form: T_TAG_OPEN T_TAG_FORM atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_form","T_TAG_FORM",$2,$3,"T_TAG_CLOSE",$4);};
cierra_form: T_TAG_CLOSE_OPEN T_TAG_FORM T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_form","T_TAG_FORM",$2);};
content_form: 
	content_form tag_a		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form tag_b		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form blockquote	{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form br		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form button		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form code		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form div		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form dl		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form em		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form form		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h1		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h2		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h3		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h4		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h5		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form h6		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form hr		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form img		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form input		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form object		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form ol		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form tag_p		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form pre		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form script		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form span		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form strong		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form table		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form textarea		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| content_form ul		{$$ = creaNodoRedEGG("content_form",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_form");}
	;

h1:abre_h1 content_h1_h6 cierra_h1 {$$ = creaNodoRedEGGG("h1",$1,$2,$3);};
abre_h1: T_TAG_OPEN T_TAG_H1 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h1","T_TAG_H1",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h1: T_TAG_CLOSE_OPEN T_TAG_H1 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h1","T_TAG_H1",$2);};
	
h2:abre_h2 content_h1_h6 cierra_h2 {$$ = creaNodoRedEGGG("h2",$1,$2,$3);};
abre_h2: T_TAG_OPEN T_TAG_H2 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h2","T_TAG_H2",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h2: T_TAG_CLOSE_OPEN T_TAG_H2 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h2","T_TAG_H2",$2);};

h3:abre_h3 content_h1_h6 cierra_h3 {$$ = creaNodoRedEGGG("h3",$1,$2,$3);};
abre_h3: T_TAG_OPEN T_TAG_H3 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h3","T_TAG_H3",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h3: T_TAG_CLOSE_OPEN T_TAG_H3 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h3","T_TAG_H3",$2);};

h4:abre_h4 content_h1_h6 cierra_h4 {$$ = creaNodoRedEGGG("h4",$1,$2,$3);};
abre_h4: T_TAG_OPEN T_TAG_H4 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h4","T_TAG_H4",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h4: T_TAG_CLOSE_OPEN T_TAG_H4 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h4","T_TAG_H4",$2);};

h5:abre_h5 content_h1_h6 cierra_h5 {$$ = creaNodoRedEGGG("h5",$1,$2,$3);};
abre_h5: T_TAG_OPEN T_TAG_H5 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h5","T_TAG_H5",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h5: T_TAG_CLOSE_OPEN T_TAG_H5 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h5","T_TAG_H5",$2);};

h6:abre_h6 content_h1_h6 cierra_h6 {$$ = creaNodoRedEGGG("h6",$1,$2,$3);};
abre_h6: T_TAG_OPEN T_TAG_H6 atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_h6","T_TAG_H6",$2,$3,"T_TAG_CLOSE",$4);};
cierra_h6: T_TAG_CLOSE_OPEN T_TAG_H6 T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_h6","T_TAG_H6",$2);};

content_h1_h6:
	content_h1_h6 T_STRING		{$$ = creaNodoRedEET("content_h1_h6",$1,"T_STRING",$2);}
	| content_h1_h6 tag_a		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 tag_b		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 br		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 button		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 code		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 em		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 img		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 input		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 object		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 script		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 span		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 strong		{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| content_h1_h6 textarea	{$$ = creaNodoRedEGG("content_h1_h6",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_h1_h6");}
	;

hr: T_TAG_OPEN T_TAG_HR atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("hr","T_TAG_HR",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};

img: T_TAG_OPEN T_TAG_IMG atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("img","T_TAG_IMG",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};

input: T_TAG_OPEN T_TAG_INPUT atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("input","T_TAG_INPUT",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};

li: abre_li content_li cierra_li {$$ = creaNodoRedEGGG("li",$1,$2,$3);};
abre_li: T_TAG_OPEN T_TAG_LI atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_li","T_TAG_LI",$2,$3,"T_TAG_CLOSE",$4);};
cierra_li: T_TAG_CLOSE_OPEN T_TAG_LI T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_li","T_TAG_LI",$2);};
content_li: 
	content_li T_STRING	{$$ = creaNodoRedEET("content_li",$1,"T_STRING",$2);}
	| content_li tag_a	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li tag_b	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li br		{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li button	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li code	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li em		{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li img	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li input	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li object	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li tag_p	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li script	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li span	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li strong	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| content_li textarea	{$$ = creaNodoRedEGG("content_li",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_li");}
	;

link: T_TAG_OPEN T_TAG_LINK atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("link","T_TAG_LINK",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};

meta: T_TAG_OPEN T_TAG_META atributos T_TAG_CLOSE_CLOSE {$$ = creaNodoRedAbre("meta","T_TAG_META",$2,$3,"T_TAG_CLOSE_CLOSE",$4);};

object: abre_object content_object cierra_object {$$ = creaNodoRedEGGG("object",$1,$2,$3);};
abre_object: T_TAG_OPEN T_TAG_OBJECT atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_object","T_TAG_OBJECT",$2,$3,"T_TAG_CLOSE",$4);};
cierra_object: T_TAG_CLOSE_OPEN T_TAG_OBJECT T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_object","T_TAG_OBJECT",$2);};
content_object: 
	content_object T_STRING		{$$ = creaNodoRedEET("content_object",$1,"T_STRING",$2);}
	| content_object tag_a		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object tag_b		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object dl		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object em		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object form		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h1		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h2		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h3		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h4		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h5		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object h6		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object hr		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object img		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object input		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object object		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object ol		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object tag_p		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object pre		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object script		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object span		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object strong		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object table		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object textarea	{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| content_object ul		{$$ = creaNodoRedEGG("content_object",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_object");}
	;

ol: abre_ol content_ol cierra_ol {$$ = creaNodoRedEGGG("ol",$1,$2,$3);};
abre_ol: T_TAG_OPEN T_TAG_OL atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_ol","T_TAG_OL",$2,$3,"T_TAG_CLOSE",$4);};
cierra_ol: T_TAG_CLOSE_OPEN T_TAG_OL T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_ol","T_TAG_OL",$2);};
content_ol: 
	li		{$$ = creaNodoRedEG("content_ol",$1);}
	| content_ol li	{$$ = creaNodoRedEGG("content_ol",$1,$2);}
	;

tag_p: abre_p content_p cierra_p {$$ = creaNodoRedEGGG("tag_p",$1,$2,$3);};
abre_p: T_TAG_OPEN T_TAG_P atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_p","T_TAG_P",$2,$3,"T_TAG_CLOSE",$4);};
cierra_p: T_TAG_CLOSE_OPEN T_TAG_P T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_p","T_TAG_P",$2);};
content_p: 
	content_p T_STRING	{$$ = creaNodoRedEET("content_p",$1,"T_STRING",$2);}
	| content_p tag_a	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p tag_b	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p br		{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p button	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p code	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p em		{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p img		{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p input	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p object	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p script	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p span	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p strong	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| content_p textarea	{$$ = creaNodoRedEGG("content_p",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_p");}
	;

pre: abre_pre content_pre cierra_pre {$$ = creaNodoRedEGGG("pre",$1,$2,$3);};
abre_pre: T_TAG_OPEN T_TAG_PRE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_pre","T_TAG_PRE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_pre: T_TAG_CLOSE_OPEN T_TAG_PRE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_pre","T_TAG_PRE",$2);};
content_pre: 
	content_pre T_STRING	{$$ = creaNodoRedEET("content_pre",$1,"T_STRING",$2);}
	| content_pre tag_a		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre tag_b		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre br		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre button		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre code		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre em		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre img		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre input		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre object		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre script		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre span		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre strong		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| content_pre textarea		{$$ = creaNodoRedEGG("content_pre",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_pre");}
	;

script: abre_script content_script cierra_script {$$ = creaNodoRedEGGG("script",$1,$2,$3);}; 
abre_script: T_TAG_OPEN T_TAG_SCRIPT atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_script","T_TAG_SCRIPT",$2,$3,"T_TAG_CLOSE",$4);}; 
cierra_script: T_TAG_CLOSE_OPEN T_TAG_SCRIPT T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_script","T_TAG_SCRIPT",$2);}; 
content_script: 
	T_STRING content_script 	{$$ = creaNodoRedETE("content_script","T_STRING",$1,$2);}
	| T_TAG_CLOSE content_script	{$$ = creaNodoRedETE("content_script","T_TAG_CLOSE",$1,$2);}
	| T_TAG_OPEN content_script 	{$$ = creaNodoRedETE("content_script","T_TAG_OPEN",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_script");}
	;

span: abre_span content_span cierra_span {$$ = creaNodoRedEGGG("span",$1,$2,$3);};
abre_span: T_TAG_OPEN T_TAG_SPAN atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_span","T_TAG_SPAN",$2,$3,"T_TAG_CLOSE",$4);};
cierra_span: T_TAG_CLOSE_OPEN T_TAG_SPAN T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_span","T_TAG_SPAN",$2);};
content_span: 
	content_span T_STRING	{$$ = creaNodoRedEET("content_span",$1,"T_STRING",$2);}
	| content_span tag_a		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span tag_b		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span br		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span button		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span em		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span img		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span input		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span object		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span script		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span span		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span strong		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| content_span textarea		{$$ = creaNodoRedEGG("content_span",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_span");}
	;

strong: abre_strong content_strong cierra_strong {$$ = creaNodoRedEGGG("strong",$1,$2,$3);};
abre_strong: T_TAG_OPEN T_TAG_STRONG atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_strong","T_TAG_STRONG",$2,$3,"T_TAG_CLOSE",$4);};
cierra_strong: T_TAG_CLOSE_OPEN T_TAG_STRONG T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_strong","T_TAG_STRONG",$2);};
content_strong: 
	content_strong T_STRING	{$$ = creaNodoRedEET("content_strong",$1,"T_STRING",$2);}
	| content_strong tag_a		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong tag_b		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong br		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong button		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong code		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong em		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong img		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong input		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong object		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong script		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong span		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong strong		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong style		{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| content_strong textarea	{$$ = creaNodoRedEGG("content_strong",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_strong");}
	;

style: abre_style content_style cierra_style {$$ = creaNodoRedEGGG("style",$1,$2,$3);};
abre_style: T_TAG_OPEN T_TAG_STYLE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_style","T_TAG_STYLE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_style: T_TAG_CLOSE_OPEN T_TAG_STYLE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_style","T_TAG_STYLE",$2);};
content_style: 
	T_STRING content_style	{$$ = creaNodoRedETE("content_style","T_STRING",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_style");}
	;

table: abre_table content_table cierra_table {$$ = creaNodoRedEGGG("table",$1,$2,$3);};
abre_table: T_TAG_OPEN T_TAG_TABLE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_table","T_TAG_TABLE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_table: T_TAG_CLOSE_OPEN T_TAG_TABLE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_table","T_TAG_TABLE",$2);};
content_table: 
	tr content_table3	{$$ = creaNodoRedEGG("content_table",$1,$2);}
	| content_table2	{$$ = creaNodoRedEG("content_table",$1);}
	;
content_table2:
	caption tr		{$$ = creaNodoRedEGG("content_table2",$1,$2);}
	| content_table2 tr	{$$ = creaNodoRedEGG("content_table2",$1,$2);}
	;
content_table3:
	tr content_table3	{$$ = creaNodoRedEGG("content_table3",$1,$2);}
	|	{$$ = creaNodoRedVacia("content_table3");}
	;
	
td: abre_td content_td cierra_td {$$ = creaNodoRedEGGG("td",$1,$2,$3);};
abre_td: T_TAG_OPEN T_TAG_TD atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_td","T_TAG_TD",$2,$3,"T_TAG_CLOSE",$4);};
cierra_td: T_TAG_CLOSE_OPEN T_TAG_TD T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_td","T_TAG_TD",$2);};
content_td: 
	content_td T_STRING	{$$ = creaNodoRedEET("content_td",$1,"T_STRING",$2);}
	| content_td tag_a	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td tag_b	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td blockquote	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td br		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td button	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td code	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td div	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td dl		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td em		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td form	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h1		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h2		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h3		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h4		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h5		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td h6		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td hr		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td img	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td input	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td object	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td ol		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td tag_p	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td pre	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td script	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td span	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td strong	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td table	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td textarea	{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| content_td ul		{$$ = creaNodoRedEGG("content_td",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_td");}
	;

th: abre_th content_th cierra_th {$$ = creaNodoRedEGGG("th",$1,$2,$3);};
abre_th: T_TAG_OPEN T_TAG_TH atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_th","T_TAG_TH",$2,$3,"T_TAG_CLOSE",$4);};
cierra_th: T_TAG_CLOSE_OPEN T_TAG_TH T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_th","T_TAG_TH",$2);};
content_th: 
	content_th T_STRING	{$$ = creaNodoRedEET("content_th",$1,"T_STRING",$2);}
	| content_th tag_a	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th tag_b	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th blockquote	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th br		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th button	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th code	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th div	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th dl		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th em		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th form	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h1		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h2		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h3		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h4		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h5		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th h6		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th hr		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th img	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th input	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th object	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th ol		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th tag_p	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th pre	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th script	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th span	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th strong	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th table	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th textarea	{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| content_th ul		{$$ = creaNodoRedEGG("content_th",$1,$2);}
	| 	{$$ = creaNodoRedVacia("content_th");}
	;

tr: abre_tr content_tr cierra_tr {$$ = creaNodoRedEGGG("tr",$1,$2,$3);};
abre_tr: T_TAG_OPEN T_TAG_TR atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_tr","T_TAG_TR",$2,$3,"T_TAG_CLOSE",$4);};
cierra_tr: T_TAG_CLOSE_OPEN T_TAG_TR T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_tr","T_TAG_TR",$2);};
content_tr: 
	td			{$$ = creaNodoRedEG("content_tr",$1);}
	| th			{$$ = creaNodoRedEG("content_tr",$1);}
	| content_tr td		{$$ = creaNodoRedEGG("content_tr",$1,$2);}
	| content_tr th		{$$ = creaNodoRedEGG("content_tr",$1,$2);}
	;

textarea: abre_textarea content_textarea cierra_textarea {$$ = creaNodoRedEGGG("textarea",$1,$2,$3);};
abre_textarea: T_TAG_OPEN T_TAG_TEXTAREA atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_textarea","T_TAG_TEXTAREA",$2,$3,"T_TAG_CLOSE",$4);};
cierra_textarea: T_TAG_CLOSE_OPEN T_TAG_TEXTAREA T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_textarea","T_TAG_TEXTAREA",$2);};
content_textarea: 
	content_textarea T_STRING	{$$ = creaNodoRedEET("content_textarea",$1,"T_STRING",$2);}
	| 	{$$ = creaNodoRedVacia("content_textarea");}
	;

title: abre_title content_title cierra_title 	{$$ = creaNodoRedEGGG("title",$1,$2,$3);};
abre_title: T_TAG_OPEN T_TAG_TITLE atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_title","T_TAG_TITLE",$2,$3,"T_TAG_CLOSE",$4);};
cierra_title: T_TAG_CLOSE_OPEN T_TAG_TITLE T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_title","T_TAG_TITLE",$2);};
content_title: 
	content_title T_STRING	{$$ = creaNodoRedEET("content_title",$1,"T_STRING",$2);}
	| 	{$$ = creaNodoRedVacia("content_title");}
	;

ul: abre_ul content_ul cierra_ul	 {$$ = creaNodoRedEGGG("ul",$1,$2,$3);};
abre_ul: T_TAG_OPEN T_TAG_UL atributos T_TAG_CLOSE {$$ = creaNodoRedAbre("abre_ul","T_TAG_UL",$2,$3,"T_TAG_CLOSE",$4);};
cierra_ul: T_TAG_CLOSE_OPEN T_TAG_UL T_TAG_CLOSE {$$ = creaNodoRedCierra("cierra_ul","T_TAG_UL",$2);};
content_ul: 
	li			{$$ = creaNodoRedEG("content_ul",$1);}
	| content_ul li		{$$ = creaNodoRedEGG("content_ul",$1,$2);}
	;

atributos: 
	atributos2		{$$ = creaNodoRedEG("atributos",$1);}
	|			{$$ = creaNodoRedE("atributos");}
	;
atributos2:
	atributo		{$$ = creaNodoRedEG("atributos2",$1);}
	| atributo atributos2	{$$ = creaNodoRedEGG("atributos2",$1,$2);}
	;
atributo: T_ATR T_IGUAL T_COMILLA value T_COMILLA {$$ = creaNodoRedAtr($1,$4);};

value: 
	T_VALUE			{$$ = creaNodoRedET("value","T_VALUE",$1);}
	| value T_VALUE		{$$ = creaNodoRedEET("value",$1,"T_VALUE",$2);}
	;

%%
//Se reescribe yyerror para que imprima mensajes mas completos de error 
//indicando la linea y la columna
void yyerror (char const *s)
     {
       fprintf (stderr, "Line: %d, col: %d %s\n", getLine_inicial(),getCol_inicial (), s);
     }

//Funcion principal llama a yyparse
int main() {
 //yydebug = 1;
 return yyparse();
}
