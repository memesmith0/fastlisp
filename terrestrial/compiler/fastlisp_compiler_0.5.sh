#!/usr/bin/env sh
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
break_file_to_characters(){ busybox awk '{

if($0 != "(" && $0 != ")") {
      for (i = 1; i <= length($0); i++) printf "%c\n", substr($0, i, 1);
      {printf "\n"}} else{print $0}}' ; } ;

#break the file up into characters
break_file_to_characters_except_text(){ busybox awk '
{
if($0 == "(" || $0 == ")") {
      print $0

}
else if($0=="text"){
     print "text"

}

else{
      for (i = 1; i <= length($0); i++) printf "%c\n", substr($0, i, 1);
      printf "\n"
}      
      }' ; } ;



turn_characters_to_ints(){ busybox awk 'BEGIN    { _ord_init() }

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

turn_ints_to_binary(){ busybox awk '{
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

    }' ; } ;



###this function is intended to wrap fastlisp string data in f
prepare_text(){ busybox awk '{


	if($1=="text:"){
	if(is_text){

	printf "%s", $2
	}
	else{
	is_text=1
	printf "f"
	printf "%s", $2

	}

	}
        else{
	if(is_text){
	is_text=0
	printf "f"

	}
	printf $2


	}

	


}' ; }





convert_lambdas(){ busybox awk '{
for(i=1; i < (length($0) + 1); i++){
	 c=substr($0, i, 1)
	 if(c=="f"){
		i++
		c=substr($0, i, 1)
		for(; c != "f" ;){
 
		       	  printf " ( ( lambda x ( lambda  y ( lambda z ( z x y ) ) ) ) ( lambda x ( lambda y %s ) ) ", ((c == 1)?"x":"y");
			  j++
			  i++
			  c=substr($0, i, 1)
			  }
		printf " ( lambda x ( lambda y y ) )"
		for(; j; j--){printf " ) "}
	        }
	 else{printf "%s", c}
}

}' ; } ;

prepend_text_to_nonbinary_lines(){ busybox awk '{
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

prepend_text_to_binary_lines(){ busybox awk '{
  all_ones_or_zeros = 1;

  for (i = 1; i <= length($0); i++) {
    char = substr($0, i, 1);
    if (char != "0" && char != "1") {
      all_ones_or_zeros = 0; 
      break;
    }
  }

  if (all_ones_or_zeros) {
    printf "text: %s\n", $0;
  }
  else{ print $0 };


}'
				}

turn_text_nodes_to_ints(){ busybox awk 'BEGIN    { _ord_init() }

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


turn_code_nodes_to_ints(){ busybox awk 'BEGIN    { _ord_init() }

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

{if($1 == "code:"){printf "code: %s\n", ord($2)}else{print $0}}

' ; } ;


turn_text_nodes_to_binary(){ busybox awk '{
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

convert_code_nodes_to_binary(){ busybox awk '{
  if($1 == "code:"){
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
  printf "code: %s\n", bin;
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





prepend_0_to_text_node_2(){ busybox awk '{
	  if($0 == "0"){
		  printf "text: 00100000\n"
	 }
	 else{

	
	    if($1 == "text:"){
	    	  printf "text: "


	    	  for(i=(8-length($2)); i > 0; i--){

	    			  printf "%s", 0;
	    
		     }
		     	    printf "%s\n", $2;
			    }

	    else{ print $0 }

	    }



}    '; } ;


prepend_0_to_code_node_2(){ busybox awk '{
	  if($0 == "0"){
		  printf "code: 00100000\n"
	 }
	 else{

	
	    if($1 == "code:"){
	    	  printf "code: "


	    	  for(i=(8-length($2)); i > 0; i--){

	    			  printf "%s", 0;
	    
		     }
		     	    printf "%s\n", $2;
			    }

	    else{ print $0 }

	    }



}    '; } ;

append_0_to_text_node(){

    busybox awk '{

if($1= "text:"){

printf $2"0")

}
else{


}


}'



    }

#todo: this may be a bug in my program. why are some outputs 0 and ohters are ""
replace_whitespace_with_00000000(){ busybox awk '{ if($0 == "" || $0 == "0"){print "00000000"}else{print $0}}' ; } ;



replace_binary_with_int(){ busybox awk '{
  decimal = 0;
  for (i = 1; i <= 8; i++) {
    bit = substr($0, i, 1);
    decimal = decimal * 2 + bit;  # Efficient way to convert
  }
  print decimal;
}' ; } ;

int_to_char(){ busybox awk '{ if($0){printf "%c", $0 }else{printf " "}}' ; } ;

skip_empty_lines(){ busybox awk '{if($0 != ""){ print $0 }}' ; } ;

skip_text(){ convert_newlines_to_spaces | busybox awk '{ gsub(/00101000 01110100 01100101 01111000 01110100 00000000/, ""); print}' | convert_spaces_to_newlines ; } ;


remove_text(){ busybox awk '{
if($1 == "text:"){
for(i=6; i<length($0);i++){
printf "%s",substr($0,(i+1),1)
}
}
else{print $0}
;printf "\n"

}' ; } ;




replace_freestanding_vars2(){ busybox awk 'BEGIN{
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
     	print "lambda"
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
make_python_do_it() {





    busybox awk '{printf "\"%s\"\n", $0}' |

    busybox awk '{

if( $0=="\"(\""){
    print "\n["
}
else if( $0 == "\")\""){

      print "\n]"

}
else{

printf "\n%s\n", $0

}

}' |

    busybox awk '{ gsub(/, ]/, "]"); print }' |
   busybox awk '{ gsub(/\] \[/, "],["); print }' |
   busybox awk '{ gsub(/\] 1/, "],1"); print }' |
   skip_empty_lines | convert_newlines_to_spaces |
   busybox awk '{gsub(/ /, ","); print}' |
   busybox awk '{ gsub(/,\]/, "]"); print }' |
  busybox awk '{ gsub(/\[,/, "["); print }' |
   busybox awk '{ gsub(/\] \[/, "],["); print }' |
   busybox awk '{ gsub(/\] 1/, "],1"); print }' |
   break_file_to_characters |
   convert_newlines_to_spaces |
   busybox awk '{gsub(/ /, ""); print}' |
  busybox awk '{for(i=0; i<(length($0) - 1);i++){
printf "%s", substr($0,(i+1),1)
}
}'
		      

   

}


turn_texts_ints_to_binary(){ busybox awk '{

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

add_newlines_to_binary(){

    busybox awk '{
    was_computing_01=0
    counter=0
    for(i=1; i<(length($0) + 1); i++){
    c=substr($0,i,1)

    if(c == 1 || c ==0){
    	 was_computing_01=1
	 if(counter==8){counter=0}
    	 if(counter==0){printf "\n"}
    	 printf "%s" c
	 counter++
    }
    else{
    if(was_computing_01==1){printf "\n"}
    was_computing_01=0
    counter=0
    printf "%s" c
    }




}



}'

}

prepend_text_to_numerical_lines(){

    busybox awk '{
    if (!($0 !~ /^[+-]?[0-9]+$/)) {
    printf "text: "
      }
      printf $0"\n"

}'

    }
 
add_newlines_between_characters_in_text_nodes (){

    busybox awk '{

#    printf "\n$1 is: %s\n" $1

    if($1 == "text:"){

    	  for(i=7; i<(length($0)+1);i++){

	  	   printf "\n%s", substr($0,i,1)

	  }
	  printf "\n"
    
    }
    else{
	print $0
    }



}'

}

convert_text_nodes_to_binary_2 (){


    busybox awk '{

if($1=="text:"){

	     for(i=$2;i>0;i--){

		printf "1"

		}

		printf "0\n"
}
else{

	printf "%s\n", $0

	}


}'


}


