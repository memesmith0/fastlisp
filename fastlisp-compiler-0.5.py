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

# Read from stdin until EOF
file_content = sys.stdin.read()

def erase_newline(string):
    new_string=""
    for character in string:
        if character != "\n":
            new_string=new_string + character
    return new_string

file_content = erase_newline(file_content)

        
def fastsplit(string):
    split_array=[]
    current_string=""
    for character in string:
        if character == " ":
            split_array.append(current_string)
            current_string=""
        else:
            current_string=current_string + character

    
    return split_array
    


def parse_s_expression(expression):
    def tokenize(expr):
        """Breaks the expression into tokens."""
        return fastsplit(expr.replace('(', ' ( ').replace(')', ' ) '))

    def parse_tokens(tokens):
        """Parses tokens into a tree structure."""
        if not tokens:
            raise ValueError("Unexpected EOF while reading.")

        token = tokens.pop(0)

        if token == '(':
            subtree = []
            while tokens[0] != ')':
                subtree.append(parse_tokens(tokens))
            tokens.pop(0)  # Remove closing ')'
            return subtree
        elif token == ')':
            raise ValueError("Unexpected ')'.")
        else:
            return token

    tokens = tokenize(expression)
    return parse_tokens(tokens)

def remove_empty_strings(tree):
    """Removes empty strings from a tree (list of lists), except within 'text' nodes.

    Args:
        tree: The tree (list of lists) to process.

    Returns:
        A new tree with empty strings removed, or the original tree if no changes were made.
        Returns None if the input is not a list.
    """

    if not isinstance(tree, list):
        return None  # Handle invalid input

    new_tree = []  # Create a new tree to avoid modifying the original
    modified = False  # Flag to track if any modifications were made

    for item in tree:
        if isinstance(item, list):
            if item and item[0] == "text":  # Keep empty strings within 'text' nodes
                new_tree.append(item)
            else:
                sub_tree = remove_empty_strings(item)
                if sub_tree is not None:
                    new_tree.append(sub_tree)
                    if sub_tree != item: #check for changes
                        modified = True
        elif item != "":  # Remove empty strings elsewhere
            new_tree.append(item)
            modified = True


    if modified:  # Return the modified tree only if changes were made
        return new_tree
    else:
        return tree # Return the original if no changes were needed.



def omit_after_lambda(tree):
    if not isinstance(tree, list):  # Base case: if it's not a list, return it as-is
        return tree
    
    result = []
    skip_next = False  # Flag to skip the element following "lambda"

    for elem in tree:
        if skip_next:
            skip_next = False
            continue
        if elem == "lambda":
            result.append(elem)  # Keep "lambda"
            skip_next = True
        else:
            # Recursively process elements if they are lists
            result.append(omit_after_lambda(elem))
    
    return result


def replace_lambda(data):
    if isinstance(data, list):  # Check if the element is a list
        return [replace_lambda(item) for item in data]  # Recursively process each element in the list
    elif data == "lambda":  # Check if the element is "lambda"
        return "00"  # Replace "lambda" with "00"
    else:
        return data  # Return the element unchanged if it's not "lambda"


def prepend_to_arrays(data, is_outer=False):
    if isinstance(data, list):
        # Check if the list is an array of integers
        if all(isinstance(x, int) for x in data):
            return ["01"] * len(data) + data

        result = []
        for idx, item in enumerate(data):
            if idx == 0 and item == "00" and not is_outer:
                # Add "01" immediately after the first "00" in non-outer lists
                result.append("00")
                result.append("01")
            elif isinstance(item, list):
                # Recursively process nested lists
                result.append(prepend_to_arrays(item))
            else:
                result.append(item)
        return result
    return data  # Return non-list items unchanged


def process_outer_list(data):
    # Prepend "01" to the outermost list while processing its elements
    if isinstance(data, list):
        processed = []
        for item in data:
            if isinstance(item, list):
                processed.append(prepend_to_arrays(item, is_outer=True))
            else:
                processed.append(item)
        return ["01", processed]
    return data
