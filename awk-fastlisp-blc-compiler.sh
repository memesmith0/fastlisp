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

#tester 
#lisbeths@penguin:~$ clear && busybox sh awk-fastlisp-to-blc-compiler.sh fastlisp-program  | awk '{nl++; printf "%s %s\n", nl, $0}' > scrap.lisp

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
delete_comments(){ busybox awk '{
if(depth){
#	print "depth"
	if($0 == "("){ depth++ }
	else if($0 == ")"){ depth-- }
	if($0== ")" && depth == 0){j=1}

}
else{
#	print "\n\nno depth"
#	printf "!pd is: %s\n" , !pd
#	printf "c is: %s\n" , c
#	printf "$0 is: %s\n", $0
#	printf "pl is: %s\n", pl
#	printf "length of pl is: %s\n", length(pl)
	if(pl == "(" && $0 == "comment"){depth++}
	else if(c && !pd && pl){
#	print "printing"
	print pl

	}
#	else "you shouldnt reach me b"
}
if(j){pl=""; j=0}else{pl = $0}
pd = depth
c++

}' ; } ;

break_up_left_then_right_paren(){ busybox awk '{if($0 == ")("){printf ")\n("}else{print $0}}' ; } ;

#break the file up into characters
break_file_into_characters(){ busybox awk '{

if($0 != "(" && $0 != ")") {
      for (i = 1; i <= length($0); i++) printf "%c\n", substr($0, i, 1);
      {printf "\n"}} else{print $0}}' ; } ;



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
		for(i=0;bit_counter > 1; bit_counter--){
				      printf "%s", ")\n";
	p			      };

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

skip_empty_lines(){ busybox awk '{if($0 != ""){ print $0 }}' ; } ;

skip_text(){ busybox awk '{

	a5=a4;
	a4=a3;
	a3=a2;
	a2=a1;
 	a1=a0;
	a0=$0;


	if(!(a5=="00101000" && a4=="01110100" && a3=="01100101" && a2=="01111000" && a1=="01110100" && a0 == "00000000")){

	print a5

	}




}END{print a4; print a3; print a2; print a1; print a0}' ; } ;

remove_text(){ busybox awk '$0 != "text"' ; } ;

replace_freestanding_vars_and_insert_00(){ busybox awk 'BEGIN{
depth["lambda", "i"]=0;
}
{
if($0 == "("){ paren_depth++; print "("}
else if( $0 == ")"){

     print ")"
     paren_depth--

     ##if the the depth is lower than the last lambda depth then
#     printf "our lambda depth: %s\n" depths["lambda", depths["lambda", "i"]]
     lambda_depth=depths["lambda", "i"]
     if(paren_depth < depths["lambda", lambda_depth, "paren"]){




     ##pop lambda paren depth
     delete depths["lambda", lambda_depth, "paren"]
     name=depths["lambda", lambda_depth, "name"]
     #pop name depth
     delete depths[name, depths[name, "i"]]
     #decrement name depth
     delete depths["lambda", lambda_depth, "name"]
     #decriment lambda depth
     depths["lambda", "i"]--
     #decriment name depth
     depths[name, "i"]--

}

}
else if($0 == "lambda"){
     	print "00"
}
else if(last == "lambda"){


	     
     	#increment lambda depth
	depths["lambda", "i"]++

	#store paren depth at lambda depth
	depths["lambda", depths["lambda", "i"], "paren"]=paren_depth
	#store name at lambda depth
        depths["lambda", depths["lambda", "i"], "name"]=$0

	#prep name for storage
	if(!depths[$0, "i"]) depths[$0, "i"]=0


	#at the current index of name store lambda depth
	depths[$0,depths[$0,"i"]]=depths["lambda","i"]

}
else{
	#print replaced name
	print (depths["lambda", "i"] - depths[$0, depths[$0, "i"]]) + 1

}


last=$0
lastlast=last


}end{print $0}'

					 }


unappend_text_from_paren_lines(){ busybox awk '{


if($1 == "text:"){
      if(($2 == "(") || ($2 == ")")){
      print $2
      }
      else{
	print $0
      }
}
else{print $0}


}' ; }




turn_texts_ints_into_binary(){ busybox awk '{

if($1 == "text:"){
  num = $2;
  for(i=$2; i>0; i--){
  printf "1"
  }
  printf "0\n"
}
else{
	print $0
}
}' ; } ;

append_text_to_1(){ busybox awk '{if($0=="1"){printf "text: 1\n"}else{print $0}}' ; } ;
 


#get input file into pipeline
cat "$1" |
    convert_newlines_to_spaces |
    convert_spaces_to_newlines |
    separate_left_paren |
    separate_right_paren |
    delete_comments |
    break_up_left_then_right_paren |
    separate_left_paren |
    separate_right_paren |
    skip_empty_lines |
    break_file_into_characters |
    turn_characters_into_ints |
    turn_ints_into_binary |
    prepend_0 |
    convert_lambdas |
    skip_text |
    append_text_to_nonbinary_lines |
    turn_text_nodes_into_ints |
    turn_text_nodes_into_binary |
    prepend_0_to_text_node |
    replace_whitespace_with_00000000 |
    replace_binary_with_int |
    int_to_char |

# if the above code is broken fucking damn it. damn it. dont break above code
#############################################################################
    convert_spaces_to_newlines |
    separate_left_paren |
    separate_right_paren |
    break_up_left_then_right_paren |
    separate_left_paren |
    separate_right_paren |
    skip_empty_lines |
    remove_text |

############################################################
#hopefully this above code isnt broken either fucking hellll
############################################################

    replace_freestanding_vars_and_insert_00 |
    append_text_to_nonbinary_lines |
    append_text_to_1 |
    unappend_text_from_paren_lines |

############################################################
#if this code above breaks it is slightly bad
############################################################

   turn_texts_ints_into_binary #|

###########################################################
#above code easily fixed slightly worried if it breaks
###########################################################

#append_01
#flatten_sexp

    
    