convert_code_nodes_to_binary_2 (){


    busybox awk '{

if($1=="code:"){

	     for(i=$2;i>0;i--){

		printf "1"

		}

		printf "0\n"
}
else{

	printf "%s\n", $0

	}


}'


}


break_text_nodes_into_characters (){

    busybox awk 'BEGIN{text_mode=0}{

    if(text_mode==1){
    if($1== "text:"){print "text:"}
    text_mode=0

    }


    if($1 == "text:"){
    text_mode=1
    for(i=0; i< length($2);i++){

    printf "text: %s\n", substr($2,i+1,1)

    }

    }
    else{
    print $0
    }


   }'


    }

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
    convert_newlines_to_spaces |
    busybox awk '{gsub(/\( text/, "(text"); print; }' |
    convert_spaces_to_newlines |
    busybox awk '{

    	    if($1=="(text"){
		text_mode=1
	    }
	    if($0==")"){

		    if(text_mode){
		    text_mode=0
		    was_end=1
		    }

	    }
	    if(text_mode && $1 != "(text"){
	    printf "text: %s\n", $0

	    }
	    else if( $1 != "(text"){
	    if(was_end==1){
	    	    was_end=0
	    }
	    else{
	    print $0
	    }

	    }
    
    }' |

     break_text_nodes_into_characters |
    turn_text_nodes_to_ints |
    turn_text_nodes_to_binary |
    
    prepend_0_to_text_node_2  |

   busybox awk '{

    if($1 != "text:"){
    for(i=0; i< length($0);i++){
        printf "code: %s\n", substr($0,i+1,1)
    }
    printf "code:\n"
    


    }
