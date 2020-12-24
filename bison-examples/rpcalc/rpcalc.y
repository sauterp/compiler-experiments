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

%token NUM

%%

input:	/* empty */
	| input line
;

line:	'\n'
	| exp '\n' { fmt.Printf("\t%f\n", $1.n); }
;

exp:	NUM		{ $$ = $1	}
	| exp exp '+'	{ $$.n = $1.n + $2.n	}
	| exp exp '-'	{ $$.n = $1.n - $2.n	}
	| exp exp '*'	{ $$.n = $1.n * $2.n	}
	| exp exp '/'	{ $$.n = $1.n / $2.n	}
	/* Exponentiation	*/
	| exp exp '^'	{ $$.n = math.Pow($1.n, $2.n) }
	/* Unary minus		*/
	| exp 'n'	{ $$.n = -$1.n	}
;
%%
