using MLDatasets
using Plots
using Flux

X = MLDatasets.MNIST.traintensor()
Y = MLDatasets.MNIST.trainlabels()
Y[1]

heatmap(rotl90(X[:,:,1]), c=:grays, legend=:none, framestyle=:none, left_marging=100)

for i ∈ 1:100
    fig = heatmap(imrotate(Train_X[:,:,i],-pi/2))
end
# 마진 없애기 못해서 실패