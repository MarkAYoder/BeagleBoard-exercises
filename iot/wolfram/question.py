#!/usr/bin/env python
# From: https://www.javatpoint.com/gui-assistant-using-wolfram-alpha-api-in-python

# importing the wolframalpha module  
import wolframalpha
import os
import sys
  
# defining a function to find answer  
def find_answer(question):  
    """This function will return the answer 
    for the input query from the users"""  
  
    # declaring a variable to store the APP ID  
    app_id = os.getenv('WOLFRAM_APPID')
  
    # creating an object of the Client() class using the APP ID  
    the_client = wolframalpha.Client(app_id)  
  
    # storing the responses from wolfram alpha  
    response = the_client.query(question) 

    # including only the text from the responses  
    return next(response.results).text   
  
# main function  
if __name__ == '__main__':  
    
    if len(sys.argv) <= 1 :
        question = "What is the meaning of life, the universe and everything?"
        print(question)
    else :
        question = sys.argv[1]
  
    # calling the find_answer() function by passing the input question  
    print(find_answer(question)) 
