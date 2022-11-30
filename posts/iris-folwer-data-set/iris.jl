julia> using MLDatasets
julia> using DataFrames

julia> X = Iris()
dataset Iris:
  metadata   =>    Dict{String, Any} with 4 entries
  features   =>    150×4 DataFrame
  targets    =>    150×1 DataFrame
  dataframe  =>    150×5 DataFrame

julia> X[:]
(features = 150×4 DataFrame
 Row │ sepallength  sepalwidth  petallength  petalwidth
     │ Float64      Float64     Float64      Float64
─────┼──────────────────────────────────────────────────
   1 │         5.1         3.5          1.4         0.2
   2 │         4.9         3.0          1.4         0.2
   3 │         4.7         3.2          1.3         0.2
  ⋮  │      ⋮           ⋮            ⋮           ⋮
 149 │         6.2         3.4          5.4         2.3
 150 │         5.9         3.0          5.1         1.8
                                        145 rows omitted, targets = 150×1 DataFrame
 Row │ class
     │ String15
─────┼────────────────
   1 │ Iris-setosa
   2 │ Iris-setosa
   3 │ Iris-setosa
  ⋮  │       ⋮
 149 │ Iris-virginica
 150 │ Iris-virginica
      145 rows omitted)

julia> X = Iris(as_df=false)[:]
(features = [5.1 4.9 … 6.2 5.9; 3.5 3.0 … 3.4 3.0; 1.4 1.4 … 5.4 5.1; 0.2 0.2 … 2.3 1.8], targets = InlineStrings.String15[InlineStrings.String15("Iris-setosa") InlineStrings.String15("Iris-setosa") … InlineStrings.String15("Iris-virginica") InlineStrings.String15("Iris-virginica")])

julia> typeof(X)
NamedTuple{(:features, :targets), Tuple{Matrix{Float64}, Matrix{InlineStrings.String15}}}

julia> X.dataframe
150×5 DataFrame
 Row │ sepallength  sepalwidth  petallength  petalwidth  class
     │ Float64      Float64     Float64      Float64     String15
─────┼──────────────────────────────────────────────────────────────────
   1 │         5.1         3.5          1.4         0.2  Iris-setosa
   2 │         4.9         3.0          1.4         0.2  Iris-setosa
   3 │         4.7         3.2          1.3         0.2  Iris-setosa
   4 │         4.6         3.1          1.5         0.2  Iris-setosa
   5 │         5.0         3.6          1.4         0.2  Iris-setosa
   6 │         5.4         3.9          1.7         0.4  Iris-setosa
   7 │         4.6         3.4          1.4         0.3  Iris-setosa
   8 │         5.0         3.4          1.5         0.2  Iris-setosa
   9 │         4.4         2.9          1.4         0.2  Iris-setosa
  10 │         4.9         3.1          1.5         0.1  Iris-setosa
  11 │         5.4         3.7          1.5         0.2  Iris-setosa
  ⋮  │      ⋮           ⋮            ⋮           ⋮             ⋮
 141 │         6.7         3.1          5.6         2.4  Iris-virginica
 142 │         6.9         3.1          5.1         2.3  Iris-virginica
 143 │         5.8         2.7          5.1         1.9  Iris-virginica
 144 │         6.8         3.2          5.9         2.3  Iris-virginica
 145 │         6.7         3.3          5.7         2.5  Iris-virginica
 146 │         6.7         3.0          5.2         2.3  Iris-virginica
 147 │         6.3         2.5          5.0         1.9  Iris-virginica
 148 │         6.5         3.0          5.2         2.0  Iris-virginica
 149 │         6.2         3.4          5.4         2.3  Iris-virginica
 150 │         5.9         3.0          5.1         1.8  Iris-virginica
                                                        129 rows omitted