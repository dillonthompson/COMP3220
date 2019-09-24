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
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace 

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner 
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		if !File.exists?(filename)
			puts ("file was not found!")
			exit 0
		end
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		@f = File.open(filename,'r:utf-8')
		
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	# You should also print what you find. Follow the format from the
	# example given in the instructions.
	def nextToken() 
		if @c == "eof"
			return Token.new(Token::EOF,"eof")
		end	
		if (whitespace?(@c))
			str =""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::WS,str)
			return tok
		end
		if (letter?(@c))
			str = ""
			while letter?(@c)
				str += @c
				nextCh()
			end
			if str == "print"
				tok = Token.new(Token::PRINT,str)
				return tok
			else
				tok = Token.new(Token::ID,str)
				return tok
			end
		end
		if (numeric?(@c))
			str =""
			while numeric?(@c)
				str += @c
				nextCh()
			end
			tok = Token.new(Token::INT, str)
			return tok
		end
		if (@c == "(")
			str = @c
			nextCh()
			return Token.new(Token::LPAREN,str)
		end
		if (@c == ")")
			str = @c
			nextCh()
			return Token.new(Token::RPAREN,str)
		end
		if (@c == "+")
			str = @c
			nextCh()
			return Token.new(Token::ADDOP,str)
		end
		if (@c == "-")
			str = @c
			nextCh()
			return Token.new(Token::SUBOP,str)
		end
		if (@c == "=")
			str = @c
			nextCh()
			return Token.new(Token::ASSIGN,str)
		end
		if (@c == "/")
			str = @c
			nextCh()
			return Token.new(Token::DIVOP,str)
		end
		tok = Token.new("unknown","unknown")
		nextCh()
		return tok
	end
	
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end


end
