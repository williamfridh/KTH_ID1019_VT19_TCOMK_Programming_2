# 2x+3 >> 3
Derivative.test({:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, :x)

#2x^2+3x+5 >> 4x+3
Derivative.test({:add, {:add, {:mul, {:num, 2}, {:mul, {:var, :x}, {:var, :x}}}, {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}, :x)

#2x^3+3x+5 >> 6x^2+3
Derivative.test({:add, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 3}}}, {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}, :x)

#(3x)^2 >> 18x
Derivative.test({:exp, {:mul, {:num, 3}, {:var, :x}}, {:num, 2}}, :x)

#2x^2+4x+5 >> 4x + 4
Derivative.test({:add, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:mul, {:num, 4}, {:var, :x}}}, {:num, 5}}, :x)

#3^2 >> 9
Derivative.test({:exp, {:num, 3}, {:num, 2}}, :x)

#(5x)^2 >> 50x
Derivative.test({:exp, {:mul, {:num, 5}, {:var, :x}}, {:num, 2}}, :x)

#(5+x)^2 >> 2x + 10
Derivative.test({:exp, {:add, {:num, 5}, {:var, :x}}, {:num, 2}}, :x)

#ln(5x) >> 1/x
Derivative.test({:ln, {:mul, {:num, 5}, {:var, :x}}}, :x)

#ln(5+x) >> 1/(5+x)
Derivative.test({:ln, {:add, {:num, 5}, {:var, :x}}}, :x)

#1/x >> -1/x^2
Derivative.test({:div, {:num, 1}, {:var, :x}}, :x)

#1/2 >> 0
Derivative.test({:div, {:num, 1}, {:num, 2}}, :x)

#(5x)/(x+3)
Derivative.test({:div, {:mul, {:num, 5}, {:var, :x}}, {:add, {:var, :x}, {:num, 3}}}, :x)

#sqrt(x) >> 1/(2sqrt(x))
Derivative.test({:sqrt, {:var, :x}}, :x)

#sqrt(x+5) >> 1/(2sqrt(x+5))
Derivative.test({:sqrt, {:add, {:var, :x}, {:num, 5}}}, :x)

#sqrt(x^2) >> x/sqrt(x)
Derivative.test({:sqrt, {:exp, {:var, :x}, {:num, 2}}}, :x)

#sqrt(10) >> 0
Derivative.test({:sqrt, {:num, 10}}, :x)

#sin(x) >> cos(x)
Derivative.test({:sin, {:var, :x}}, :x)

#sin(x^2) >> 2x*cos(x)
Derivative.test({:sin, {:exp, {:var, :x}, {:num, 2}}}, :x)

#1/sin(x) >> -cos(x)/sin^2(x)
Derivative.test({:div, {:num, 1}, {:sin, {:var, :x}}}, :x)

#1/sin(2x) >> (-2cos(2x))/(sin(2x))^2
Derivative.test({:div, {:num, 1}, {:sin, {:mul, {:num, 2}, {:var, :x}}}}, :x)
