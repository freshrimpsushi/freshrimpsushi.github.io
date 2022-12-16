using Flux

A = ones(Float32, 572, 572, 1, 1)

Unet = Chain(conv1_1 = Flux.Conv((3,3), 1=>64, relu, pad=0),
             conv1_2 = Flux.Conv((3,3), 64=>64, relu, pad=0),
             maxpool1to2 = Flux.MaxPool((2,2)),
             #2nd layer
             conv2_1 = Flux.Conv((3,3), 64=>128, relu, pad=0),
             conv2_2 = Flux.Conv((3,3), 128=>128, relu, pad=0),
             maxpool2to3 = Flux.MaxPool((2,2)),
             #3rd layer
             conv3_1 = Flux.Conv((3,3), 128=>256, relu, pad=0),
             conv3_2 = Flux.Conv((3,3), 256=>256, relu, pad=0),
             maxpool3to4 = Flux.MaxPool((2,2)),
             #4th layer
             conv4_1 = Flux.Conv((3,3), 256=>512, relu, pad=0),
             conv4_2 = Flux.Conv((3,3), 512=>512, relu, pad=0),
             maxpool4to5 = Flux.MaxPool((2,2)),
             #5th layrt
             conv5_1 = Flux.Conv((3,3), 512=>1024, relu, pad=0),
             conv5_2 = Flux.Conv((3,3), 1024=>1024, relu, pad=0),
             transconv5to4 = Flux.ConvTranspose((2,2), 1024=>1024, relu, stride=2),
             #4th layer
             conv4_3 = Flux.Conv((3,3), 1024=>512, relu, pad=0),
             conv4_4 = Flux.Conv((3,3), 512=>512, relu, pad=0),
             transconv4to3 = Flux.ConvTranspose((2,2), 512=>512, relu, stride=2),
             #3rd layer
             conv3_3 = Flux.Conv((3,3), 512=>256, relu, pad=0),
             conv3_4 = Flux.Conv((3,3), 256=>256, relu, pad=0),
             transconv3to2 = Flux.ConvTranspose((2,2), 256=>256, relu, stride=2),
             #2nd layer
             conv2_3 = Flux.Conv((3,3), 256=>128, relu, pad=0),
             conv2_4 = Flux.Conv((3,3), 128=>128, relu, pad=0),
             transconv2to1 = Flux.ConvTranspose((2,2), 128=>128, relu, stride=2),
             #1st layer
             conv1_3 = Flux.Conv((3,3), 128=>64, relu, pad=0),
             conv1_4 = Flux.Conv((3,3), 64=>64, relu, pad=0),
             conv1_5 = Flux.Conv((1,1), 64=>1, relu, pad=0),
)

Unet(A)




begin
    S = Flux.Conv((3,3), 1=>64, relu)(A)
    S = Flux.Conv((3,3), 64=>64, relu)(S)
    S = Flux.MaxPool((2,2))(S)
    S = Flux.Conv((3,3), 64=>128, relu)(S)
    S = Flux.Conv((3,3), 128=>128, relu)(S)
    S = Flux.MaxPool((2,2))(S)
    S = Flux.Conv((3,3), 128=>256, relu)(S)
    S = Flux.Conv((3,3), 256=>256, relu)(S)
    S = Flux.MaxPool((2,2))(S)
    S = Flux.Conv((3,3), 256=>512, relu)(S)
    S = Flux.Conv((3,3), 512=>512, relu)(S)
    S = Flux.MaxPool((2,2))(S)
    S = Flux.Conv((3,3), 512=>1024, relu)(S)
    Flux.Conv((3,3), 1024=>1024, relu)(S)
end