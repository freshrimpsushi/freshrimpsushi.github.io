using Flux

struct CustomNetwork
    layer1::Dense
    layer2::Dense
    layer3::Dense
    layer4::Dense
end

Flux.@functor CustomNetwork

# forward pass 정의
function (m::CustomNetwork)(x)
    x = m.layer1(x)
    x = m.layer2(x)
    x = m.layer3(x)
    return m.layer4(x)
end

# CustomNetwork 생성
network = CustomNetwork(Dense(2, 10, relu),
                        Dense(10, 10, relu),
                        Dense(10, 10, relu),
                        Dense(10, 1))

# 
x = randn(Float32, 2)
network(x)