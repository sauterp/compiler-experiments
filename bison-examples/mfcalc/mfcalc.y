%{
	package main
	import (
		"fmt"
		"math"
	)
%}

%union {
	Val float64  /* For returning numbers.                   */
	Tptr *SymRec   /* For returning symbol-table pointers      */
}

%token <Val>  NUM        /* Simple double precision number   */
%token <Tptr> VAR FNCT   /* Variable and Function            */
%type  <Val>  exp

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
        | VAR                { 
				s := GetSym($1.Name);
				$$ = s.Value.Var
              }
        | VAR '=' exp        { s := GetSym($1.Name)
				if s == nil {
					s = PutSym($1.Name, VAR)
				}
				s.Value.Var = $3
				$$ = s.Value.Var }
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
