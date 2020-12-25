package main

import (
	"os"
	"fmt"
	"math"
	"strings"
)

type Value struct {
	Var     float64
	Func ScalarValuedScalarFunction
}

// SymRec is a data type for links in the chain of symbols.
type SymRec struct {
	Name  string
	Type  int   /* type of symbol: either VAR or FNCT */
	Value Value
	Next *SymRec
}

type ScalarValuedScalarFunction func(float64) float64

func main() {
	InitTable()
	yyParse(NewLexerWithInit(os.Stdin, func(y *Lexer) { }))
}

/* Called by yyparse on error */
func yyerror(s string) {
	fmt.Printf("%s\n", s)
}

type Init struct {
	FName string
	Func  ScalarValuedScalarFunction
}

var ArithFunc = []Init{
	{"sin", math.Sin},
	{"cos", math.Cos},
	{"atan", math.Atan},
	{"ln", math.Log},
	{"exp", math.Exp},
	{"sqrt", math.Sqrt},
	{"", nil},
}

/* The symbol table: a chain of `struct SymRec'.  */
var symTable *SymRec

//InitTable puts arithmetic functions in table.
func InitTable() {
	var ptr *SymRec
	for i := 0; ArithFunc[i].FName != ""; i++ {
		ptr = PutSym(ArithFunc[i].FName, FNCT)
		ptr.Value.Func = ArithFunc[i].Func
	}
}

func PutSym(SymName string, SymType int) *SymRec {
	var ptr *SymRec
	ptr = new(SymRec)
	ptr.Name = SymName
	ptr.Type = SymType
	ptr.Value.Var = 0 /* set value to 0 even if fctn.  */
	ptr.Next = symTable
	symTable = ptr
	return ptr
}

func GetSym(SymName string) *SymRec {
	var ptr *SymRec
	for ptr = symTable; ptr != nil; ptr = ptr.Next {
		if strings.Compare(ptr.Name, SymName) == 0 {
			return ptr
		}
	}
	return nil
}
