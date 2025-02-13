#!/bin/sh
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


sequential_pipe(){ pipe="$( printf "$pipe" | awk "$1" )" ; } ;
sequential_awk(){ for j in "$@"; do sequential_pipe "$j" ; done ; } ;


pipe="$(awk '{printf "%s", $0 RS}' /dev/stdin)"

sequential_awk 'substr($0,1,1)!="#"' #remove comments
sequential_awk '{gsub(/ /, "\n");gsub(/\(/,"\n(\n");gsub(/\)/,"\n)\n");gsub("\"","\n\"\n"); print}' #break into words
sequential_awk '{if($0=="\""){t=!t};if(t){if($1=="\""){print}else{for(i=0;i<length($0);i++){printf "%s\n", substr($0,i+1,1)}print ""}}else{print}}' #break text into letters
sequential_awk 'BEGIN{ _ord_init() } function _ord_init(low, high, i, t){ low = sprintf("%c", 7) ; if (low == "\a"){  low = 0 ;high = 127 } else if(sprintf("%c", 128 + 7) == "\a"){low = 128;high = 255}else{low = 0;high = 255}; for (i = low; i <= high; i++) { t = sprintf("%c", i) ; _ord_[t] = i } } function ord(str,    c){ c = substr(str, 1, 1) ; return _ord_[c] } function binary(num){ bin = "0"; while (num > 0) { rem = num % 2; bin = rem bin; num = int(num / 2); } print bin; } {if($0=="\""){t=!t;print}else if(t){printf "%s", binary(ord($0))}else{print}}' #convert text to binary
sequential_awk '{if($0=="\""){t=!t;print}else if(t&&($0 == 0)){print "00100000"}else{print}}' #fix space character to binary
sequential_awk '{if($0=="\""){if(t){printf "000010\""}else{printf "\""};t=!t}else if(t){for(i=0;i<length($0);i++){printf "0100000001011011101100000%s", substr($0,i,1) ? "110":"10"}}else{print}}' #convert strings to binary lambda calculus
sequential_awk '$0' #remove newlines



printf "$pipe"
 
