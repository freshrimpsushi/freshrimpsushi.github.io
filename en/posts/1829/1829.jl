using Plots
using LaTeXStrings

# f\_{n}(x) = \begin{cases}
# n^{2}x & \text{if } 0 \le x \lt \frac{1}{n} \\\
# 2n - n^{2}x & \text{if } \frac{1}{n} \le x \le \frac{2}{n} \\\
# 0 & \text{if } \frac{2}{n} \lt x \le 1
# \end{cases}
function f(n)
    ff = function(x)
        if 0 ≤ x < 1/n
            return n^2 * x
        elseif 1/n ≤ x ≤ 2/n
            return 2n - n^2 * x
        else
            return 0
        end
    end

    return ff    
end

x = 0:0.001:1
f2 = f(2)
f3 = f(3)
f4 = f(4)
f9 = f(9)
plot(x, f2.(x), xlims=(0, 1.2), ylims=(0, 11), label=L"f_{2}", lw=2, dpi=300, size=(728,300),
    xticks=([0, 1/5, 1/4, 1/3, 1/2, 1], ["0", "2/n", "1/4", "1/3", "1/2", "1"]),
    yticks=([1, 2, 10], ["1", "2", "n"]), legend_columns=-1)
plot!(x, f3.(x), label=L"f_{3}", lw=2, legendfontsize=15)
plot!(x, f4.(x), label=L"f_{4}", lw=2)
# plot!(x, f9.(x), label=L"f_{n}", lw=2)
plot!(x, f10.(x), label=L"f_{n}", lw=2)
savefig("./1829_1.png")