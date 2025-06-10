using CSV
# using DataFrames

cd = @__DIR__

train_conventional = CSV.read(joinpath(cd, "train_conventional.csv"), DataFrame)
csv = CSV.File(joinpath(cd, "train_conventional.csv"))
train_primitive    = CSV.read(joinpath(cd, "train_primitive.csv"), DataFrame)

df = DataFrame()
df[!, :id] = [1, 2, 3]

CSV.write(joinpath(cd, "moo.csv"), df)

using JSON3

json_file = JSON3.read(joinpath(cd, "info_test.json"))

test = """{"property1": 1, "property2": 2, "property3": "test"}"""
JSON3.pretty(test)
JSON3.write(joinpath(cd, "test.json"), test)
open("my_new_file.json", "w") do io
    JSON3.pretty(io, test)
end

using PyCall
pickle = pyimport("pickle")
cd = @__DIR__

dict_data = Dict("key1" => "value1", "key2" => "value2")

# 딕셔너리를 pkl 파일로 쓰기
open("file_name.pkl", "w") do f
    pickle.dump(dict_data, f)
end

# pkl 파일을 딕셔너리로 읽기
dict_from_pkl = open("file_name.pkl") do f
    pickle.load(f)
end


using PyCall
np = pyimport("numpy")
cd = @__DIR__

vector_data = [1.0, 2, 3]
open(joinpath(cd, "file_name.npy"), "w") do f
    np.save(f, vector_data)
end

test_read_np = open(joinpath(cd, "file_name.npy")) do f
    np.load(f)
end


using MAT
cd = @__DIR__

mat_data = Dict("matrix1" => [1.0 2.0; 3.0 4.0], "matrix2" => [5.0 6.0; 7.0 8.0])
matwrite("file_name.mat", mat_data)

dict_from_mat = matread("file_name.mat")

using XLSX
using DataFrames

df_data = DataFrame(Arabic = 1:5,
                    English = ["one", "two", "three", "four", "five"],
                    Korean = ["일", "이", "삼", "사", "오"])

XLSX.writetable("file_name.xlsx", df_data)

df_from_xlsx = XLSX.readtable("file_name.xlsx", "Sheet1") |> DataFrame