def replace_integers_with_ones(array):
    # Iterate over the elements in the array
    for i in range(len(array)):
        if isinstance(array[i], list):  # If the element is a list, recurse into it
            replace_integers_with_ones(array[i])
        elif isinstance(array[i], int):  # If the element is an integer, replace it
            array[i] = "1" * array[i]

def append_zero_to_ones(data):
    if isinstance(data, list):
        # Recursively process each item in the list
        return [append_zero_to_ones(item) for item in data]
    elif isinstance(data, str) and all(char == '1' for char in data):
        # Append '0' if the string contains only '1'
        return data + '0'
    else:
        # Return the item as is
        return data

def flatten_and_convert_to_string(nested_array):
    result = []
    
    def flatten(array):
        for element in array:
            if isinstance(element, list):
                flatten(element)
            else:
                result.append(element)
    
    flatten(nested_array)
    return ''.join(result)



def replace_integers_with_ones(array):
    for i in range(len(array)):
        if isinstance(array[i], list):  # If the element is a list, recurse into it
            array[i] = replace_integers_with_ones(array[i])
        elif isinstance(array[i], int):  # If the element is an integer, replace it
            array[i] = "1" * array[i]
    return array  # Return the modified array


def parse_s_expression(expression):
    def tokenize(expr):
        """Breaks the expression into tokens."""
        return fastsplit(expr.replace('(', ' ( ').replace(')', ' ) '))

    def parse_tokens(tokens):
        """Parses tokens into a tree structure."""
        if not tokens:
            raise ValueError("Unexpected EOF while reading.")

        token = tokens.pop(0)

        if token == '(':
            subtree = []
            while tokens[0] != ')':
                subtree.append(parse_tokens(tokens))
            tokens.pop(0)  # Remove closing ')'
            return subtree
        elif token == ')':
            raise ValueError("Unexpected ')'.")
        else:
            return token

    tokens = tokenize(expression)
    result = []
    while tokens:
        result.append(parse_tokens(tokens))
    return result

def flatten_text_nodes(tree):
    if isinstance(tree, list):
        # If the list starts with "text", flatten its contents into a single string
        if tree[0] == "text":
            return ["text", " ".join(map(str, tree[1:]))]
        else:
            # Otherwise, recursively process each child
            return [flatten_text_nodes(child) for child in tree]
    return tree  # Return non-list elements as is


def string_to_binary(s):
    """Convert a string to its binary representation."""
    return ''.join(format(ord(char), '08b') for char in s)

def transform_tree_string_to_binary(tree):
    """
    Recursively traverse the tree and convert strings following 'text'
    to their binary representation.
    """
    if isinstance(tree, list):
        if len(tree) == 2 and tree[0] == 'text' and isinstance(tree[1], str):
            return ['text', string_to_binary(tree[1])]
        return [transform_tree_string_to_binary(subtree) for subtree in tree]
    return tree

def process_binary(binary_str):
    result = ""
    for bit in binary_str:
        if bit == "0":
            result += "((lambda x (lambda y (lambda z (z x y)))) (lambda x (lambda y x))"
        elif bit == "1":
            result += "((lambda x (lambda y (lambda z (z x y)))) (lambda x (lambda y y))"
    result += ")" * len(binary_str)  # Append the right parentheses
    return result

def transform_tree_binary_to_lambda(tree):
    if isinstance(tree, list):
        # Check if the first element is "text" and the second is a binary string
        if tree[0] == "text" and isinstance(tree[1], str) and all(bit in "01" for bit in tree[1]):
            transformed_text = process_binary(tree[1])
            return [tree[0], transformed_text]  # Replace the binary string with the transformed string
        else:
            # Recursively process each element of the list
            return [transform_tree_binary_to_lambda(subtree) for subtree in tree]
    return tree  # If it's not a list, return it as is

def unprepend_text(arr):
    if isinstance(arr, list):
        # Check if the array begins with "text"
        if len(arr) > 0 and arr[0] == "text":
            return arr[1:]  # Return the array without "text"
        else:
            # Recursively process each element
            return [unprepend_text(item) for item in arr]
    return arr  # Return non-list elements as-is

