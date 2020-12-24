package main

import (
	"os"
)

func main() {
	yyParse(NewLexerWithInit(os.Stdin, func(y *Lexer) { }))
}
