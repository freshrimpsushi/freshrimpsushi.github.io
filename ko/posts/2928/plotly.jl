using Printf

js(v::AbstractVector{<:Real}) = "[" * join(v, ",") * "]"
js(v::AbstractVector) = "[" * join(("\"$x\"" for x in v), ",") * "]"

function plotly_html(traces::String, layout::String = "{}"; file = "plot.html", w = 712, h = 712)
    write(file, """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <script src="https://cdn.plot.ly/plotly-2.35.2.min.js"></script>
    </head>
    <body style="margin:0">
      <div id="plot" style="width:$(w)px;height:$(h)px"></div>
      <script>Plotly.newPlot("plot", $traces, $layout);</script>
    </body>
    </html>
    """)
end

f(r, x)  = r * x * (1 - x)
f3(r, x) = f(r, f(r, f(r, x)))

function df3(r, x)
    d = 1.0
    for _ in 1:3
        d *= r * (1 - 2x)
        x = f(r, x)
    end
    return d
end

function fixed_points(r; N = 6000)
    g(x) = f3(r, x) - x
    roots = [0.0]
    for i in 1:N
        a, b = (i - 1) / N, i / N
        g(a) * g(b) < 0 || continue
        for _ in 1:60
            m = (a + b) / 2
            g(a) * g(m) <= 0 ? (b = m) : (a = m)
        end
        push!(roots, (a + b) / 2)
    end
    stable = filter(x -> abs(df3(r, x)) < 1, roots)
    unstable = filter(x -> abs(df3(r, x)) >= 1, roots)
    return stable, unstable
end

rs = round.(range(3.80, 3.86; length = 121); digits = 4)
xs = round.(range(0, 1; length = 1001); digits = 3)
k0 = argmin(abs.(rs .- 3.84))
n  = length(rs)

curve(r, vis) = """{x:$(js(xs)),y:$(js(round.(f3.(r, xs); digits = 5))),mode:"lines",line:{color:"#2a78d6",width:2},name:"f³(x)",hoverinfo:"skip",visible:$vis}"""

dots(p, name, symbol, vis) = """{x:$(js(round.(p; digits = 6))),y:$(js(round.(p; digits = 6))),mode:"markers",marker:{symbol:"$symbol",color:"black",size:11,line:{color:"black",width:2}},name:"$name",visible:$vis}"""

diagonal = """{x:[0,1],y:[0,1],mode:"lines",line:{color:"#898781",width:1.5,dash:"dash"},name:"y = x",hoverinfo:"skip"}"""

traces = [diagonal]
titles = String[]
for (k, r) in enumerate(rs)
    st, un = fixed_points(r)
    vis = k == k0
    push!(traces, curve(r, vis), dots(st, "안정 고정점", "circle", vis), dots(un, "불안정 고정점", "circle-open", vis))
    push!(titles, @sprintf("a = %.4f · 안정 %d · 불안정 %d", r, length(st), length(un)))
end

steps = map(1:n) do k
    vis = vcat(true, [i == k for i in 1:n for _ in 1:3])
    label = (k - 1) % 20 == 0 ? @sprintf("%.2f", rs[k]) : ""
    """{method:"update",label:"$label",args:[{visible:$(js(vis))},{"title.text":"$(titles[k])"}]}"""
end

layout = """{
  title:{text:"$(titles[k0])",y:0.97,yanchor:"top"},
  xaxis:{title:{text:"x"},range:[0,1]},
  yaxis:{title:{text:"f³(x)"},range:[0,1],scaleanchor:"x",scaleratio:1},
  legend:{orientation:"h",x:0.5,xanchor:"center",y:1.02,yanchor:"bottom"},
  margin:{t:80,b:130,l:105,r:105},
  sliders:[{active:$(k0 - 1),len:0.9,x:0.05,pad:{t:60},currentvalue:{visible:false},steps:[$(join(steps, ","))]}]
}"""

plotly_html("[" * join(traces, ",") * "]", layout; file = "logistic_f3.html")




function logistic(r, x)
    return r * x * (1 - x)
end
logistic(4, 0.5)

function iter(f, p, x0, n)
    x = [x0]
    for t in 1:n
        push!(x, f(p, x[end]))
    end
    return x
end
traj = iter(logistic, 3, 0.5, 100)

using Plots, LaTeXStrings
plot(traj)

function bifurcation(h)
    xaxis_ = []
    yaxis_ = []
    for r ∈ 3.8:h:3.86
        preiterated = iter(logistic, r, 0.5, 200)[101:end]
        xaxis_ = [xaxis_; fill(r, length(preiterated))]
        yaxis_ = [yaxis_; preiterated]
    end
    return xaxis_, yaxis_
end

# @time xaxis, yaxis = bifurcation(0.01)
# diagram = scatter(xaxis, yaxis, markersize = 0.1, markeralpha = 0.5, legend = false, xlims = (1, 4), ylims = (0, 1))
@time xaxis, yaxis = bifurcation(0.0001)
diagram = scatter(xaxis, yaxis,
xlabel = L"a", ylabel = L"x",
markersize = 0.1, markeralpha = 0.5, legend = false, xlims = (3.8, 3.86), ylims = (0, 1));
png(diagram, "bifurcation_zoom.png")
