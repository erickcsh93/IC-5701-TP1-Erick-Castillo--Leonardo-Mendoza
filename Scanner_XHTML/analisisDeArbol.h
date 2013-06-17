/*

A continuación una lista de los elementos que se encuentran y son llamados por el parcer para el análisis del arbol. 

1- Todos lo argumentos, y atributos que deben ser revisados. 
2- El contexto en el que se espera que se encuentren estos
3- Las funciones para recorrer el árbol y extrae los nodos que contienen la información que debe ser revisada
4-Las funciones que revisan los argumentos y atributos según los contextos definidos.
5-Casos especiales que deben ser revisados con métodos diferentes como los lenguajes o los urls



Una vez que se a finalizado la construcción del árbol es llamada la función que se encarga de imprimirlo. Y luego se utilizan los elementos de este modulo para analizarlo semánticamente. Semejante a como se ilustra en el siguiente algoritmo.


AnálisisDeArbol (Arbol){

     For ( Nodo in Arbol){
             if (Nodo contiene etiqueta revisable){
	         for (Atributo in Nodo){	
	               RevisaValidesDeAtributo();
		    if (Existen errores) imprima Error;			
	               for (Argumentos in Atributo){	
	                         RevisaValidesdeArgumento();
			  if (Existen errores) imprima Error;
                           }
                    }
            }
            AnálisisDeArbol(Nodo)
     }
}

Por lo tanto todo el arbol es recorrido recursivamente y se revisan todos los casos necesarios para probar que el archivo de tipo xhtml tenga valides semantica.

*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>


/*
ModoImpre = 0 
	El modo que solo imprime las lineas de errores con posición, para fines de la presentación

ModoImpre = 1
	Modo que imprime todos los analizas realizados, para fines de desarrollo 
*/
int ModoImpre = 0; 





/*
Función de soporte usada en diferentes puntos del código para recorrer y analizar el árbol 
*/
char* substring(const char* str, size_t begin, size_t len)
{
  if (str == 0 || strlen(str) == 0 || strlen(str) < begin || strlen(str) < (begin+len))
    return 0;

  return strndup(str + begin, len);
}





/*
Matriz de todas las posibles etiquetas con sus posibles atributos que es utilizada por los algoritmos de revisión de atributos para verificar la valides de esto según el contexto,

 esta matriz  se distribuye de la siguiente forma:

---------------------------------------------------------------------
|Etiqueta1|  PosibleAtributo1 | PosibleAtributo2 | PosibleAtributoN |
|Etiqueta2|  PosibleAtributo1 | PosibleAtributo2 | PosibleAtributoN |
|  ....   |  ....						    | 		
|EtiquetaN|  PosibleAtributo1 | PosibleAtributo2 | PosibleAtributoN |
---------------------------------------------------------------------
Por lo tanto la primera columna contiene todas las etiquetas que son revisadas, y el las siguientes columnas contienen los atributos permitidos
*/


char *Atributos[100][100] = {
	{"html", "xmlns","xml:lang","lang"},	
        {"a", 	 "href"},
        {"b",		 	},
        {"blockquote",	 "cite"},
	{"body", 	 },
	{"br", 		 },
	{"button",	 "autofocus", "disablee", "form", "formaction", "formenctype", "formmethod", "formnovalidate", 				 "formtarget", "name", "type", "value"},
	{"captation",	 "align"},
	{"dl",	 },
	{"dt",	 }	,
	{"del", 	   	 "cite" , "datetime" },
	{"embed",	 "height", "src", "type", "width" },
	{"form", 	  "accept-charset", "action", "autocomplete", "enctype", "method", "name", "novalid", "target"},
	{"pre", 	 "widht"},
	{"h1", 		 "align"},
	{"h2", 		 "align"},
	{"h3", 		 "align"},
	{"h4", 		 "align"},
	{"h5", 		 "align"},
	{"h6", 		 "align"},
	{"table",        "align", "bgcolor", "border", "cellpadding", "cellspacing", "frame", "rules", "summary", "width"},
	{"head", 	 "profile"},
	{"img",		 "align", "alt", "border", "crossorigin", "height", "hspace", "ismap", "longdesc", "src", "usemap", "vspace", "width"},
	{"input", 	 "input", "align", "alt", "autocomplete", "autofocus", "checked", "disable", "form", "formaction", "formenctype", 				 "formnovalidate", "formtarget", "height", "list", "max", "maxlenght", "min" , "multiple", "name", "pattern", 				 "placeholder", "readonly", "required", "size", "src", "step", "type", "value", "width"},
	{"li"	,	 "type", "value"},
	{"link",		 "charset", "href", "hreflang", "media", "rel", "rev", "sizes", "target", "type"},
	{"meta", 	 "charset", "content", "httpequiv", "name", "scheme"},
	{"hr", 	 	 "align", "noshade", "size", "width"},
	{"ol", 		 "compact", "reversed", "start", "type"},
	{"option"	 "disable", "label", "selected", "value"},
	{"title"},
	{"p"		 ,"align"},
	{"ul"		 ,"compact" , "type"},
	{"code"		 },
	{"div"      	 ,"align"},
	{"textarea"	 ,"autofocus", "cols", "disable", "form", "maxlength", "name", "placeholder", "readonly", "required", "rows", "wrap"},
	{"option"  	 ,"disable", "label", "selected", "value"},
	{"head"		, "profile"} 
    };