def transform_tree_parse_s_expression(array):
    for i, item in enumerate(array):
        if isinstance(item, list):  # Recursively process nested arrays
            array[i] = transform_tree_parse_s_expression(item)
        elif isinstance(item, str) and i > 0 and array[i-1] == "text":
            # Replace the string with the parsed result
            array[i] = parse_s_expression(item)
    return array

def process_binary2(binary_str):
    result = ""
    for bit in binary_str:
        if bit == "0":
            result += "((lambda x (lambda y (lambda z (z x y)))) (lambda x (lambda y x))"
        elif bit == "1":
            result += "((lambda x (lambda y (lambda z (z x y)))) (lambda x (lambda y y))"
    result += "(lambda x (lambda y y))"  # Append the additional lambda expression
    result += ")" * (len(binary_str))  # Append the right parentheses
    return result

def transform_tree(tree):
    if isinstance(tree, list):
        # Check if the first element is "text" and the second is a binary string
        if tree[0] == "text" and isinstance(tree[1], str) and all(bit in "01" for bit in tree[1]):
            transformed_text = process_binary2(tree[1])  # Transform the binary string
            return [tree[0], transformed_text]  # Replace the binary string with the transformed string
        else:
            # Recursively process each element of the list
            return [transform_tree(subtree) for subtree in tree]
    return tree  # If it's not a list, return it as is


def insert_01(data):
    # Check if the input is a list
    if isinstance(data, list):
        # Check if the first element is '00' and the list has more than 2 elements
        if len(data) > 1 and data[0] == '00':
            # Insert a list of '01' with length len(data) - 2 after the first element
            data.insert(1, ['01'] * (len(data) - 2))
        # Recursively apply the function to each element in the list
        for i in range(len(data)):
            insert_01(data[i])
    return data

def insert_01(data):
    # Check if the input is a list
    if isinstance(data, list):
        # Check if the list starts with '00' and has more than 2 elements
        if len(data) > 2 and data[0] == '00':
            # Insert '01' elements directly into the list after the first element
            num_of_01 = len(data) - 2
            data[1:1] = ['01'] * num_of_01  # Splice the '01' elements directly
        # Recursively process each element in the list
        for i in range(len(data)):
            insert_01(data[i])
    return data
def insert_more_01(tree, depth=0):
    updated_tree = []
    for item in tree:
        if isinstance(item, list):
            if len(item) > 0 and item[0] != '00':
                # Create a list of '01' with length depth + 1
                prefix = ['01'] * (depth + 1)
                # Prepend the prefix to the current list, but do not process further
                updated_tree.append(prefix + item)
            else:
                # Recursively process children if it starts with '00'
                updated_tree.append([item[0]] + insert_more_01(item[1:], depth + 1))
        else:
            # Keep non-list items as they are
            updated_tree.append(item)
    return updated_tree
def prepend_01_to_arrays(tree):
    def process(subtree):
        # If the subtree is a list of lists
        if all(isinstance(item, list) for item in subtree):
            # Calculate the number of '01' to prepend
            num_01 = len(subtree) - 1
            # Prepend '01' elements to the subtree
            return ['01'] * num_01 + [process(item) for item in subtree]
        elif isinstance(subtree, list):
            # Recur for each item in the list
            return [process(item) for item in subtree]
        return subtree  # Return non-list items as is

    return process(tree)
def insert_more_01(tree, depth=0):
    updated_tree = []
    for item in tree:
        if isinstance(item, list):
            prefix = ['01'] * depth
            updated_tree.append(prefix + insert_more_01(item, depth + 1))  # Corrected recursion
        else:
            updated_tree.append(item)
    return updated_tree
def insert_more_01(tree, depth=0):
    updated_tree = []
    for item in tree:
        if isinstance(item, list):
            if len(item) > 0 and item[0] == '00':  # Only increment depth for lambda abstractions
                updated_tree.append(['00'] + insert_more_01(item[1:], depth + 1))  # Corrected recursion
            else:
                prefix = ['01'] * depth
                updated_tree.append(prefix + insert_more_01(item, depth)) # Corrected prefixing
        else:
            updated_tree.append(item)
    return updated_tree
