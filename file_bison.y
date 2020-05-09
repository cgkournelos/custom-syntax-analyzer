
%{
#include <stdio.h>
#include <math.h>
extern void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;
extern num_line;
extern for_line;


%}

%locations
%token TK_INT
%token TK_STRING
%token TK_TRUE 
%token TK_FALSE 
%token TK_RET
%token TK_IF
%token TK_ELSE
%token TK_BEG
%token TK_END
%token TK_INTEGER

%token TK_BOOLEAN
%token TK_VOID
%token TK_STR
%token TK_EXTERN
%token key_for
%token key_while 
%token TK_ID
%token TK_NULL
%token TK_BE
%token TK_LE
%token TK_EQ
%token TK_NE
%token TK_AND
%token TK_OR

%left  TK_OR TK_AND
%left  '<' '>' '=' TK_NE TK_LE TK_BE TK_EQ
%left  '+' '-'
%left  '*' '/' '%'

%precedence "decl_sec"
%precedence "ext_decl"



%%

programm: ext_decl head_prog decl_sec section_com 

ext_decl: %empty 							
	|ext_prototype							
	|ext_prototype ext_decl						

ext_prototype: TK_EXTERN protype_func 

head_prog: TK_VOID TK_ID '('')'				

decl_sec : %empty 							
	|declaration							
	|declaration decl_sec

declaration:var_decl						
	|decl_func								
	|protype_func							

var_decl: var_type var_list ';'

var_type: TK_INTEGER						
	|TK_BOOLEAN
	|TK_STR 								

var_list: TK_ID
	|TK_ID ',' var_list					

decl_func: head_func decl_sec section_com

protype_func: head_func';'  

head_func: var_type TK_ID '(' list_typ_par ')'
	| var_type TK_ID '('')'
	| TK_VOID  TK_ID '(' list_typ_par ')'
	| TK_VOID  TK_ID '('')'


list_typ_par: typ_par
	|typ_par ',' list_typ_par

typ_par: var_type TK_ID
	| 	var_type '&' TK_ID

section_com:TK_BEG many_com TK_END				
	|TK_BEG TK_END								

many_com:command
	|command many_com

command:simple_com								
	|str_com									
	|complex 

for_clause: key_for '(' commital ';' gen_factor ';' postfix ')' complex {if ($5>3) fprintf(yyout, "Change While Loop with id %i at line %i.\n",$5,for_line);
																			else fprintf(yyout,"Loop unrolling with id %i at line %i.\n",$5,for_line);} 

while_clause: key_while '(' gen_factor ')' complex { fprintf(yyout, "While loop with var %i .\n",$3,num_line); }

complex:'{'complex_com'}'

complex_com: command
	|command complex_com

str_com: if_clause
	|for_clause
	|while_clause

simple_com:commital
	| return_com
	| call_func
	| null_com	

if_clause: TK_IF'('gen_exp')'command				
	|  TK_IF'('gen_exp')'command else_clause		

else_clause: TK_ELSE command


commital:TK_ID '=' gen_exp 			 	{ $$= $1 = $3;}	

call_func: TK_ID '('list_par')' { fprintf(yyout, "Bike se call func.\n"); }
		|TK_ID'('')' 				



list_par:gen_exp        				
	|gen_exp','list_par           		

gen_exp: gen_factor						{ $$ = $1; }       
	|gen_factor TK_AND gen_exp 			{ $$ = $1 && $3; }
	|gen_factor TK_OR gen_exp    		{ $$ = $1 || $3; }

gen_factor:simple_term					{ $$ = $1 ; }
	|simple_term TK_EQ simple_factor    { $$ = $3; }
	|simple_term TK_NE simple_factor    { $$ = $3; }
	|simple_term TK_LE simple_factor    { $$ = $3; }
	|simple_term TK_BE simple_factor    { $$ = $3; }
	|simple_term '>' simple_factor    	{ $$ = $3;  }  
	|simple_term '<' simple_factor    	{ $$ = $3;  } 
	|'!'gen_factor 						{ $$ = $1; }

simple_term:simple_factor				{ $$ = $1 ; }
	|simple_factor'+'simple_term 		{ $$ = $1 + $3; }
	|simple_factor'-'simple_term 		{ $$ = $1 - $3; }
	|simple_factor'*'simple_term 		{ $$ = $1 * $3; }
	|simple_factor'/'simple_term 		{ $$ = $1 / $3; }
	|simple_factor'%'simple_term 		{ $$ = $1 % $3; }

postfix:'+''+' TK_ID					{ ++$3;}
	|TK_ID'+''+'						{ $1++;}
	|'-''-' TK_ID						{ --$3;}
	|TK_ID'-''-'						{ $1--;}

simple_factor:simple_first          	{ $$ = $1 ; }
	|'+'simple_first             	    { $$ = $2 ; }
	|'-'simple_first					{ $$ =-$2; }

simple_first:TK_ID 						
	| const									
	|'('gen_exp')'                      { $$ = $2; }						
	| call_func	


return_com:TK_RET		  							
	|TK_RET TK_INT

null_com: TK_NULL						

const: TK_INT          	
	| TK_STRING  		 
	| TK_TRUE 			
	| TK_FALSE
 
	

%%		



int main ( int argc, char **argv  ) {
  	++argv; --argc;
  	
	if ( argc > 0 )
   		 yyin = fopen( argv[0], "r" );
 	else
   	 	yyin = stdin;


 	yyout = fopen ( "output", "w" );
	

	
	
 	yyparse ();	
 	yyprint();

 
	return 0;
}   