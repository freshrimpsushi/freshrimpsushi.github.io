# using Plots

# cd = @__DIR__

# plot(rand(10), bg_color = :tomato,
#     title = "bg_color = :tomato",
#     size = (600, 250),
#     dpi = 300, lw = 4)
# savefig(cd * "/3603_1.png")


# plot(rand(10), bg_color_outside = :palegreen,
#     title = "bg_color_outside = :palegreen",
#     size = (600, 250),
#     dpi = 300, lw = 4)
# savefig(cd * "/3603_2.png")


# plot(rand(10), background_subplot = :violet,
#     title = "bg_subplot = :violet",
#     size = (600, 250),
#     dpi = 300, lw = 4)
# savefig(cd * "/3603_3.png")


# plot(rand(10), background_inside = :brown4,
#     title = "bg_inside = :brown4",
#     size = (600, 250),
#     dpi = 300, lw = 4)
# savefig(cd * "/3603_4.png")


# p₁ = plot(rand(10), bg_subplot = :tomato)
# p₂ = scatter(rand(10), bg_inside = :yellow)
# p = plot(p₁, p₂, dpi = 300, lw = 4, ms = 7, size = (600, 250),
#     title = ["bg_subplot = :tomato" "bg_inside = :yellow"],
#     )
# savefig(cd * "/3603_5.png")

# display(p)

# propertynames(p)
# p.backend
# p.n
# p.attr
# p.attr[:background_color] = colorant"rgba(255, 0, 0, 0.2)"
# p.attr[:background_color_outside] = colorant"rgba(0, 255, 0, 1)"
# p.attr[:background_subplot]
#     # :plot_titlefontvalign => :vcenter
# # :background_color => RGBA{Float64}(1.0,1.0,1.0,1.0)
#     # :inset_subplots => nothing
#     # :plot_titlefontfamily => :match
#     # :plot_titleindex => 0
#     # :foreground_color => RGBA{Float64}(0.0,0.0,0.0,1.0)
#     # :window_title => "Plots.jl"
#     # :pos => (0, 0)
#     # :thickness_scaling => 1
#     # :plot_titlelocation => :center
#     # :plot_titlefontsize => 16
#     # :show => false
#     # :link => :none
#     # :plot_titlevspan => 0.05
#     # :dpi => 100
# # :background_color_outside => :match
#     # :warn_on_unsupported => true
#     # :size => (600, 400)
#     # :display_type => :auto
#     # :overwrite_figure => true
#     # :html_output_format => :auto
#     # :plot_titlefontrotation => 0.0
#     # :extra_plot_kwargs => Dict{Any, Any}()
#     # :plot_titlefonthalign => :hcenter
#     # :tex_output_standalone => false
#     # :extra_kwargs => :series
#     # :layout => 1
#     # :plot_title => ""
#     # :plot_titlefontcolor => :match
#     # :fontfamily => "sans-serif")
# p.o
# p.subplots[1].attr
# p.spmap
# p.layout
# p.inset_subplots
# p.init


# p₁.series_list[1] = Plots.Series(RecipesPipeline.DefaultsDict(
# :plot_object => Plot{Plots.GRBackend() n=1}
# :subplot => Subplot{1}
# :markershape => :none
# :label => "y1"
# :fillalpha => nothing
# :linealpha => nothing
# :linecolor => RGBA{Float64}(0.0,0.6056031611752245,0.9786801175696073,1.0)
# :x_extrema => (NaN, NaN)
# :arrow => nothing
# :series_index => 1
# :markerstrokealpha => nothing
# :markeralpha => nothing
# :seriestype => :path
# :z_extrema => (NaN, NaN)
# :x => [1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0, 5.0, 5.0, 6.0, 6.0, 7.0, 7.0, 8.0, 8.0, 9.0, 9.0, 10.0]
# :markerstrokecolor => RGBA{Float64}(0.0,0.0,0.0,1.0)
# :fillcolor => RGBA{Float64}(0.0,0.6056031611752245,0.9786801175696073,1.0)
# :clims_calculated => (NaN, NaN)
# :fillrange => nothing
# :seriescolor => RGBA{Float64}(0.0,0.6056031611752245,0.9786801175696073,1.0)
# :extra_kwargs => Dict{Symbol, Any}()
# :z => nothing
# :series_plotindex => 1
# :y => [0.2797119425277218, 0.9812323585550073, 0.9812323585550073, 0.20648519852392644, 0.20648519852392644, 0.7686075636553438, 0.7686075636553438, 0.5958612920562505, 0.5958612920562505, 0.0862694711077111, 0.0862694711077111, 0.5396827040603954, 0.5396827040603954, 0.8932312290930524, 0.8932312290930524, 0.20192773571493772, 0.20192773571493772, 0.5440075753858571, 0.5440075753858571]
# :markercolor => RGBA{Float64}(0.0,0.6056031611752245,0.9786801175696073,1.0)
# :series_annotations => nothing
# :y_extrema => (0.0862694711077111, 0.9812323585550073)
# :linewidth => 1
# :group => nothing
# :stride => (1, 1)
# :permute => :none
# :marker_z => nothing
# :show_empty_bins => false
# :seriesalpha => nothing
# :smooth => false
# :zerror => nothing
# :normalize => false
# :linestyle => :solid
# :contours => false
# :bar_width => nothing
# :bins => :auto
# :markerstrokestyle => :solid
# :weights => nothing
# :z_order => :front
# :fill_z => nothing
# :markerstrokewidth => 1
# :xerror => nothing
# :bar_position => :overlay
# :contour_labels => false
# :hover => nothing
# :primary => true
# :yerror => nothing
# :ribbon => nothing
# :fillstyle => nothing
# :line_z => nothing
# :orientation => :vertical
# :markersize => 4
# :bar_edges => false
# :quiver => nothing
# :colorbar_entry => true
# :levels => 15
# :connections => nothing))