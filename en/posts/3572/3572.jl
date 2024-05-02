using Clustering
using RDatasets

X = dataset("datasets", "iris")[:, 1:4]
X = Array(X)'

results = kmeans(X, 3, display=:iter)
# Iters               objv        objv-change | affected 
# -------------------------------------------------------------
#       0       9.002000e+01
#       1       7.934436e+01      -1.067564e+01 |        2
#       2       7.892131e+01      -4.230544e-01 |        2
#       3       7.885567e+01      -6.564390e-02 |        0
#       4       7.885567e+01       0.000000e+00 |        0


using Plots

markers = [:circle, :utriangle, :xcross] # 점도표에 쓰일 마커 지정
p = plot(dpi = 300, legend = :none) # 빈 플롯 생성
X
for i ∈ 1:3
 i_cluster = findall(x -> x == i, results.assignments) # i번째 클러스터에포함된 데이터들의 인덱스
 scatter!(p, X[1, i_cluster], X[2, i_cluster],
 marker = markers[i],
 ms = 8,
 xlabel = "sepal length",
 ylabel = "sepal width"
 ) # i번째 마커로 그리는 i번째 클러스터에 포함된 데이터들의 점도표
end

cd = @__DIR__
savefig(p, cd*"\\3571_1.png")