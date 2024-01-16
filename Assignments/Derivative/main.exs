
# Define a custom type for numbers and constants.
@type literal() :: {:num, number()}
| {:var, atom()}

# Define a custom type for expressions.
@type expr() :: {:add, expr(), expr()}
| {:mul, expr(), expr()}
| literal()
