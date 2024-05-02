using Zygote

p(x) = 2x^2 + 3x + 1

p(2)
p'(2)
p''(2)

g(x,y) = 3x^2 + 2y + x*y
gradient(g, 2,-1)

∇(f, v...) = gradient(f, v...)
∇(g, 2, -1)

f(x) = [x, x^2, x^3]
gradient(f, 1)

jacobian(f, 2)

f₂(x) = (x, x^2, x^3)
jacobian(f₂, 2)

F(x, y) = [x^2, x*y, y^3]
J = jacobian(F, 1, 2)

stack(J[i] for i ∈ 1:2)
