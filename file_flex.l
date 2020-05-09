%{
#include "y.tab.h"  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

int num_line = 1;
int num_for =0;
int for_line[10] ;





%}

%option   yylineno
%option   noyywrap

digit   [0-9] 
other_chars [-_] 
id		[a-z]([a-z0-9]|{other_chars})*
string  [0-9][a-z0-9]+
keyword_for			[f][o][r]
keyword_while		[Ww][Hh][Ii][Ll][Ee]



%%

{digit}+ 	 							{ yylval=atoi(yytext); return TK_INT; }
"true"									{ return TK_TRUE; }
"false"									{ return TK_FALSE;}
"return"                                { return TK_RET;}
"else"									{ return TK_ELSE;}
"if"									{ return TK_IF;}
"begin"									{ return TK_BEG;}
"end"									{ return TK_END;}
"void"									{ return TK_VOID;}
"string"								{ return TK_STR;}
{keyword_while}						    { return key_while;}
"integer"								{ return TK_INTEGER;}
"boolean"								{ return TK_BOOLEAN;}
"extern"								{ return TK_EXTERN;}
{keyword_for}						    { for_line[num_for] = num_line-1; num_for++; return key_for;}
{string}							    { return TK_STRING;}
{id}								    { return TK_ID;}
"="										{ return '='; }
"+"										{ return '+'; }
"-"										{ return '-'; }
"/"										{ return '/'; }
"*"										{ return '*'; }
"%"										{ return '%'; }
")"										{ return ')'; }
"("										{ return '('; }
"{"										{ return '{'; }
"}"										{ return '}'; }
">"										{ return '>'; }
"<"										{ return '<'; }
">="									{ return TK_BE;}
"<="									{ return TK_LE;}
"=="									{ return TK_EQ;}
"!="									{ return TK_NE;}
"!"										{ return '!'; }	
"||"									{ return TK_OR; }
"&&"									{ return TK_AND; }
","										{ return ',';}
";"										{ return ';';}
"&"										{ return '&';}
\0                                      { return TK_NULL;}
\n 										{ num_line++;}
.          								{ ;}




%%