/*
Listas de atributos globales y atributos de eventos, validos en las etiquetas revisadas
*/

char *AtributosGlobales[500] = {"accesskey", "class", "contenteditable", "contextmenu", "dir", "draggable", "dropzone", "hidden", "id", "lang", "spellcheck", "style", "tabindex", "title", "translate"};

char *AtributosEventosDeVentana[500] = {"onafterprint", "onbeforeprint", "onbeforeunload", "onerror", "onhaschange", "onload", "onmessage", "onoffline", "ononline", "onpagehide", "onpageshow", "onpopstate", "onredo", "onresize", "onstorage" ,"onundo","onunload"};

char *AtributosEventosDeFormulario[500] = {"onblur", "onchange", "oncontextmenu", "onfocus", "onformchange", "oninput", "oninvalid", "onselect", "onsubmit"};

char *AtributosEventosDeTeclado[500] = {"onkeydown", "onkeypress", "onkeyup"};

char *AtributosEventosDeRaton[500] = {"onclick", "ondblclick", "ondrag", "ondragend", "ondragenter", "ondragleave", "ondragover", "ondragstart", "ondrop", "onmousedown", "onmousemove", "onmouseout", "onmouseover", "onmouseup", "onmousewheel" ,"onscroll"};

char *AtributosEventosDeMedia[500] = {"onabort", "oncanplay", "oncanplaythrough", "ondurationchange", "onemptied", "onended", "onerror", "onloadeddata", "onloadedmetadata", "onloadstart", "onpause", "onplay", "onplaying", "onprogress", "onratechange" ,"onreadystatechange","onseeked", "onseeking", "onstalled", "onsuspend", "onvolumechange", "onwaiting"};


/*
VALores invalidos en html5
*/
char *NoEnHTML5[100] = {"onreset", "longdesc", "scheme", "nowrap", "scope","hspace","bgcolor","rules","noshade","align"}; 

/*
Matriz de todas los posibles argumentos para cada atributo. Se distribuye de la siguiente forma
---------------------------------------------------------------------
---------------------------
|Atributo1|  PosibleArgumento1| PosibleArgumento2 | ... | PosibleArgumentoN |
|Atributo2|  PosibleArgumento1| PosibleArgumento2 | ... | PosibleArgumentoN |
|  ....   |  ....						    			         | 		
|AtributoN|  PosibleArgumento1| PosibleArgumento2 | ... | PosibleArgumentoN |
---------------------------------------------------------------------
---------------------------
Por lo tanto la primera columna contiene todos los posibles atributos, y las siguientes columnas contiene los argumentos validos para cada uno.

En esta matriz existen casos diferentes
1 Casos estáticos: 
Estos casos simplemente se busca que el argumento sea alguno de los textos específicos como el caso de formmethod se requiere que el texto sea o get o post

2 Casos de formato
En estos casos se busca cierto para el argumento, actualmente se soportan fechas, números, textos, lenguajes y urls, estos casos se representan con un reglón al inicio de casa posible argumento. 
*/

