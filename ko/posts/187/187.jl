using Plots, LaTeXStrings

# 정의: 정규 싱크 함수 (sinc(x) = sin(πx) / (πx))
function sinc(x)
    return x == 0 ? 1 : sin(π * x) / (π * x)
end

# 정의: 비정규 싱크 함수 (sinc(x) = sin(x) / x)
function non_regular_sinc(x)
    return x == 0 ? 1 : sin(x) / x
end

# x 값 범위 설정
x = LinRange(-10, 10, 1000)

# 정규 싱크 함수와 비정규 싱크 함수 계산
y_regular_sinc = sinc.(x)
y_non_regular_sinc = non_regular_sinc.(x)

# 그래프 그리기
cd = @__DIR__()

plot(x, y_regular_sinc, label=L"\mathrm{Regular:}\ \sin(\pi x)/ \pi x", xlabel=L"x", ylabel=L"y", title="Regular vs Non-regular Sinc Functions", lc=:royalblue, lw=2, legendfontsize=10, size=(728,400), dpi=200)
plot!(x, y_non_regular_sinc, label=L"\mathrm{Non}\ \mathrm{regular:}\ \sin(x)/x", lc=:tomato, lw=2)
plot!(legend=:topright, grid=true, framestyle=:box, legendfontsize=10, titlefontsize=12, tickfontsize=10)
savefig(joinpath(cd, "187_1.png"))