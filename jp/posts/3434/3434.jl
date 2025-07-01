using Flux

function conv_block(in_ch, out_ch)
    return Chain(
        Conv((3,3), in_ch=>out_ch, relu, pad=0),
        Conv((3,3), out_ch=>out_ch, relu, pad=0),
    )
end

struct UNet
    encoder1; encoder2; encoder3; encoder4
    bottleneck
    decoder1; decoder2; decoder3; decoder4
end

Flux.@functor UNet

function (m::UNet)(x)
    enc1 = m.encoder1(x)
    enc2 = m.encoder2(enc1)
    enc3 = m.encoder3(enc2)
    enc4 = m.encoder4(enc3)

    bn = m.bottleneck(enc4)

    dec1_in = cat(bn, enc4[1+4:end-4, 1+4:end-4, :, :], dims=3)
    dec1 = m.decoder1(dec1_in)
    dec2_in = cat(dec1, enc3[1+16:end-16, 1+16:end-16, :, :], dims=3)
    dec2 = m.decoder2(dec2_in)
    dec3_in = cat(dec2, enc2[1+40:end-40, 1+40:end-40, :, :], dims=3)
    dec3 = m.decoder3(dec3_in)
    dec4_in = cat(dec3, enc1[1+88:end-88, 1+88:end-88, :, :], dims=3)
    dec4 = m.decoder4(dec4_in)

    return dec4
end

encoder1 = conv_block(1, 64)
encoder2 = Chain(MaxPool((2,2)), conv_block(64, 128))
encoder3 = Chain(MaxPool((2,2)), conv_block(128, 256))
encoder4 = Chain(MaxPool((2,2)), conv_block(256, 512))

bottleneck = Chain(MaxPool((2,2)), conv_block(512, 1024), ConvTranspose((2,2), 1024=>512, relu, stride=2))

decoder1 = Chain(conv_block(1024, 512), ConvTranspose((2,2), 512=>256, relu, stride=2))
decoder2 = Chain(conv_block(512, 256), ConvTranspose((2,2), 256=>128, relu, stride=2))
decoder3 = Chain(conv_block(256, 128), ConvTranspose((2,2), 128=>64, relu, stride=2))
decoder4 = Chain(conv_block(128, 64), Conv((1,1), 64=>2, relu, pad=0))

unet = UNet(encoder1, encoder2, encoder3, encoder4, bottleneck, decoder1, decoder2, decoder3, decoder4)

x = randn(Float32, 572, 572, 1, 1)
unet(x)


# A = ones(Float32, 572, 572, 1, 1)

# function Unet(x)
#     y₁ = Flux.Conv((3,3), 1=>64, relu, pad=0)(x)
#     y₂ = Flux.Conv((3,3), 64=>64, relu, pad=0)(y₁)
#     y₃ = Flux.MaxPool((2,2))(y₂)
    
#             #  conv1_2 = Flux.Conv((3,3), 64=>64, relu, pad=0),
#             #  maxpool1to2 = Flux.MaxPool((2,2)),
#             #  #2nd layer
#             #  conv2_1 = Flux.Conv((3,3), 64=>128, relu, pad=0),
#             #  conv2_2 = Flux.Conv((3,3), 128=>128, relu, pad=0),
#             #  maxpool2to3 = Flux.MaxPool((2,2)),
#             #  #3rd layer
#             #  conv3_1 = Flux.Conv((3,3), 128=>256, relu, pad=0),
#             #  conv3_2 = Flux.Conv((3,3), 256=>256, relu, pad=0),
#             #  maxpool3to4 = Flux.MaxPool((2,2)),
#             #  #4th layer
#             #  conv4_1 = Flux.Conv((3,3), 256=>512, relu, pad=0),
#             #  conv4_2 = Flux.Conv((3,3), 512=>512, relu, pad=0),
#             #  maxpool4to5 = Flux.MaxPool((2,2)),
#             #  #5th layrt
#             #  conv5_1 = Flux.Conv((3,3), 512=>1024, relu, pad=0),
#             #  conv5_2 = Flux.Conv((3,3), 1024=>1024, relu, pad=0),
#             #  transconv5to4 = Flux.ConvTranspose((2,2), 1024=>1024, relu, stride=2),
#             #  #4th layer
#             #  conv4_3 = Flux.Conv((3,3), 1024=>512, relu, pad=0),
#             #  conv4_4 = Flux.Conv((3,3), 512=>512, relu, pad=0),
#             #  transconv4to3 = Flux.ConvTranspose((2,2), 512=>512, relu, stride=2),
#             #  #3rd layer
#             #  conv3_3 = Flux.Conv((3,3), 512=>256, relu, pad=0),
#             #  conv3_4 = Flux.Conv((3,3), 256=>256, relu, pad=0),
#             #  transconv3to2 = Flux.ConvTranspose((2,2), 256=>256, relu, stride=2),
#             #  #2nd layer
#             #  conv2_3 = Flux.Conv((3,3), 256=>128, relu, pad=0),
#             #  conv2_4 = Flux.Conv((3,3), 128=>128, relu, pad=0),
#             #  transconv2to1 = Flux.ConvTranspose((2,2), 128=>128, relu, stride=2),
#             #  #1st layer
#             #  conv1_3 = Flux.Conv((3,3), 128=>64, relu, pad=0),
#             #  conv1_4 = Flux.Conv((3,3), 64=>64, relu, pad=0),
#             #  conv1_5 = Flux.Conv((1,1), 64=>1, relu, pad=0),
# return y₁
# end


