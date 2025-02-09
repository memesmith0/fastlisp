#!/usr/bin/sh
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
awk 'substr($0,1,1)!="#"' | #remove_comments
    awk '{gsub(/ /, "\n");gsub(/\(/,"\n(\n");gsub(/\)/,"\n)\n");gsub("\"","\n\"\n"); print}' | #break into words
    awk '{if($0=="\""){t=!t};if(t){if($1=="\""){print}else{for(i=0;i<length($0);i++){printf "%s\n", substr($0,i+1,1)}print ""}}else{print}}' | #break text into letters

   awk 'BEGIN    { _ord_init() }
function _ord_init(    low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7
    if (low == "\a") {    # regular ascii
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
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
    c = substr(str, 1, 1)
    return _ord_[c]
}
function binary(num){
  bin = "0";
  while (num > 0) {
    rem = num % 2;
    bin = rem bin; # Prepend the remainder
    num = int(num / 2); # Integer division is crucial
  }
  print bin;
}
{if($0=="\""){t=!t;print}else if(t){printf "%s", binary(ord($0))}else{print}}' | #convert text to binary
   awk '{if($0=="\""){t=!t;print}else if(t&&($0 == 0)){print "00100000"}else{print}}' | #fix space character to binary
   awk '{if($0=="\""){if(t){printf "000010\""}else{printf "\""};t=!t}else if(t){for(i=0;i<length($0);i++){printf "0100000001011011101100000%s", substr($0,i,1) ? "110":"10"}}else{print}}' | #convert strings to binary lambda calculus
   awk '$0' | #remove newlines
   awk '{

   if($0=="("){
	depth++
	print
   }
   else if($0 == ")"){
      depth--
      for(;lambda_depth>lambda_depths[depth];lambda_depth--){}
   }
   else if(last=="lambda"){
      lambda_depth++
      lambda_depths[depth]=lambda_depth
         stacks[$0,stacks[$0,"counter023948203948320948230958304958340958340958320948203948230948230498320958340958sodifjsodifjosdijf))$$)(J$)("]++]=lambda_depth
	 }
     	 else if($0 != "lambda" && substr($0,1,1) != "\""){
	      for(;lambda_depth < stacks[$0,stacks[$0,"counter023948203948320948230958304958340958340958320948203948230948230498320958340958sodifjsodifjosdijf))$$)(J$)("]];){
	      stacks[$0,"counter023948203948320948230958304958340958340958320948203948230948230498320958340958sodifjsodifjosdijf))$$)(J$)("]--
	      }
	      j=(lambda_depth-stacks[$0,stacks[$0,"counter023948203948320948230958304958340958340958320948203948230948230498320958340958sodifjsodifjosdijf))$$)(J$)("]++]) + 1
	      for(i=0;i<j;i++){printf "1"}printf "0\n"
}
		else{print}last=$0}'  | #replace freestanding vars

   awk '{if($0=="lambda"){}else{print last}last=$0}END{print last}' | # remove extra opening paren
   awk '{if($0=="lambda"){print "00"}else{print}}' | # replace lambda with 00
   awk '{if($0=="("){print "01"}else{print}}'  | #replace opening paren with apply (01)
   awk '{if(substr($0,1,1)!="\""){print}else{for(i=1;i<length($0)-1;i++){printf substr($0,i+1,1)}print ""}}' | #remove quotes from strings
   awk '{printf $0}' #remove newlines
