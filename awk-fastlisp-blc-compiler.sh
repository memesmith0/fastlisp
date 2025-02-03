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
		printf "%s%s", "(\nl\na\nm\nb\nd\na\n \nx\n \n(\nl\na\nm\nb\nd\na\n \ny\n \ny\n)\n)\n";
		for(i=0;bit_counter > 0; bit_counter--){
				      printf "%s", ")";
				      };

				      #this seems wrong should only need to print one \n
	        printf "\n\n";

	}
	else if(text_mode){
		    for(i = 0; i < 8; i++){
				    foo=substr($0, i, 1);
				    printf "%s%s", "\n(\n(\nl\na\nm\nb\nd\na\n \nx\n \n(\nl\na\nm\nb\nd\na\n \ny\n \n(\nl\na\nm\nb\nd\na\n \nz\n \n(\nz\n \nx\n \ny\n)\n)\n)\n)\n \n", (foo ? "\n \n(\nl\na\nm\nb\nd\na\n \nx\n \n(\nl\na\nm\nb\nd\na\n \ny\n \nx\n)\n)\n \n"  : "\n(\nl\na\nm\nb\nd\na\n \nx\n \n(\nl\na\nm\nb\nd\na\n \ny\n \ny\n \n))")
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

append_text_to_nonbinary_lines(){ busybox awk '{
  all_ones_or_zeros = 1;

  for (i = 1; i <= length($0); i++) {
    char = substr($0, i, 1);
    if (char != "0" && char != "1") {
      all_ones_or_zeros = 0; 
      break;
    }
  }

  if (!all_ones_or_zeros) {
    printf "text: %s\n", $0;
  }
  else{ print $0 };
}'
				}

turn_text_nodes_into_ints(){ busybox awk 'BEGIN    { _ord_init() }

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

{if($1 == "text:"){printf "text: %s\n", ord($2)}else{print $0}}

' ; } ;

turn_text_nodes_into_binary(){ busybox awk '{
  if($1 == "text:"){
  num = $2;
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
  printf "text: %s\n", bin;
}
else{ print $0 }
}' ; } ;

prepend_0_to_text_node(){ busybox awk '{

	    if($1 == "text:"){
	    	  for(i=(8-length($2)); i > 0; i--){

	    			  printf "%s", 0;
	    
		     }
		     	    printf "%s\n", $2;
	         }
	    else{ print $0 }



    }'; } ;


replace_whitespace_with_00000000(){ busybox awk '{ if($0 == "" || $0 == "0"){print "00000000"}else{print $0}}' ; } ;



replace_binary_with_int(){ busybox awk '{
  # Check if the input is 8 bits long and contains only 0s and 1s (optional but good practice)
  if (length($0) != 8 || $0 !~ /^[01]+$/) {
    print "Invalid input: Line must be 8 bits and contain only 0s and 1s: " $0 > "/dev/stderr"; # Print error to stderr
    next; # Skip to the next line
  }

  decimal = 0;
  for (i = 1; i <= 8; i++) {
    bit = substr($0, i, 1);
    decimal = decimal * 2 + bit;  # Efficient way to convert
  }
  print decimal;
}' ; } ;

int_to_char(){ busybox awk '{ if($0){printf "%c", $0 }else{printf " "}}' ; } ;


# 00101000 "(" 01110100 "t" 01100101 "e" 01111000 "x" 01110100 "t"
# 00101000 "(" 01110100 "t" 01100101 "e" 01111000 "x" 01110100 "t"


#get input file into pipeline
cat "$1" |
    convert_newlines_to_spaces |
    convert_spaces_to_newlines |
    separate_left_paren |
    separate_right_paren |
    delete_comments #|
#    break_file_into_characters |
#    turn_characters_into_ints |
#    turn_ints_into_binary |
#    prepend_0 |
#    convert_lambdas |
#    append_text_to_nonbinary_lines |
#    turn_text_nodes_into_ints |
#    turn_text_nodes_into_binary |
#    prepend_0_to_text_node |
#    replace_whitespace_with_00000000 |
#    replace_binary_with_int |
#    int_to_char
    