else{
	print $0
}


}'   |

   turn_code_nodes_to_ints |
   busybox awk '{if($1=="code:" && $2== "0"){printf "code: %s\n", 32}else{print $0}}' |
convert_code_nodes_to_binary |
prepend_0_to_code_node_2 |


    prepare_text | #convert_newlines_to_spaces
    convert_lambdas |
    add_newlines_to_binary |



    prepend_text_to_nonbinary_lines  |#convert_newlines_to_spaces
    add_newlines_between_characters_in_text_nodes |
    prepend_text_to_nonbinary_lines  |#convert_newlines_to_spaces


    turn_text_nodes_to_ints |
    turn_text_nodes_to_binary |
    prepend_0_to_text_node |
    replace_whitespace_with_00000000 |
    replace_binary_with_int |

 



    int_to_char |


    convert_spaces_to_newlines |
    skip_empty_lines |
    convert_newlines_to_spaces |

    
# if the above code is broken fucking damn it. damn it. dont break above code
#############################################################################
    convert_spaces_to_newlines |
        skip_empty_lines |
   separate_left_paren |
    separate_right_paren |
   break_up_left_then_right_paren |
   separate_left_paren |
   separate_right_paren |
        skip_empty_lines |

##    remove_text |

############################################################
#hopefully this above code isnt broken either fucking hellll
############################################################
	make_python_do_it |
        python3 replace_freestanding_vars.py |
        awk '{gsub(/\[/ , "( "); print}'|
	awk '{gsub(/\]/ , " )"); print}' |
        awk '{gsub(/,/ , " "); print}' |
	awk "{gsub(/'/ , \" \"); print}" |
	convert_spaces_to_newlines |
	skip_empty_lines |
	convert_newlines_to_spaces |

	convert_spaces_to_newlines |

###########################################################
#the code above is meh dont break it pls
###########################################################
    prepend_text_to_numerical_lines |
    

############################################################
#if this code above breaks it is slightly bad
############################################################

   convert_text_nodes_to_binary_2 |
   remove_text |
    skip_empty_lines |
#####    prepend_text_to_binary_lines #|
######    remove_text

#   busybox awk '{if($0 == "\nlambda"){print "00"}else{print $0}}' |


###########################################################
#above code easily fixed slightly worried if it breaks
###########################################################

   make_python_do_it |
############       busybox awk '{ printf "[%s]", $0}' | ######## extra line?

    python3 prepend_01.py

