#ifndef TREE_H
    #define TREE_H
	#include <string.h>
 	/*Estructura de arbol que va a ser utilizada para construir el parse tree
	posee un char* que almacena el nombre del nodo y una estructura lista
	con una lista de sus nodos hijos*/
	typedef struct nodo{
		char *str;
		struct lista *hijos;
	} nodo;
	/*Estructura lista, de la forma nodo,lista donde nodo es el nodo en esta 	posicion de la lista y lista es la siguiente posicion */
	typedef struct lista{
		nodo *node;
		struct lista *siguiente;
	}lista;
	
	/*Algoritmo que crea un nodo nuevo, solicita a la memoria el espacio para 		el nodo y para el arreglo de caracteres de su nombre, retorna el nodo*/
	nodo *creaNodo (char *valor){
		nodo *rama = (nodo*) malloc(sizeof(nodo));
		rama->str = (char *)malloc(strlen(valor)+1);
		strcpy(rama->str,valor);
		rama->hijos = NULL;
		return rama; 
	}

	/*Agrega un hijo a la lista de hijos del padre, recibe el nodo padre y el 		nodo hijo. Crea una estructura de tipo lista para el nodo hijo y lo agrega 		en la ultima posicion a la estructura de hijos del padre*/
	void agregaHijo(nodo *padre,nodo *hijo){
		lista *hermano = (lista*) malloc(sizeof(lista));
		hermano->node = hijo;
		hermano->siguiente == NULL;
		if(padre->hijos==NULL){
			padre->hijos = hermano;
		}
		else{
			lista *aux = padre->hijos;
			while(aux->siguiente!=NULL){
				aux = aux->siguiente;
			}
			aux->siguiente = hermano;
		}
	
	}

	/*Algoritmo que imprime un arbol, donde va identando segun el nivel de 		cada nodo, a partir de un nodo padre. Imprime a un nodo y luego 	    		recursivamente imprime sus hijos (imprime todos los hijos de cada nodo antes de imprimir sus hermanos, de manera recursiva)*/
	void imprimeNodos(nodo *padre,int nivel){
		#define espacio 1
		if(nivel != 0){
			imprimeLinea(nivel);
		}
		printf("%s\n",padre->str);
		if(!padre->hijos==NULL){
			lista *aux = padre->hijos;
			imprimeNodos(aux->node,nivel+espacio);
			while(aux->siguiente!=NULL){
				aux = aux->siguiente;
				imprimeNodos(aux->node,nivel+espacio);
			}
		}
	}

	//Imprime el simbolo "|" tantas cantidades de veces equivalente a la profundidad del nodo que imprime actualmente
	//funciona como guia para entender mejor el arbol
	void imprimeLinea(nivel){
		int x = 0;
		while(x<=nivel){
			if(x == 0){
				printf("|");
			}
			else if(x == nivel){
				printf("--");
			}
			else{
				printf("%*c|",2,' ');
			}
			x+=1;
		}
	}

	/*Crea el arbol para los token, el arbol es de la forma TOKEN->valor
	 del token*/
	nodo *creaNodoToken(char *token,char *val){
		nodo* padre = creaNodo(token);
		nodo* hijo = creaNodo(val);
		agregaHijo(padre,hijo);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->T con E no terminal
	 y T terminal. El arbol tiene la forma E->TOKEN->valor del token*/
	nodo *creaNodoRedET(char *prod,char *token,char *tira){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodoToken(token,tira);
		agregaHijo(padre,hijo);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->ET con E no terminal
	 y T terminal. El arbol tiene la forma E->(E TOKEN) donde E y TOKEN
	 tienen su arbol respectivo*/
	nodo *creaNodoRedEET(char *prod,nodo *arbol,char *token,char *tira){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodoToken(token,tira);
		agregaHijo(padre,arbol);
		agregaHijo(padre,hijo);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->TE con E no terminal
	 y T terminal. El arbol tiene la forma E->(TOKEN E) donde E y TOKEN
	 tienen su arbol respectivo*/
	nodo *creaNodoRedETE(char *prod,char *token,char *tira,nodo *arbol){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodoToken(token,tira);
		agregaHijo(padre,hijo);
		agregaHijo(padre,arbol);
		return padre;
	}

	/*Crea la parte del arbol para la reduccion atributo cuyo caso es
	 particular. El arbol tiene la forma E->(T T T G T) donde E es la 
	 produccion atributo, T representa algun token en particular y G
	 la produccion value, donde cada uno tienee su arbol respectivo*/
	nodo *creaNodoRedAtr(char *atrb,nodo *val){
		nodo* padre = creaNodo("atributo");
		nodo* atr = creaNodoToken("T_ATR",atrb);
		nodo* igual = creaNodoToken("T_IGUAL","=");
		nodo* comilla1 = creaNodoToken("T_COMILLA","\"");
		nodo* comilla2 = creaNodoToken("T_COMILLA","\"");
		agregaHijo(padre,atr);
		agregaHijo(padre,igual);
		agregaHijo(padre,comilla1);
		agregaHijo(padre,val);
		agregaHijo(padre,comilla2);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->GG 
	 con E no terminal y G otro no terminal donde los G pueden ser
	 diferentes entre ellos, iguales o iguales a E. El arbol tiene la 
	 forma E->(G G) donde cada G tiene su arbol respectivo*/
	nodo *creaNodoRedEGG(char *prod,nodo *hijo,nodo *hijo1){
		nodo* padre = creaNodo(prod);
		agregaHijo(padre,hijo);
		agregaHijo(padre,hijo1);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->G con E no terminal
	 y G otro no terminal. El arbol tiene la forma E->G donde G
	 tiene su arbol respectivo*/
	nodo *creaNodoRedEG(char *prod,nodo *hijo){
		nodo* padre = creaNodo(prod);
		agregaHijo(padre,hijo);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->vacio con E no 
	 terminal. El arbol tiene la forma E->vacio */
	nodo *creaNodoRedE(char *prod){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodo("");
		agregaHijo(padre,hijo);
		return padre;
	}

	/*Crea la parte del arbol para la reduccion de tipo cierra cuyo caso es
	 particular. El arbol tiene la forma E->(T T T) donde T representa 
	 algun token en particular donde cada uno tiene su arbol respectivo*/
	nodo *creaNodoRedCierra(char *prod,char *token,char *val){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodoToken("T_TAG_CLOSE_OPEN","</");
		nodo* hijo1 = creaNodoToken(token,val);
		nodo* hijo2 = creaNodoToken("T_TAG_CLOSE",">");
		agregaHijo(padre,hijo);
		agregaHijo(padre,hijo1);
		agregaHijo(padre,hijo2);
		return padre;
	}

	/*Crea la parte del arbol para la reduccion de tipo abre cuyo caso es
	 particular. El arbol tiene la forma E->(T T A T3) donde T representa 
	 algun token en particular y A los atributos donde cada uno tiene su 
	 arbol respectivo, el T3 puede ser > o /> */
	nodo *creaNodoRedAbre(char *prod,char *token,char *val,nodo *hijo2,char *cierre,char *valCierre){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodoToken("T_TAG_OPEN","<");
		nodo* hijo1 = creaNodoToken(token,val);
		nodo* hijo3 = creaNodoToken(cierre,valCierre);
		agregaHijo(padre,hijo);
		agregaHijo(padre,hijo1);
		agregaHijo(padre,hijo2);
		agregaHijo(padre,hijo3);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->GGG 
	 con E no terminal y G otros no terminales. El arbol tiene la forma 
	 E->(G G G) cada G tiene su arbol respectivo*/
	nodo *creaNodoRedEGGG(char *prod,nodo *hijo,nodo *hijo1,nodo *hijo2){
		nodo* padre = creaNodo(prod);
		agregaHijo(padre,hijo);
		agregaHijo(padre,hijo1);
		agregaHijo(padre,hijo2);
		return padre;
	}

	/*Crea la parte del arbol para reducciones de tipo E->vacio 
	 El arbol tiene la forma E->() */
	nodo *creaNodoRedVacia(char *prod){
		nodo* padre = creaNodo(prod);
		nodo* hijo = creaNodo("");
		agregaHijo(padre,hijo);
		return padre;
	}
#endif
