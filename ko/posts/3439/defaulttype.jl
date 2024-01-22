using Pkg

Pkg.add("ChangePrecision")

using ChangePrecision

rand(3)

@changeprecision Float32 begin
    rand(3)
end