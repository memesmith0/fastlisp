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
#get input file into pipeline
cat "$1" |

    #convert newlines to spaces
    busybox awk '{ printf "%s ", $0 }' |

    #convert spaces to newlines
    busybox awk '{ gsub(/ /, "\n"); print }' |

    #convert ) to \n)\n
    busybox awk '{ gsub(/\)/, "\n)\n"); print; }' |

    #convert ( to \n(\n
    busybox awk '{ gsub(/\(/, "\n(\n"); print; }' |

    #delete contents of comment nodes
    busybox awk '{ printing = 1 } previous_line == "(" && $0 == "comment" { printing = 0, depth = 1 } printing == 0 && $0 == "(" { depth = depth + 1 } printing == 0 && $0 == ")" { depth = depth - 1 } depth == 0 { printing = 1 } printing == 1 { print $0 } { previous_line = $0 }' |

    #break the file up into characters
#    busybox awk '{for (i = 1; i <= length($0); i++) printf "%c\n", substr($0, i, 1)}{printf "\n"}' 

    #hexdump
    busybox xxd -p |

    #break the file up into two character lines
    busybox awk '{for (i = 1; i <= length($0); i=i+2) printf "%c%c\n", substr($0, i, 1), substr($0, i+1,1)}' |

      #convert hex to binary
    busybox awk 'function hex2bin(hex){ if(hex=="0"){return "0000"} if(hex=="1"){return "0001"} if(hex=="2"){return "0010"} if(hex=="3"){return "0011"} if(hex=="4"){return "0100"} if(hex=="5"){return "0101"} if(hex=="6"){return "0110"} if(hex=="7"){return "0111"} if(hex=="8"){return "1000"} if(hex=="9"){return "1001"} if(hex=="a"){return "1010"} if(hex=="b"){return "1011"} if(hex=="c"){return "1100"} if(hex=="d"){return "1101"} if(hex=="e"){return "1110"} if(hex=="f"){return "1111"}} {a=substr($0,0,1); b=substr($0,1,1); printf "%s%s" hex2bin(a), hex2bin(b); print ""}'


#
#    busybox awk '
#{
#
#	is_closing_paren=( $0 == "00101001" );
#	if(is_closing_paren){print "yes"};
#	if($0 == "00101001"){print "yes"};
#
#	if(text_mode){
#
#		    for(i=0; i<8; i++){
#				    foo=substr($0, i, i + 1);
##				    printf "%s%s", "((lambda x (lambda y (lambda z (z x y)))) ", (foo ? " (lambda x (lambda y x)) "  : "(lambda x (lambda y y ))")
#				    bit_counter++;
#		    		    };
#		    }
#	else if(is_closing_paren){
#		print "hellohellohelll0348909385093485039485098";
#		printf "%s%s", "(lambda x (lambda y y))";
#		for(i=0;bitcounter==0; bitcounter--){
#				      printf "%s", ")";
#				      };
#	        printf("\n");
#n
#	}
##	else {print $0};
#
#	{a5=a4; fa4=a3; a3=a2; a2=a1; a1=a0; a0=$0};
########################	if((!is_closing_paren) && a5=="00101000" && a4=="01010100" && a3=="01000101" && a2=="01011000" && a1=="01010100" && a0=="00100000"){text_mode=1;bit_counter=1;print "hello";}

#}
#'


#00101000      "("
#01010100      "T"
#01000101      "E"
#01011000      "X"
#01010100      "T"
#00100000      " "

    








    


    

    #convert text into binary
 #awk '   {
 # char = substr($0, 1, 1);
 # code = sprintf("%d", char);  # Get the ASCII code

 # for (bit_pos = 7; bit_pos >= 0; bit_pos--) {
 #   bit = (code >> bit_pos) & 1;
 #   printf "%d", bit;
 # }
 # printf "\n";
#}'
#    awk '{
#  char = substr($0, 1, 1);
#  for (bit_pos = 7; bit_pos >= 0; bit_pos--) {
#    printf "%d", (char >> bit_pos) & 1;
#  }
#  printf "\n";
#}'
#    busybox awk '{ for(bit_pos = 7; bit_pos >= 0; bit_pos--){ printf "%d", (ascii($0) >> bit_pos) & 1;}}'


    
