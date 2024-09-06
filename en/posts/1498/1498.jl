# 이원수 구조체 정의
struct Dual 
    v::Float64 # (function) value
    d::Float64 # derivative
end

x = Dual(3, 1)
y = Dual(2, 0)

# 이원수의 덧셈 정의
x + y

methods(+)

Base.:+(x::Dual, y::Dual) = Dual(x.v + y.v, x.d + y.d)
methods(+)

x + y

# 이원수의 곱셈 정의
Base.:*(x::Dual, y::Dual) = Dual(x.v*y.v, x.v*y.d + x.d*y.v)
x * y

# 이원수 위의 함수 정의
Base.sin(x::Dual) = Dual(sin(x.v), x.d * cos(x.v) )
Base.log(x::Dual) = Dual(log(x.v), x.d / x.v)

# 전진모드 계산
y₁ = x*x
y₂ = sin(x)
y₃ = y₁ + y₂
y₄ = log(y₃)

log(3^2 + sin(3))
(2*3 + cos(3)) / (3^2 + sin(3))