# Bash

## Bash FAQ  
**QUESTION**: How do I check that a variable value is a number?  
**ANSWER**: ```if [[ "$_ans" =~ ^[0-9]+$ ]]; then ...``` (Note that the lack of quotes around the expression).  