char *Valores[100][100] = {

		/// VALORES PARRA CIERTAS ETIQUETAS
	{"content",	"-texto"},
	{"xmlns", 	"-url"},
	{"xml:lang", 	"-lang"},
	{"lang",	"-lang"},
    	{"rows",	"-numero"},
    	{"wrap",	"hard", "soft"},
       	{"maxlength",   "-numero"},
    	{"cols",	"-numero"},
    	{"selected", 	"selected"},
    	{"label",	"-texto"},
    	{"reversed",	"reversed"},
    	{"compact",	"compact"},
	{"start",	"-numero"},
    	{"target",	"_blank", "_self", "_top", "_parent", "texto"}, ///////
	{"href",	"-url"},
        {"sizes",	"-sizes", "any"},
        {"rel",		"alternate", "archives", "author", "bookmark", "external", "first", "help", "icon", "last", "license", "next", 				"nofollow", "noreferrer", "pingback", "prefetch", "prev", "search", "sidebar", "stylesheet", "tag", "up"},
        {"media",	"and", "not", ",", "all", "aural", "braille", "handheld", "projection", "print", "screen", "tty", "tv"},///////
        {"hreflang",	"-texto"},
        {"charset",	"-texto"},
        {"required", 	"required"},   
	{"bgcolor",	"-texto"},
        {"readonly", 	"readonly"},
	{"httpequiv",  "content - type", "default - style","refresh"},
	{"http-equiv",  "-texto"},
        {"placeholder",	"-texto"},
        {"patter",	"-pattern"},
        {"name",	"-texto"},
        {"multiple",	"multiple"},
        {"min",		"-numero", "-fecha"},
        {"maxlenght",	"-numero"},
        {"max",		"-numero", "-fecha"},
        {"cite",	"-url"},
        {"autofocus",	"autofocus"},
        {"formaction",	"-url"},
        {"formenctype", "application/x-www-form-urlencoded", "multipart/form-data", "text/plain"},
        {"formmethod",	"get", "post"},
        {"formnovalidate", "formnovalidate"},
        {"formtarget", "_blank", "_self", "_top", "_parent", "texto"},
	{"value",	"-texto"},
        {"align",	"left", "right", "top", "middle", "botton"},
        {"datetime",	"-fecha"},
        {"height",	"-numero"},
        {"src",		"-url"},
        {"type",	"-texto"},
        {"width",	"-numero"},
        {"accept",	"-texto"},
        {"profile",	"-url"},
        {"alt",		"-texto"},
        {"border",	"-numero"},
        {"crossorigin",	 "anonymous", "use-credentials"},
        {"hspace",	"-numero"},
        {"ismap",	"ismap"},
        {"longdesc",	"-url"},
        {"usemap",	"-mapname"},
        {"vspace",	"-numero"},
        {"autocomplete",	"on", "off"},
        {"checked",	"checked"},
        {"disable",	"disable"},
        {"form",	"-textoL"},
        {"list",	"-texto"},


		/// VALORES PARA ETIQUETAS GLOBALES
		{"accesskey",	"-accesskey"},
		{"class",	"-texto"},
		{"contenteditable", "true", "false", "inherit"},
		{"contextmenu", "-texto"},
		{"dir", "ltr","rtl","auto"},
		{"draggable", "true", "false", "auto"},
		{"dropzone", "copy", "move", "link"},
		{"hidden", "hidden"},
		{"id", "-texto"},
		{"lang", "-lang"},
		{"spellcheck", "true", "false"},
		{"style", "-NOP"},
		{"tabindex", "-numero"},
		{"title", "-texto"},
		{"translate", "true", "false"},
		/// Valores para Etiquetas de evento
		{"onafterprint",                  "-NOP"},
		{"onbeforeprint",                  "-NOP"},
		{"onbeforeunload",                  "-NOP"},
		{"onerror",                  "-NOP"},
		{"onhaschange",                  "-NOP"},
		{"onload",                  "-NOP"},
		{"onmessage",                  "-NOP"},
		{"onoffline",                  "-NOP"},
		{"ononline",                  "-NOP"},
		{"onpagehide",                  "-NOP"},
		{"onpageshow",                  "-NOP"},
		{"onpopstate",                  "-NOP"},
		{"onredo",                  "-NOP"},
		{"onresize",                  "-NOP"},
		{"onstorage" ,                 "-NOP"},
		{"onundo", 			"-NOP"},
		{"onunload",                  "-NOP"},
		{"onblur",                  "-NOP"},
		{"onchange",                  "-NOP"},
		{"oncontextmenu",                  "-NOP"},
		{"onfocus",                  "-NOP"},
		{"onformchange",                  "-NOP"},
		{"oninput",                  "-NOP"},
		{"oninvalid",                  "-NOP"},
		{"onselect",                  "-NOP"},
		{"onsubmit",                  "-NOP"},
		{"onkeydown",                  "-NOP"},
		{"onkeypress",                  "-NOP"},
		{"onkeyup",                  "-NOP"},
		{"onclick",                  "-NOP"},
		{"ondblclick",                  "-NOP"},
		{"ondrag",                  "-NOP"},
		{"ondragend",                  "-NOP"},
		{"ondragenter",                  "-NOP"},
		{"ondragleave",                  "-NOP"},
		{"ondragover",                  "-NOP"},
		{"ondragstart",                  "-NOP"},
		{"ondrop",                  "-NOP"},
		{"onmousedown",                  "-NOP"},
		{"onmousemove",                  "-NOP"},
		{"onmouseout",                  "-NOP"},
		{"onmouseover",                  "-NOP"},
		{"onmouseup",                  "-NOP"},
		{"onmousewheel",                  "-NOP"},
		{"onscroll",                  "-NOP"},
		{"onabort",                  "-NOP"},
		{"oncanplay",                  "-NOP"},
		{"oncanplaythrough",                  "-NOP"},
		{"ondurationchange",                  "-NOP"},
		{"onemptied",                  "-NOP"},
		{"onended",                  "-NOP"},
		{"onerror",                  "-NOP"},
		{"onloadeddata",                  "-NOP"},
		{"onloadedmetadata",                  "-NOP"},
		{"onloadstart",                  "-NOP"},
		{"onpause",                  "-NOP"},
		{"onplay",                  "-NOP"},
		{"onplaying",                  "-NOP"},
		{"onprogress",                  "-NOP"},
		{"onratechange",                  "-NOP"},
		{"onreadystatechange",                  "-NOP"},
		{"onseeked",                  "-NOP"},
		{"onseeking",                  "-NOP"},
		{"onstalled",                  "-NOP"},
		{"onsuspend",                  "-NOP"},
		{"onvolumechange",                  "-NOP"},
		{"onwaiting"			 "-NOP"}


    };


