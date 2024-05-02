using Flux

net = Chain(
            Dense(2 => 4),
            Dropout(0.4),
            )


trainmode!(net)
net(ones(2, 5))

testmode!(net)
net(ones(2, 5))