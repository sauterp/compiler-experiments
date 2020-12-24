/* Infix notation calculator--calc */

%{
	package main
	import (
		"fmt"
		"math"
	)
%}

%union {
	n float64
}

/* BISON Declarations */
%token NUM
%left '-' '+'
%left '*' '/'
%left NEG     /* negation--unary minus */
%right '^'    /* exponentiation        */

/* Grammar follows */
%%
input:    /* empty string */
        | input line
;

line:     '\n'
        | exp '\n'  { fmt.Printf ("\t%f\n", $1.n); }
;

exp:      NUM                { $$.n = $1.n;         }
        | exp '+' exp        { $$.n = $1.n + $3.n;    }
        | exp '-' exp        { $$.n = $1.n - $3.n;    }
        | exp '*' exp        { $$.n = $1.n * $3.n;    }
        | exp '/' exp        { $$.n = $1.n / $3.n;    }
        | '-' exp  %prec NEG { $$.n = -$2.n;        }
        | exp '^' exp        { $$.n = math.Pow ($1.n, $3.n); }
        | '(' exp ')'        { $$.n = $2.n;         }
;
%%