/*
Lista de lenguajes según el ISO LENGUAJE CODE 
*/
char *lenguajes[500] = {"ab","aa","af","sq","am","ar","an","hy","as","az","ba","eu","bn","dz","bh","bi","br","bg","my","be","km","ca","zh","zh","co","hr","cs","da","nl","en","eo","et","fo","fa","fj","fi","fr","fy","gl","gd","gv","ka","de","el","kl","gn","gu","ht","ha","he","iw","hi","hu","is","io","id","in","ia","ie","iu","ik","ga","it","ja","jv","kn","ks","kk","rw","ky","rn","ko","ku","lo","la","lv","li","ln","lt","mk","mg","ms","ml","","mt","mi","mr","mo","mn","na","ne","no","oc","or","om","ps","pl","pt","pa","qu","rm","ro","ru","sm","sg","sa","sr","sh","st","tn","sn","ii","sd","si","ss","sk","sl","so","es","su","sw","sv","tl","tg","ta","tt","te","th","bo","ti","to","ts","tr","tk","tw","ug","uk","ur","uz","vi","vo","wa","cy","wo","xh","yi","ji","yo","zu"}
;


/*
Recibe el nodo de un atributo, y analiza el árbol de este y acumula sus valores en la variable global tempGlobal para que después sean devueltos por la función getValor
*/
char tempGlobal[500];
void *getValor2 (nodo *padre){


	if (!padre->hijos == NULL){
		
		if ( strcmp (padre->hijos->node->str, "$url") ==0 ){
				strcat(tempGlobal, "-url ");
				return ;
				
			}

		if (strcmp (padre->str, "T_VALUE") ==0 ){
			//printf (padre->hijos->node->str);
			char* name_with_extension;
			
			
			strcat(tempGlobal, padre->hijos->node->str);
			strcat(tempGlobal, " ");
		}
	
		
	}

	if(!padre->hijos==NULL){
			lista *aux = padre->hijos;
			getValor2(aux->node);
			while(aux->siguiente!=NULL){
				aux = aux->siguiente;
				getValor2(aux->node);
			}
		}
}
/*
Recibe el nodo de un atributo y devuelve su argumento. Esta es una
Función de soporte y por medio de la cual es llamado GetValor2

*/
const char *getValor (nodo *padre) {


	memset(tempGlobal, 0, sizeof(tempGlobal));
	getValor2 (padre);
	
	return substring(tempGlobal,0,strlen(tempGlobal)-1);

}

