{
	open Parser
	exception Eof
}

rule main = parse
	| [' ' '\t' '\n'] 			{ main lexbuf }
	| ['0'-'9']+ as lxm 		{ INT(int_of_string lxm) }
	| '''['a'-'z']''' as lxm 	{ CHAR(lxm) }
	| '"'['a'-'z']+'"' as lxm 	{ WORD(lxm) }
	| 'U' 						{ UNION }
	| 'N' 						{ INTERSECT }
	| "read" 					{ READ }
	| "let" 					{ LET }
	| "in" 						{ IN }
	| "append" 					{ APPEND }
	| '<' 						{ LESSTHAN }
	| '>' 						{ GREATERTHAN }
	| "concat" 					{ CONCAT }
	| "limit" 					{ LIMIT }
	| "trimto" 					{ TRIM }
	| "limitfrom" 				{ LIMITFROM }
	| "langsfrom" 				{ LANGSFROM }
	| "get" 					{ GET }
	| "head" 					{ HEAD }
	| "tail" 					{ TAIL }
	| "wordlength" 				{ WORDLENGTH }
	| "length" 					{ LENGTH }
	| "contains" 				{ CONTAINS }
	| "printlist" 				{ PRINTLIST }
	| "if"						{ IF }
	| "then" 					{ THEN }
	| "else" 					{ ELSE }
	| "unique"					{ UNIQUE }
	| '+'						{ ADD }
	| '-'						{ SUBTRACT }
	| '*'						{ MULTIPLY }
	| '/'						{ DIVIDE }
	| '^' 						{ STRINGCONCAT }
	| '<' 						{ LESSTHAN }
	| '>' 						{ GREATERTHAN }
	| '@' 						{ CONS }
	| '}' 						{ CURLYCLOSE }
	| ',' 						{ COMMA }
	| '{' 						{ CURLYOPEN }
	| ')' 						{ BRACECLOSE }
	| '(' 						{ BRACEOPEN }
	| '=' 						{ EQUALS }
	| ':' 						{ COLON }
	| ''' 						{ QUOTE }
	| ';' 						{ EOL }
	| ['A'-'Z''a'-'z''0'-'9']+ as lxm { STRING lxm }
	| eof 						{ EOF }
