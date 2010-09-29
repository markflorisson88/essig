grammar essig;

options {
	output = AST;
}

tokens {
	MICROCONTROLLER =	'uc';
	LBRACK		=	'{';
	RBRACK		=	'}';
	ASSIGN		=	'=';
	REGISTER	=	'register';
	LINE_SEPERATOR	=	';';
	ARG_SEPERATOR	=	',';
	
	// Logical operators
	NOT		=	'!';
	AND		=	'&';
	OR		=	'|';
	XOR		=	'^';
	ADD		=	'+';
}

/*
 * Parser
 */
microcontroller:	IDENTIFIER LBRACK! registers? instructions? RBRACK! EOF!;

registers:		(register LINE_SEPERATOR!)+;
register:		REGISTER IDENTIFIER ;

instructions:		instruction+;
instruction:		IDENTIFIER (IDENTIFIER (ARG_SEPERATOR! IDENTIFIER)+)? LBRACK! expr+ RBRACK!;

expr:			assignExpr LINE_SEPERATOR!;
assignExpr:		IDENTIFIER ASSIGN (NOT? IDENTIFIER | NUMBER) (operator (NOT? IDENTIFIER | NUMBER ))*;

operator:		AND | OR | XOR | ADD;

/*
 * Lexer
 */
IDENTIFIER		:	LETTER (LETTER | DIGIT)*;

NUMBER			:	DIGIT+;

WHITESPACE		:	( '\t' | ' ' | '\r' | '\n'| '\u000C' )+ 	{ $channel = HIDDEN; } ;

ML_COMMENT		:	 '/*' ( options {greedy=false;} : . )* '*/' { skip(); };

fragment DIGIT		:	'0'..'9';

fragment LETTER		:	('a'..'z'|'A'..'Z');