/*
Recorre el arbol encontrando los nodos T_TAG_OPEN que es donde podrían o no encontrarse atributos y argumentos que deben ser revisados 
*/
void AnalisaAtributos(nodo *padre){
	//printf ("<<<<%s \n",padre->str);
	if (!padre->hijos == NULL){
		// En caso de que encuentre un tag abriéndose, procederá a revisar los atributos
		if (strcmp (padre->hijos->node->str, "T_TAG_OPEN") ==0 ){
			
				char *etiquieta = substring (padre->str, 5, strlen(padre->str)-5 ) ;
				if (ModoImpre)
				printf ("#%s\n", etiquieta);
				AnalisaAtributos2 (padre, etiquieta);
		}
		
		
	}

	if(!padre->hijos==NULL){
			lista *aux = padre->hijos;
			AnalisaAtributos(aux->node);
			while(aux->siguiente!=NULL){
				aux = aux->siguiente;
				AnalisaAtributos(aux->node);
			}
		}
}
/*
En la segunda parte de este algoritmo se reciben los nodo donde se encuentran los atributos y los argumentos y los extraerá, y llama a la revicion de estos
*/
void AnalisaAtributos2(nodo *padre, char *etiquieta){
		//printf ("%s %s")
		if (strcmp (padre->str, "atributo") ==0 ){

			nodo *atributo = padre->hijos->node->hijos->node;

			if (ModoImpre)
			printf("  <%s> ",atributo->str);
			VerificaAtributo (etiquieta, atributo,padre);
			
		
			if (ModoImpre)
			printf("= <%s> ",getValor(padre));				
			VerificaValor 	(atributo->str, padre);
			if (ModoImpre)
			printf("\n");}
			

		if(!padre->hijos==NULL){
			lista *aux = padre->hijos;
			AnalisaAtributos2(aux->node,etiquieta);
			while(aux->siguiente!=NULL){
				aux = aux->siguiente;
				AnalisaAtributos2(aux->node,etiquieta);
			}
		}

}
/*
Revisa  uno de los atributos de la etiqueta, para verificar que sea valido para esta. Si no lo es imprime un error con la posición de este.


*/
void VerificaAtributo (char *etiqueta, nodo *atributo,nodo *padre) {
	
	if (ValidoEnHTML5(atributo->str)){
			if (AtributoValido (etiqueta, atributo->str)){
					}
			else {
				if (ModoImpre)
				printf("(ErrorA)");
				else
				printf("Valor \"%s\" inesperado como atributo para \"%s\".  en fila: %d Columna:%d \n", atributo->str, etiqueta,padre->fil, padre->col );

			}
	}
	else {
	printf("Valor \"%s\" ya no es valido en html5. fila: %d Columna:%d  \n", atributo->str,padre->fil, padre->col );
	}
}

/*
El nodo valor, que contiene el atributo, y el argumento dado para este, es revisado para verificar la validez del argumento en el contexto. De otra forma imprime el error con la posición. 


*/

void VerificaValor (char *atributo, nodo *valor) {
	

	if (ValorValido (atributo, getValor(valor))){
	}
	else {
		if (ModoImpre)
		printf("(ErrorV)");
		else
		printf("Argumento \"%s\" inesperado como argumento para \"%s\".  en fila: %d Columna:%d \n", getValor(valor), atributo, valor->fil, valor->col  );
	
	}	

}
/*
Realiza la revisión de los posibles formas en las que un atributo puede ser valido para una Etiqueta
Incluye los siguientes 2 modos
1- Formas estáticas
2- Atributos Globales


*/

int AtributoValido (char *Etiqueta, char *Atributo){
	int x,y;
	y=0;


	//printf ("   <%s<  ",Atributo);
	for (x=0; Atributos[x][0]!= NULL; x++){
		//printf ("   <%s<   ",Atributos[x][0]);
		if (strcmp (Etiqueta,Atributos[x][0])==0){
			
			for (y=1; Atributos[x][y]!=NULL; y++){
				//printf ("(comp_ATR---<%s>,<%s>)  ", Atributo,Atributos[x][y] );
				if (strcmp(Atributo,Atributos[x][y])==0){
					return 1; 
				}
				
			
			}
		}
	}
	if (EsAtributoGlobal(Atributo)){
					return 1;

				}
	return 0;
}