void yyprint(){
	char a, b;
	char *c;
	int rows = 1;
	char **array;
	char **fcase;
	char *temp1;
	char *temp2;

	int flag = 1;


	int i, j, k, l, m, n;

	int diff[15];
	int for_val;
	char for_char;

	yyin = fopen("input", "r");                 //  													
	if (yyin == NULL){								// open files
		puts("cannot open this file");			//					
		exit(1);								//
	}

	yyout = fopen("output", "w");                 //                                                                                    
	if (yyout == NULL){                              //  open files                                                    
		puts("Not able to open this file");       //                                                                                  
		exit(1);                                  //     
	}

	/******                   MALLOC                *****/
	temp1 = (char *)malloc(10000 * sizeof(char));
	for (i = 0; i<10000; i++){
		temp1[i] = ' ';
	}
	temp2 = (char *)malloc(10000 * sizeof(char));
	for (i = 0; i<10000; i++){
		temp2[i] = ' ';
	}

	fcase = (char **)malloc(1000 * sizeof(char*));
	for (i = 0; i<1000; i++){
		fcase[i] = (char *)malloc(1000);
	}

	array = (char **)malloc(1000 * sizeof(char*));
	for (i = 0; i<1000; i++){
		array[i] = (char *)malloc(10000);
	}
	/*******                                     *****/




	/*******         CHANGE INPUT                *****/
	i = 0;
	j = 0;

	do{
		a = fgetc(yyin);
		if ((a >= 32 && a <= 125) || a == 10)

			if (a == '\n'){
			array[i][j] = a;
			fputc(array[i][j],yyout);
			array[i][j + 1] = '\0';
			rows++;
			i++;
			}
			else  {
				array[i][j] = a;
				fputc(array[i][j],yyout);
			}
			j++;
	} while (a != EOF);

	array[i][j+1] = EOF;
	/*i = 0;
	j = 0;

	do{

			if (array[i][j] == '\n'){
			fputc(array[i][j],yyout);
			i++;
			}
			else  {
				fputc(array[i][j],yyout);
			}
			j++;
	} while (array[i][j] != EOF);

	printf("\n");
*/ 


	for (k = 0; k < num_for; k++){ 					//loopa gia plithos yparksewn for
		printf("For at line %d \n", for_line[k]);
		i = 0;
		j = 0;

		do{
			j++;
		} while (array[for_line[k]][j] != '(');


		do{
			j++;
			fcase[k][i] = array[for_line[k]][j];
			i++;
		} while (array[for_line[k]][j] != ')');

		fcase[k][i - 1] = '\0';
		printf("For case ( %s ) \n", fcase[k]);
		diff[k] = (fcase[k][6] - '0') - (fcase[k][2] - '0');
		printf("Number of repeats :  %d  \n", diff[k]);

		j = 0;

		if (diff[k] < -2 || diff[k] > 2){

			while ((array[for_line[k]][j]) != 'f'){
				array[for_line[k]][j] = ' ';
				j++;
			}

			j = 0;
			array[for_line[k]][j] = 'w';
			j++;
			array[for_line[k]][j] = 'h';
			j++;
			array[for_line[k]][j] = 'i';
			j++;
			array[for_line[k]][j] = 'l';
			j++;
			array[for_line[k]][j] = 'e';
			j++;
			array[for_line[k]][j] = '(';
			j++;
			array[for_line[k]][j] = fcase[k][4];
			j++;
			array[for_line[k]][j] = fcase[k][5];
			j++;
			array[for_line[k]][j] = fcase[k][6];
			j++;
			array[for_line[k]][j] = ')';
			j++;
			array[for_line[k]][j] = '{';
			j++;

			while (array[for_line[k]][j] != '{'){
				array[for_line[k]][j] = '\0';
				j++;
			}

			array[for_line[k]][j] = '\n';

			i = for_line[k] + 1;
			j = 0;

			do{
				if (array[i][j] == '\n') i++;
				j++;
			} while (array[i][j] != '}');

			j -= 4;
			array[i][j] = fcase[k][4];
			j++;
			array[i][j] = fcase[k][9];
			j++;
			array[i][j] = fcase[k][9];

		}
		else if (diff[k] >= -2 && diff[k] <= 2){		//loop unroll

			j = -1;

			printf("For at line %d \n", for_line[k]);

			for_char = fcase[k][0];
			printf("for_char: %c\n", for_char);
			for_val = fcase[k][2] - '0';
			printf("for_val: %d\n", for_val);

			do{
				array[for_line[k]][j] = ' ';
				j++;
			} while (array[for_line[k]][j] != '{');

			i = for_line[k];

			do{


				j = 0;

				do{
					//printf("%c",array[i][j]);
					if (array[i][j] == '\n'){
						i++;
						j = 0;
					}
					j++;
				} while (array[i][j] != for_char && array[i][j] != '}');

				if (array[i][j] == '}') flag = 0;
				else{
					l = j;
					j = 0;


					do{

						temp1[j] = array[i][j];
						temp2[j] = array[i][j];
						//printf("%c",temp1[0][j]);
						j++;
					} while (array[i][j] != '\n');


					temp1[j + 1] = '\n';
					temp2[j + 1] = '\n';


					m = for_val;

					if (diff[k] > 0){
						n = 0;
						do{
							j = 0;
							while (temp1[j] != '\n'){

								if (temp1[j] == for_char){
									temp2[j] = '0' + m;		//antikatastasi i me timh 
								}
								j++;
							}
							j = 0;

							printf("\n");

							do{
								array[i][n] = temp2[j];
								printf("%c", temp2[j]);
								j++;
								n++;
							} while (temp2[j] != '\n');


							n++;
							array[i][n] = '\n';
							n++;
							m++;
						} while (m < diff[k]);
					}
					else if (diff[k] < 0){
						n = 0;
						do{
							j = 0;
							while (temp1[j] != '\n'){

								if (temp1[j] == for_char){
									temp2[j] = '0' + m;		//antikatastasi i me timh 
								}
								j++;
							}
							j = 0;

							printf("\n");

							do{
								array[i][n] = temp2[j];
								printf("%c", temp2[j]);
								j++;
								n++;
							} while (temp2[j] != '\n');


							n++;
							array[i][n] = '\n';
							n++;
							m--;
						} while (m > ((-1)*diff[k]));
					}

				}
			} while (flag == 1);
		}

	}








		for (i = 0; i<rows; i++){
			//fprintf(yyout,"%s",array[i]);
			for (j = 0; j<1000; j++){
				//fprintf(yyout,"%c",array[i][j]);
				printf("%c", array[i][j]);
				
				// SOS PREPEI NA PERASOUME STO OUTPUT
			}
			//printf("\n");
			//fprintf(yyout,"\n");
		}

		j=0;
		i=0;
	/*do{

			if (array[i][j] == '\n'){
			fputc(array[i][j],yyout);
			i++;
			}
			else  {
				fputc(array[i][j],yyout);
			}
			j++;
	} while (array[i][j] != 'd');
*/


		//rewind(yyin);
		//rewind(yyout);


		//fprintf(yyout, "\nTotal ROWS: %i \n ", rows);

		fcloseall();
}




void yyerror(char *s) {
		fprintf(stderr, "At line %d %s\n", num_line, s);
}

