# BNF Calculator

## Design Decisions

This project implements a basic calculator using BNF to define grammar rules for arithmetic expressions. It supports variables, floating-point numbers, and exponentiation also negative numbers which wasn't in the grammar originally. The implementation is structured as follows:

- **Lexical Analysis (Flex):**
  - Tokenizes identifiers, numbers (including floating point), and arithmetic operators.
  - Ignores whitespace and handles unknown characters gracefully.
- **Parsing (Bison):**
  - Implements grammar rules for arithmetic expressions.
  - Supports variable assignment and retrieval.
  - Defines operator precedence and associativity.
- **Symbol Table:**
  - Uses a simple array to store variable names and their values.
  - Supports lookups and updates for identifiers.

## Steps Taken to Implement the Solution

1. **Defined Grammar:**
   - Specified precedence and associativity of arithmetic operators (`+`, `-`, `*`, `/`, `^|**`).
   - Supported parentheses for grouping expressions.
   - Added variable assignments.
2. **Lexical Analysis:**
   - atoi and atof used for extracting literal values from stdin strings.
   - I have used Flex to define tokens for numbers, identifiers, and operators.
   - Allowed floating-point numbers by modifying regex patterns and exponentials to get bonus part.
4. **Parsing with Bison:**
   - Defined grammar rules in BNF notation given in homework document.
   - Implemented error handling for division by zero and wrongly written grammar issues.
5. **Symbol Table Implementation:**
   - Used a struct array to manage variable names and values.
   - Implemented `lookup_symbol` and `update_symbol` functions for efficient variable handling.
6. **Expression Evaluation:**
   - Performed arithmetic operations based on the grammar rules asked me to implement in hmw document.
   - Used `pow()` from Math lib for exponentiation operation.

## How to Run the Code

### Prerequisites
- You have to ensure that the `flex|lex` and `bison|yacc` are installed on your system.

### Compilation Steps(for lex&&yacc)
```bash
yacc -d calculator.y    # Generate yac parser
lex calculator.l        # Generate lexer
gcc lex.yy.c calculator.tab.c -o calculator  # Compile with math library (if this step do not work try with lm like-> gcc -o calculator calculator.tab.c lex.yy.c -lm)
```

### Running the Calculator
```bash
./calculator
```
Enter expressions like:
```plaintext
//some test cases that I wrote:
23  +6-1 = 28
22* (    3+7   ) = 73
-12.12-32.3*4^0.1 = -49.20
(2 ^ (2 * (2 + 2 / 2 - (0-5)))) = 65536
21/(16    -2** 4) =  Hata: Divided by zero exception. Cevap: INF
90**2- = Syntax Error
```
The program will evaluate expressions and print the result.

## Error Handling
- **Unknown Characters:** Prints a warning Syntax error message.
- **Division by Zero:** Displays an Division by zero error message and gives INF.
- **Undefined Variables:** Returns `0` if a variable is not found. Such as regular keyboard characthers (a,b,c vs.)

This BNF-based calculator provides a simple yet powerful implementation of arithmetic expressions with variables and floating-point support.