/*
Realiza la revisión de los posibles formas en las que un argumento puede ser valido para un atributo
Incluye los siguientes 6 modos
1- Formas estáticas
2-Formas no soportadas por el programa
3-Para Atributos de lenguaje
4-Atributos que reciben números
5-Atributos que reciben una tecla
6-Atributos que reciben fechas

*/
int ValorValido (char *Atributo, char *Valor){

	int x,y;
	y=0;
	//printf ("-%s-<<<<",substring(Valor,0,strlen(Valor)-1));
	
	for (x=0; Valores[x][0]!= NULL; x++){
		if (strcmp (Atributo,Valores[x][0])==0){
			for (y=1; Valores[x][y]!=NULL; y++){
				
				
				if (strcmp(Valor,Valores[x][y])==0){
					return 1; 
				}

				else if (strcmp("-NOP",Valores[x][y])==0){
					return 1;
				}
				else if (strcmp("-lang",Valores[x][y])==0){			
					return lang_validate (Valor);
				}
		
				else if (strcmp("-numero",Valores[x][y])==0){			
					return number_validate (Valor);
				}
				else if (strcmp("-texto",Valores[x][y])==0){			
					return text_validate (Valor);
				}
			
				
				else if (strcmp("-accesskey",Valores[x][y])==0){			
					return accesskey_validate (Valor);
				}
				
				else if (strcmp("-fecha",Valores[x][y])==0){			
					return date_validate (Valor);
				}
			//	else if (strcmp("-MIME_type",Valores[x][y])==0){			
			//		return MIME_type_validate (Valor);
			//	}
			}
		}
	}
	return 0;
}



/*
Busca el nombre del atributo en los atributos de evento y globales que sirven para todas las etiquetas comprendidas
*/
int ValidoEnHTML5 (char *atributo){
	int x=0;
	for (x=0;NoEnHTML5[x]!=NULL;x++){
		if (strcmp (NoEnHTML5[x],atributo)==0){
			return 0;
		}
	}
	return 1;
}
int EsAtributoGlobal (char *atributo){
	int x=0;
	for (x=0;AtributosGlobales[x]!=NULL;x++){
		if (strcmp (AtributosGlobales[x],atributo)==0){
			return 1;
		}
	}
		for (;AtributosEventosDeVentana[x]!=NULL;x++){
		if (strcmp (AtributosEventosDeVentana[x],atributo)==0){
			return 1;
		}
	}
	for (x=0;AtributosEventosDeTeclado[x]!=NULL;x++){
		if (strcmp (AtributosEventosDeTeclado[x],atributo)==0){
			return 1;
		}
	}
	for (x=0;AtributosEventosDeRaton[x]!=NULL;x++){
		if (strcmp (AtributosEventosDeRaton[x],atributo)==0){
			return 1;
		}
	}
	for (x=0;AtributosEventosDeMedia[x]!=NULL;x++){
		if (strcmp (AtributosEventosDeMedia[x],atributo)==0){
			return 1;
		}
	}
		
	return 0; 

}
/*
Verifica que el valor del argumento sea alguno de las abreviaciones de lenguajes definidas en el ISO LENGUAJE CODE 
ver http://www.w3schools.com/tags/ref_language_codes.asp
*/
int lang_validate(const char *lang)
{	
	int x = 0; 
	for (;lenguajes[x]!=NULL;x++){
		if (strcmp (lenguajes[x], lang)==0){
			return 1; 
		}
	}	
	return 0;
}
/*
Verifica que el valor del argumento sea un numero
*/
int number_validate(const char *url)
{	
        static const char *nospecial=
                "0123456789^ ";

        while(*url)
        {
                if(strchr(nospecial, *url) == NULL) return(0);
                url++; 
        }

        return(1); 
}
/*
Verifica que el valor del argumento sea un texto conformado con los caracteres permitidos
*/
int text_validate(const char *url)
{	
        static const char *nospecial=
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-. :/?#[]@!$&'()*+,^;=";

        while(*url)
        {
                if(strchr(nospecial, *url) == NULL) return(0);
                url++; 
        }

        return(1); 
}

/*
Verifica que el valor del argumento tenga exclusivamente caracteres permitidos para definir una fecha
*/
int date_validate(const char *url)
{	
        static const char *nospecial=
                "TZ0123456789-: ";

        while(*url)
        {
                if(strchr(nospecial, *url) == NULL) return(0);
                url++; 
        }

        return(1); 
}


/*Verifica que el valor del argumento sea solo una tecla permitida*/
int accesskey_validate(const char *key)
{	
        if (strlen(key)==1) if( text_validate(key))return 1;return 0;
}


