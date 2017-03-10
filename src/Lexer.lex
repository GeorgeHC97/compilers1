import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
   private Symbol symbol(int type)
   {
       return new Symbol(type, yyline, yycolumn);
   }
   
   private Symbol symbol(int type, Object value)
   {
       return new Symbol(type, yyline, yycolumn, value);
   }
%}

//Comments and Whitespace//
SingleLineComment = "#".*[\r|\n|\r\n]
MultiLineComment = "/#"(.*|{Whitespace}*)*"#/"
Comment = {SingleLineComment} | {MultiLineComment}
Whitespace = [ \r\n\t\f]

Letter = [a-zA-Z]

//Identifier must start with a letter
Identifier = {Letter}\w*

Punctuation = [\.,-\/#!$%\^&\*;:{}=\-_`~()]
CharLiteral = {Letter}|\d|{Punctuation}
Char = ’{CharLiteral}’|'{CharLiteral}'
StringLiteral = {CharLiteral}|[" "]|["\t"]|["\f"]
String = \"{StringLiteral}*\"
Boolean = [TF]

Number = {Integers}|{Rational}|{Float}
NonZero = [1-9]\d*
Integer = (0|-?{NonZero}\d*)
Rational = -?\d*\_(\d*\/?\d+) | -?\d*\s*\/\s*\d+ 
Float = -?\d*\.\d+


%% 
<YYINITIAL> {
  /* Data types */
  char               { return symbol(sym.CHAR);}
  bool               { return symbol(sym.BOOL);}
  int                { return symbol(sym.INT);}
  rat                { return symbol(sym.RAT);}
  float              { return symbol(sym.FLOAT);}
  top                { return symbol(sym.TOP);}
  dict               { return symbol(sym.DICT);}
  seq                { return symbol(sym.SEQ);}

  /* Declarations */
  tdef               { return symbol(sym.TDEF);}
  fdef               { return symbol(sym.FDEF);}
  alias              { return symbol(sym.ALIAS);}
  main               { return symbol(sym.MAIN);}
  void               { return symbol(sym.VOID);}
  

  /* Operators*/
  "+"                  { return symbol(sym.PLUS);}
  "-"                  { return symbol(sym.MINUS);}
  "/"                  { return symbol(sym.DIVIS);}
  "*"                  { return symbol(sym.MULTI);}
  "^"                  { return symbol(sym.POW);}
  "="                  { return symbol(sym.ASSIGN);}

  /*Logical Operators" */
  "=="                 { return symbol(sym.EQUAL);} 
  "!="                 { return symbol(sym.NOTEQUAL);}
  "!"                  { return symbol(sym.NOT);} 
  "<"                  { return symbol(sym.LESS);}
  "<="                 { return symbol(sym.LESSEQUAL);}
  "&&"                 { return symbol(sym.AND);}
  "||"                 { return symbol(sym.OR);}

  /* Expressions */ 
  if                 { return symbol(sym.IF);}
  then               { return symbol(sym.THEN);}
  else               { return symbol(sym.ELSE);}
  fi                 { return symbol(sym.FI);}
  elif               { return symbol(sym.ELIF);}
  while              { return symbol(sym.WHILE);}
  do                 { return symbol(sym.DO);}
  od                 { return symbol(sym.OD);}
  forall             { return symbol(sym.FORALL);}
  in                 { return symbol(sym.IN);}
  return             { return symbol(sym.RETURN);}

  /* IO */
  read               { return symbol(sym.READ);}
  print              { return symbol(sym.PRINT);}

  /* Seperators */
  "{"                  { return symbol(sym.LBRACE);}
  "}"                  { return symbol(sym.RBRACE);}
  "("                  { return symbol(sym.LPAREN);}
  ")"                  { return symbol(sym.RPAREN);}
  ";"                  { return symbol(sym.SEMICOLON);}
  "["                  { return symbol(sym.LBRACK);}
  "]"                  { return symbol(sym.RBRACK);}
  ">"                  { return symbol(sym.MORESIGN);}
  ","                  { return symbol(sym.COMMA);}
  "."                  { return symbol(sym.DOT);}
  ":"                  { return symbol(sym.COLON);}

  /* Other */
  "::"                  { return symbol(sym.CAT);}
  "len"                 { return symbol(sym.LEN);}

  {Whitespace}         { }
  {Comment}            { }
  {Boolean}            { return symbol(sym.BOOL, new Boolean(yytext()));} 
  {Char}               { return symbol(sym.CHAR, new Character(yytext().charAt(1)));}
  {Integer}            { return symbol(sym.INT, new Integer(yytext()));}
  {Float}              { return symbol(sym.FLOAT, new Float(yytext()));}
  {Rational}           { return symbol(sym.RAT);}
  {String}             { return symbol(sym.STRING, new String(yytext()));}
  {Identifier}         { return symbol(sym.IDENTIFIER,yytext());}
}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}