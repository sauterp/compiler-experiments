package main

// SymRec is a data type for links in the chain of symbols.
type SymRec struct
{
  Name *byte  /* name of symbol                     */
  Type int    /* type of symbol: either VAR or FNCT */
  Value struct {
	Var float64
	FnctPtr *func() float64
  }
	Next *SymRec
}

func main() {
	InitTable()
	yyparse()
}

/* Called by yyparse on error */
func yyerror(s string){
	fmt.Printf("%s\n", s)
}

type Init struct {
	FName string
	Fnct *func() float64
}

var ArithFncts = []Init {
      {"sin", sin},
      {"cos", cos},
      {"atan", atan},
      {"ln", log},
      {"exp", exp},
      {"sqrt", sqrt},
      {0, 0},
    }

/* The symbol table: a chain of `struct SymRec'.  */
var SymRec *SymTable

//InitTable puts arithmetic functions in table.
func InitTable() {
  var i int
  var ptr *SymRec
	for i := 0; ArithFncts[i].FName != 0; i++ {
		ptr = PutSym(ArithFncts[i].FName, FNCT)
		ptr.value.fnctptr = ArithFncts[i].fnct
	}
}

func PutSym(SymName string,SymType int) *SymRec {
  var ptr *SymRec
	ptr = new(SymRec)
	ptr.Name = SymName
  ptr.Type = SymType
  ptr.Value.Var = 0; /* set value to 0 even if fctn.  */
	ptr.Next = symTable
  symTable = ptr
  return ptr
}

func GetSym (SymName string) *SymRec {
  var ptr *SymRec
  for ptr = symTable; ptr != nil; ptr = ptr.Next {
    if strings.Compare(ptr.name,SymName) == 0 {
      return ptr
	}
}
  return nil
}
