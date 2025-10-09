using Flux

w = Float32[1 2; 3 4] |> x->reshape(x, 2,2,1,1)
b = zeros(Float32, 1)
convt = ConvTranspose(w, b, relu)
A = Float32[1 2 3; 4 5 6; 7 8 9] |> x->reshape(x, 3, 3, 1, 1)

convt(A)

convt1 = ConvTranspose((2,2), 1=>1, identity)

convt1.weight
convt1.bias