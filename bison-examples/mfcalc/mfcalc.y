%{
	package main
	import (
		"fmt"
		"math"
	)
%}

%union {
	val float64  /* For returning numbers.                   */
	tptr *SymRec   /* For returning symbol-table pointers      */
}

%token <val>  NUM        /* Simple double precision number   */
%token <tptr> VAR FNCT   /* Variable and Function            */
%type  <val>  exp

%right '='
%left '-' '+'
%left '*' '/'
%left NEG     /* Negation--unary minus */
%right '^'    /* Exponentiation        */

/* Grammar follows */

%%

input:   /* empty */
        | input line
;

line:
          '\n'
        | exp '\n'   { fmt.Printf ("\t%.10g\n", $1); }
        | error '\n' { fmt.Println("yyerrok")                  }
;

exp:      NUM                { $$ = $1;                         }
        | VAR                { $$ = $1.Value.Var;              }
        | VAR '=' exp        { $$ = $3; $1.Value.Var = $3;     }
        | FNCT '(' exp ')'   { $$ = $1.Value.Func($3); }
        | exp '+' exp        { $$ = $1 + $3;                    }
        | exp '-' exp        { $$ = $1 - $3;                    }
        | exp '*' exp        { $$ = $1 * $3;                    }
        | exp '/' exp        { $$ = $1 / $3;                    }
        | '-' exp  %prec NEG { $$ = -$2;                        }
        | exp '^' exp        { $$ = math.Pow($1, $3);               }
        | '(' exp ')'        { $$ = $2;                         }
;
/* End of grammar */
%%
