@time using LaTeXStrings
@time using Plots
using Random

cd(@__DIR__)

Random.seed!(0)

dk = 512    # 쿼리/키 벡터의 차원 d_k
m  = 10     # 키의 개수

q = randn(dk)       # 쿼리 1개, 성분은 표준정규분포 N(0,1)에서 샘플링
K = randn(dk, m)    # 키 m개

s = K' * q          # 스코어 kⱼᵀq, j = 1, …, m

softmax(x) = exp.(x .- maximum(x)) ./ sum(exp.(x .- maximum(x)))

# 왼쪽: 스케일링 없이 소프트맥스 → 사실상 원-핫으로 포화
p1 = bar(1:m, softmax(s),
    color = :tomato, legend = false,
    xticks = 1:m, ylims = (0, 1),
    xlabel = L"j", ylabel = "probability",
    title = L"\mathrm{softmax}(k_j^T q)",
    left_margin = 3Plots.mm, bottom_margin = 3Plots.mm)

# 오른쪽: √dk 로 나눈 뒤 소프트맥스 → 여러 키에 확률이 분산
p2 = bar(1:m, softmax(s ./ sqrt(dk)),
    color = :royalblue, legend = false,
    xticks = 1:m, ylims = (0, 1),
    xlabel = L"j", ylabel = "probability",
    title = L"\mathrm{softmax}(k_j^T q / \sqrt{d_k})",
    left_margin = 3Plots.mm, bottom_margin = 3Plots.mm)

plot(p1, p2, layout = (1, 2), size = (800, 320), dpi = 300)
savefig("3875.png")
