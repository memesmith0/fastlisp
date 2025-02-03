#Copyright (C) 2025 by john morris beck <john.morris.beck@hotmail.com>
#
#Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is#hereby granted.
#
#THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
#
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
#
#RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
#
#THIS SOFTWARE.

    #convert newlines to spaces
convert_newlines_to_spaces(){ busybox awk '{ printf "%s ", $0 }' ; } ;

#convert spaces to newlines

convert_spaces_to_newlines(){ busybox awk '{ gsub(/ /, "\n"); print }' ; } ;

#remove extreneous newlines
remove_extreneious_newlines(){ busybox awk '{

print "hello"			       

}' ; }

#convert ( to \n(\n
separate_left_paren(){ busybox awk '{ gsub(/\(/, "(\n"); print; }' ; } ;

    #convert ) to \n)\n
separate_right_paren(){ busybox awk '{ gsub(/\)/, "\n)"); print; }' ; } ;


    #delete contents of comment nodes
delete_comments(){ busybox awk '{ printing = 1 } previous_line == "(" && $0 == "comment" { printing = 0, depth = 1 } printing == 0 && $0 == "(" { depth = depth + 1 } printing == 0 && $0 == ")" { depth = depth - 1 } depth == 0 { printing = 1 } printing == 1 { print $0 } { previous_line = $0 }' ; } ;

#break the file up into characters
break_file_into_characters(){ busybox awk '{if($0 != "(" && $0 != ")") {for (i = 1; i <= length($0); i++) printf "%c\n", substr($0, i, 1); {printf "\n"}} else{print $0}}' ; } ;



turn_characters_into_ints(){ busybox awk 'BEGIN    { _ord_init() }

function _ord_init(    low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7
    if (low == "\a") {    # regular ascii
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
       low = 128
        high = 255
    } else {        # ebcdic(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}
function ord(str,    c)
{
    # only first character is of interest
    c = substr(str, 1, 1)
    return _ord_[c]
}

function chr(c)
{
    # force c to be numeric by adding 0
    return sprintf("%c", c + 0)
}

{print ord($0)}
' ; } ;

turn_ints_into_binary(){ busybox awk '{
  num = $0;
  if (num < 0) {
    print "Negative numbers not supported"; # Or handle them as you wish
    next; # Skip to the next line
  }
  if (num == 0) {
    print "0";
    next; # Skip to the next line
  }

  bin = "";
  while (num > 0) {
    rem = num % 2;
    bin = rem bin; # Prepend the remainder
    num = int(num / 2); # Integer division is crucial
  }
  print bin;
}' ; } ;

prepend_0(){ busybox awk '{

	    for(i=(8-length($0)); i > 0; i--){

	    printf "%s", 0
	    
	    }
	    printf "%s\n", $0



    }';


	   }


convert_lambdas(){ busybox awk '
{

	is_closing_paren=( $0 == "00101001" );
        if(is_closing_paren && text_mode){
		printf "%s%s", "(lambda x (lambda y y))";
		for(i=0;bit_counter > 0; bit_counter--){
				      printf "%s", ")";
				      };
	        printf("\n");

	}
	else if(text_mode){
		    for(i = 0; i < 8; i++){
				    foo=substr($0, i, 1);
				    printf "%s%s", "((lambda x (lambda y (lambda z (z x y)))) ", (foo ? " (lambda x (lambda y x)) "  : "(lambda x (lambda y y ))")
				    bit_counter++;
		    		    };

				    }
	else { print $0 };

	if(is_closing_paren){text_mode=0};
	a5=a4;
	a4=a3;
	a3=a2;
	a2=a1;
 	a1=a0;
	a0=$0;

	if((!is_closing_paren) && a5=="00101000" && a4=="01110100" && a3=="01100101" && a2=="01111000" && a1=="01110100" && a0 == "00000000"){
	text_mode=1;
	bit_counter=1;


}
}
' ; }

# 00101000 "(" 01110100 "t" 01100101 "e" 01111000 "x" 01110100 "t"
# 00101000 "(" 01110100 "t" 01100101 "e" 01111000 "x" 01110100 "t"


#get input file into pipeline
cat "$1" |
    convert_newlines_to_spaces |
    convert_spaces_to_newlines |
    separate_left_paren |
    separate_right_paren |
    delete_comments |
    break_file_into_characters |
    turn_characters_into_ints |
    turn_ints_into_binary |
    prepend_0 |
    convert_lambdas
