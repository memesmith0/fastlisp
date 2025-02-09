#!/usr/bin/env python3
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
import sys
import re


x=eval(sys.stdin.read())

def prepend_01(x):
    tree=[]
 #A   this_is_a_lambda=was_lambda
    was_lambda=0

    is_first_node=1
    for node in x:
        if type(node) == list:
            if is_first_node:
                for i in range(len(x)-1):
                    tree.append("01")
            tree.append(prepend_01(node))
            is_first_node=0
        
        elif(is_first_node and node == "lambda"):
            is_first_node=0
            tree.append("00")
#            for i in range(len(x)-2):
#                tree.append("01")

        elif(is_first_node and node !=0):
            is_first_node=0
            for i in range(len(x)-1):
                tree.append("01")
            tree.append(str(node))
        else:
            tree.append(str(node))

    return tree

def flatten(tree):
    items = []
    for item in tree:
        if isinstance(item, list):
            items.extend(flatten(item))
        else:
            items.append(item)
    return items


        

x=prepend_01(x)

x=flatten(x)

x="".join(x)

x="00" + x 

print(x)
