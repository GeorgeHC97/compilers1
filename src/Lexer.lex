import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
   private Symbol symbol(int type){
       return new Symbol(type, yyline, yycolumn);
   }
   
   private Symbol symbol(int type, Object value){
       return new Symbol(type, yyline, yycolumn, value);
   }
%}


SingleComment = "#".*[\r|\n|\r\n]
MultiComment = "/#"(.*|{Whitespace}*)*"#/"
Comment = {SingleComment} | {MultiComment}

Letter = [a-zA-Z]
Digit = [0-9]
IdChar = {Letter} | {Digit} | "_"
Identifier = {Letter}{IdChar}*

Punctuation = [\.,-\/#!$%\^&\*;:{}=\-_`~()]
C_Literal = {Letter}|{Digit}|{Punctuation}
Char = {Char1}|{Char2}
Char1 = ’{C_Literal}’
Char2 = '{C_Literal}'
S_Literal = {C_Literal}|[" "]|["\t"]|["\f"]
String = \"{S_Literal}*\"
Boolean = [T]|[F]
Number = {Integers}|{Rational}|{Float}
NotZero = [1-9]{Digit}*
Integer = (0|[1-9]{Digit}*)
Rational = [0-9]*\_([0-9]*\/?[0-9]+) | [0-9]*" "*\/" "?[0-9]+ 
Float = {Digit}*\.?{Digit}+

NegativeNumber = -Number


Whitespace = \r|\n|\r\n|" "|"\t"

%% 
<YYINITIAL> {
  /* Data types */
  "char"               { return symbol(sym.CHAR);}
  "bool"               { return symbol(sym.BOOL);}
  "int"                { return symbol(sym.INT);}
  "rat"                { return symbol(sym.RAT);}
  "float"              { return symbol(sym.FLOAT);}
  "top"                { return symbol(sym.TOP);}
  "dict"               { return symbol(sym.DICT);}
  "seq"                { return symbol(sym.SEQ);}

  /* Declarations */
  "tdef"               { return symbol(sym.TDEF);}
  "fdef"               { return symbol(sym.FDEF);}
  "alias"              { return symbol(sym.ALIAS);}
  "main"               { return symbol(sym.MAIN);}
  "void"               { return symbol(sym.VOID);}

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
  "if"                 { return symbol(sym.IF);}
  "then"               { return symbol(sym.THEN);}
  "else"               { return symbol(sym.ELSE);}
  "fi"                 { return symbol(sym.FI);}
  "elif"               { return symbol(sym.ELIF);}
  "while"              { return symbol(sym.WHILE);}
  "do"                 { return symbol(sym.DO);}
  "od"                 { return symbol(sym.OD);}
  "forall"             { return symbol(sym.FORALL);}
  "in"                 { return symbol(sym.IN);}
  "return"             { return symbol(sym.RETURN);}

  /* IO */
  "read"               { return symbol(sym.READ);}
  "print"              { return symbol(sym.PRINT);}

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
  {Boolean}            { return symbol(sym.BOOLEAN);} 
  {Char}               { return symbol(sym.CHARACTER);}
  {Integer}            { return symbol(sym.INTEGER, new Integer(yytext()));}
  {Float}              { return symbol(sym.FLOAT_LIT, new Float(yytext()));}
  {Rational}           { return symbol(sym.RATIONAL);}
  {String}             { return symbol(sym.STRING);}
  {Identifier}         { return symbol(sym.IDENTIFIER,yytext());}
}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}