def insert_more_01(tree, depth=0):
    """
    Inserts '01' prefixes into the tree based on the depth of lambda abstractions.

    Args:
        tree: The input tree (list) representing the Fastlisp expression.
        depth: The current depth of lambda nesting.

    Returns:
        The modified tree with '01' prefixes inserted.
    """
    updated_tree = []
    for item in tree:
        if isinstance(item, list):
            if len(item) > 0 and item[0] == '00':  # Only increment depth for lambda abstractions
                updated_tree.append(['00'] + insert_more_01(item[1:], depth + 1))
            else:
                prefix = ['01'] * depth
                updated_tree.append(prefix + insert_more_01(item, depth))
        else:
            updated_tree.append(item)
    return updated_tree
def insert_more_01(tree, depth=0):
  """
  Inserts '01' prefixes into the tree based on the depth of lambda abstractions.

  Args:
    tree: The input tree (list) representing the Fastlisp expression.
    depth: The current depth of lambda nesting.

  Returns:
    The modified tree with '01' prefixes inserted.
  """
  updated_tree = []
  for item in tree:
    if isinstance(item, list):
      if len(item) > 0 and item[0] == '00':  # Only increment depth for lambda abstractions
        updated_tree.append(['00'] + insert_more_01(item[1:], depth + 1))
      else:
        prefix = ['01'] * depth
        updated_tree.append(prefix + insert_more_01(item, depth))  # Corrected prefixing
    else:
      updated_tree.append(item)
  return updated_tree
def insert_more_01(tree, depth=0):
    """
    Inserts '01' prefixes into the tree based on the depth of lambda abstractions.

    Args:
        tree: The input tree (list) representing the Fastlisp expression.
        depth: The current depth of lambda nesting.

    Returns:
        The modified tree with '01' prefixes inserted.
    """
    updated_tree = []
    for item in tree:
        if isinstance(item, list):
            if item and item[0] == '00':  # Lambda abstraction
                updated_tree.append(['00'] + insert_more_01(item[1:], depth + 1))
            else:  # Application
                prefix = ['01'] * depth
                updated_tree.append(prefix + insert_more_01(item, depth))
        else:
            updated_tree.append(item)
    return updated_tree
def prepend_01_to_arrays(tree):
    """
    Prepends '01' to arrays within a tree structure based on their length.

    Args:
        tree: The input tree (nested lists).

    Returns:
        The modified tree with '01' prepended to arrays.
    """

    def process_subtree(subtree):
        if isinstance(subtree, list):
            if subtree and subtree[0] == '00':  # Skip arrays starting with '00' at this level
                return ['00'] + [process_subtree(item) for item in subtree[1:]] # recursively process the rest of the list
            else:
                num_01 = len(subtree) - 1
                if num_01 > 0:
                    return ['01'] * num_01 + [process_subtree(item) for item in subtree]
                else:
                    return [process_subtree(item) for item in subtree]  # Still process nested lists even if num_01 = 0
        else:
            return subtree  # Return non-list items as is

    return process_subtree(tree)

def insert_01_after_00(tree):
    """
    Inserts '01' elements after '00' in arrays within a tree structure.

    Args:
        tree: The input tree (nested lists).

    Returns:
        The modified tree.
    """
    def process_subtree(subtree):
        if isinstance(subtree, list):
            if subtree and subtree[0] == '00' and len(subtree) > 2:
                num_01 = len(subtree) - 2  # Number of elements after '00' minus 1
                return ['00'] + ['01'] * num_01 + [process_subtree(item) for item in subtree[1:]] #Insert 01's and process the rest
            else:
                return [process_subtree(item) for item in subtree]
        else:
            return subtree

    return process_subtree(tree)
def remove_empty_strings_from_all(temp):
    new_list=[]
    for item in temp:
        if type(item) == list:
            new_list.append(remove_empty_strings_from_all(item))
        else:
            if item != "":
                new_list.append(item)
    return new_list
                
