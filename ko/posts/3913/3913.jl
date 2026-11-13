using Plots
using LaTeXStrings

# 코사인 컷오프 함수 f_c(r) = (cos(πr/r_c) + 1)/2 (r ≤ r_c), 0 (r > r_c) 와 그 도함수
const rc = 6.0

fc(r) = r ≤ rc ? (cos(π * r / rc) + 1) / 2 : 0.0
dfc(r) = r ≤ rc ? -π / (2rc) * sin(π * r / rc) : 0.0

r = range(0, 7 / 6 * rc, length = 1000)

p = plot(r, fc.(r), lw = 2, c = RGB(0, 0, 0.6), label = L"f_{c}(r)",
         xlims = (0, 7 / 6 * rc), ylims = (-0.3, 1.1),
         xticks = ([0, rc], [L"0", L"r_{c}"]), yticks = ([0, 0.5, 1], [L"0", L"0.5", L"1"]),
         xlabel = L"r", framestyle = :box, gridalpha = 0.15,
         legend = :topright, legendfontsize = 9, tickfontsize = 9, guidefontsize = 10,
         size = (500, 200), margin = 5Plots.mm, dpi = 300)
plot!(p, r, dfc.(r), lw = 2, ls = :dash, c = RGB(0.75, 0, 0), label = L"f_{c}'(r)")
vline!(p, [rc], ls = :dash, c = :gray, lw = 1, label = "")

savefig(p, joinpath(@__DIR__, "3913_1.png"))
