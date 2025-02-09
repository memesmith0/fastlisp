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

#THIS SOFTWARE.
import sys
import re


x=sys.stdin.read()
x=eval(x)

def replace_freestanding_vars(x, lambda_depth, name_dict):
    
    tree=[]

    last_node_was_lambda=0
    am_in_lambda_node=0
    lambda_node_name=""
    for node in x:
        if type(node) == list:
            tree.append(replace_freestanding_vars(node, lambda_depth, name_dict))
        elif node=="lambda" :
            tree.append("lambda")
            lambda_depth=lambda_depth+1
            last_node_was_lambda=1
            am_in_lambda_node=1
        elif last_node_was_lambda:
            lambda_node_name=node
            if not (node in name_dict):
                name_dict[node] = []

 
            name_dict[node].append(lambda_depth)
            last_node_was_lambda=0

            
        else:

            ########where should we be adding or substracting 1???
            tree.append((lambda_depth - name_dict[node][-1]) + 1)

            
    if(am_in_lambda_node):
        name_dict[lambda_node_name].pop()
    
    return tree


def flatten(tree):
    items = []
    for item in tree:
        if isinstance(item, list):
            items.extend(flatten(item))
        else:
            items.append(item)
    return items


        

x=replace_freestanding_vars(x,0,{})

#x=flatten(x)

#x="".join(x)

print(x)
