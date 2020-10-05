# Primeiro Analisador Léxico

Crie um arquivo LEX que reconheça os tokens descritos a seguir: 

|     Token    |     Lexemas      |     Padrão      |
| ------------ |:-------------:| ------------- |
| _ID          | a b _1 ab1  $tab   _$5       |     	 '$', letra ou '_' seguido por letra, dígito, '$' ou '_'       |
| _INT         |  1 221 0       |     Números inteiros      |
| _FLOAT       | 0.1 1.028 1.2E-4  0.2e+3 1e3       |     Números de ponto flutuante e  em notação científica       |
| _FOR         | for For fOr       |     for, case insensitive      |
| _IF          | if IF          |     if, case insensitive      |
| _MAIG        | >=        |     >=      |
| _MEIG        | <=        |     	<=       |
| _IG          | ==        |      ==      |
| _DIF         | !=        |      !=       |
| _COMENTARIO  |  /* Um comentário */  </* Outro comentário */ <BR/>// Comentário até o final da linha // <BR/>/*Esse comentário anula o início /* Esse comentário foi terminado! // */  |     Um comentário pode se extender por mais de uma linha, e não pode haver comentário dentro de comentário. Não deve juntar comentários que estão separados.      |
| _STRING      |  "hello, world" <BR/>"Aspas internas com \" (contrabarra)" "ou com "" (duas aspas)"        |     Uma string começa e termina com aspas. Se houver aspas dentro da string devemos usar  contrabarra ou duas aspas. Uma string não pode ir além do final da linha.    |

Identificadores (letras, '$' ou sublinhado seguido de letras, '$', sublinhado e dígitos), números, strings entre aspas duplas, entre aspas simples e comentários.

Assuma a seguinte declaração para os tokens:

  | enum TOKEN { _ID = 256, _FOR, _IF, _INT, _FLOAT, _MAIG, _MEIG, _IG, _DIF, _STRING, _COMENTARIO }; |
  | ------------------------------------------------------------------------------------------------- | 

A compilação será feita com o seguinte comando:

  lex scan.lex<BR/> 
  g++ -Wall -std=c++17 main.cc -lfl -o vpl_execution

OBS: Algumas distribuições do linux utilizam bibliotecas com outro nome, possivelmente: "-lf" ou "-ll".