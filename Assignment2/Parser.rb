# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner
	def initialize(filename)
    	super(filename)
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	def match(dtype)
      	if (@lookahead.type != dtype)
         	puts "Expected #{dtype} found #{@lookahead.text}"
      	end
      	consume()
   	end
   	
	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()  
      	end
   	end

	def factor()
		if (@lookahead.type != Token::LPAREN || Token::ID || Token::INT)
			puts "Expected ( or INT or ID found: #{@lookahead.text}"
			consume()
			return
		end
		if (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN token: #{@lookahead.text}"
			match(Token::LPAREN)
			puts "Entering EXP rule"
			exp()
			puts "Found RPAREN token: #{@lookahead.text}"
			match(Token::RPAREN)
		end
		if (@lookahead.type == Token::INT)
			puts "Found INT token: #{@lookahead.text}"
			match(Token::INT)
		end
		puts "Exiting FACTOR rule"
	end

	def ttail()
		if (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP token: #{@lookahead.text}"
			match(Token::DIVOP)
			ttail()
		end
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP token: #{@lookahead.text}"
			match(Token::MULTOP)
			ttail()
		end
		if (@lookahead.type != Token::DIVOP || Token::MULTOP)
			puts "Did not find MULTOP or DIVOP token, choosing EPSILON production"
			consume()
			return
		end
		print "Exiting TTAIL rule"
	end

	def etail()
		if(@lookahead.type == Token::ADDOP)
			puts "Found ADDOP token: #{@lookahead.text}"
			match(Token::ADDOP)
			etail()
		end
		if (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP token: #{@lookahead.text}"
			match(Token::SUBOP)
			etail()
		end
		if (@lookahead.type != Token::ADDOP || Token::SUBOP)
			puts "Did not find ADDOP or SUBOP token, choosing EPSILON"
			consume()
			return
		end
		puts "Exiting ETAIL rule"
	end

	def term()
		puts "Entering FACTOR rule"
		factor()
		puts "Entering TTAIL rule"
		ttail()
		puts "Exiting TERM rule"
	end


	def exp()
		puts "Entering TERM rule"
		term()
		puts "Entering ETAIL rule"
		etail()
		puts "Exiting EXP rule"
	end


	def assign()
		if (@lookahead.type == Token::ID)
			puts "Found ID token: #{@lookahead.text}"
			match(Token::ID)
		end
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN token: #{@lookahead.text}"
			match(Token::ASSGN)
			puts "Entering EXP rule"
			exp()
		end
		consume()
	end


	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			puts "Entering EXP Rule"
			exp()
		else
			puts "Entering ASSGN Rule"
			assign()
		end
		
		puts "Exiting STMT Rule"
	end
end