def apply_function_until_stable(func, arr):
    """Applies a function to an array repeatedly until the output stabilizes.

    Args:
        func: The function to apply to the array.
        arr: The initial array.

    Returns:
        The final, stable array.  Returns the original array if the function
        doesn't change it on the first application.  Returns None if the function
        appears to oscillate between two values (to prevent infinite loops).
    """

    previous_result = arr[:]  # Create a copy to avoid modifying the original
    current_result = func(arr)

    if current_result == previous_result:
        return current_result

    seen_results = {tuple(previous_result): True} #Keep track of seen results to detect oscillations

    while current_result != previous_result:
        if tuple(current_result) in seen_results: #Check for oscillation
            return None #Return None to indicate that the function oscillates.
        seen_results[tuple(current_result)] = True
        previous_result = current_result[:]  # Important: copy the list!
        current_result = func(current_result)

    return current_result

def omit_after_lambda(tree):
    if not isinstance(tree, list):  # Base case: if it's not a list, return it as-is
        return tree
    
    result = []
    skip_next = False  # Flag to skip the element following "lambda"

    for elem in tree:
        if skip_next:
            skip_next = False
            continue
        if elem == "lambda":
            result.append(elem)  # Keep "lambda"
            skip_next = True
        else:
            # Recursively process elements if they are lists
            result.append(omit_after_lambda(elem))
    
    return result

class KeyValueStore:
    def __init__(self):
        self.store = {}

    def set(self, key, value):
        self.store[key] = value

    def get(self, key):
        return self.store.get(key, None)

    def delete(self, key):
        if key in self.store:
            del self.store[key]

    def exists(self, key):
        return key in self.store


#todo: rewrite this function so that if the lambda depth is less than the most recent depth in the depth tracker object
#then go to an earlier depth in the depth tracker
def replace_freestanding_vars(tree, lambda_depth_counter, depth_tracker_object):
    #replace variable and function names with the location they were defined at in the lambda tree
    new_tree=[]
    last_one_was_lambda=0
    is_in_a_lambda=0
    lambda_name=""

    for node in tree:
        
        #if the node is another branch in the tree
        if type(node) == list:

            #process that branch
            new_tree.append(replace_freestanding_vars(node,lambda_depth_counter, depth_tracker_object))

        #If a node is not another branch in the tree
        else:

            
            #if the node is the beginning of a lambda
            if(node == 'lambda'):
                #rename lambda to '00'
                last_one_was_lambda = 1
                is_in_a_lambda=1
                new_tree.append('00')

            #if the node is a lambda name
            elif(last_one_was_lambda):

                #track the depth of that name
                last_one_was_lambda = 0
                lambda_name=node
#                print(lambda_name)
                if(type(depth_tracker_object[0].get(node)) != list):
                   depth_tracker_object[0].set(node,[])
                lambda_depth_counter[0]=lambda_depth_counter[0] + 1
 #               print(depth_tracker_object[0].get(node))
                depth_tracker_object[0].get(node).append(lambda_depth_counter[0])
 #              print(depth_tracker_object[0].get(node))


                   #if the node is a function
            else:
                new_tree.append((lambda_depth_counter[0]-depth_tracker_object[0].get(node)[-1]) + 1)
                
    if is_in_a_lambda==1:
        depth_tracker_object[0].get(lambda_name).pop()
        lambda_depth_counter[0]=lambda_depth_counter[0]-1
        
    return new_tree

def remove_comments(tree):
    new_tree=[]
    for node in tree:
        if type(node) == list:
            if(node[0]!="comment"):
                new_tree.append(remove_comments(node))
        else:
            new_tree.append(node)

    return new_tree
            
                


def compile(source):
    
    temp=source
    temp=parse_s_expression(temp)
    temp=remove_empty_strings(temp)
    temp=remove_comments(temp)
    temp=flatten_text_nodes(temp)
    temp=transform_tree_string_to_binary(temp)
    temp=transform_tree(temp)
    temp=transform_tree_parse_s_expression(temp)
    temp=unprepend_text(temp)
    temp=remove_empty_strings_from_all(temp)
    temp=replace_freestanding_vars(temp,[0],[KeyValueStore()])
    temp=prepend_01_to_arrays(temp)
    temp=insert_01_after_00(temp)
    temp=replace_integers_with_ones(temp)
    temp=append_zero_to_ones(temp)
    ##temp=prepend_01_to_arrays(temp)
    temp=flatten_and_convert_to_string(temp)

    return temp


print((compile(file_content)))

