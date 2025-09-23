using JSON
cd = @__DIR__

dict_data = Dict("name"      => "Jang, Wonyoung",
                 "age"       => 19,
                 "group"     => "IVE",
                 "nicknames" => ["Wonnyo", "Gatgi", "Lucky-Vicky"])

open(cd*"/dict2json.json", "w") do io
    JSON.print(io, dict_data)
end

open(cd*"/pretty_dict2json.json", "w") do io
    JSON.print(io, dict_data, 4)
end

str_data = """
{
    "name": "Jang, Wonyoung",
    "age": 19,
    "group": "IVE",
    "nicknames": ["Wonnyo", "Gatgi", "Lucky-Vicky"]
}
"""

open(cd*"/str2json.json", "w") do io
    JSON.print(io, JSON.parse(str_data))
end

open(cd*"/str2json.json", "r") do io
    str_from_json = read(io, String)
    dict_from_str = JSON.parse(str_from_json)
end

open(cd*"/pretty_str2json.json", "w") do io
    JSON.print(io, JSON.parse(str_data), 4)
end

unpretty_str_data = """
{"name": "Jang, Wonyoung", "age": 19, "group": "IVE", "nicknames": ["Wonnyo", "Gatgi", "Lucky-Vicky"]}
"""

open(cd*"/str2json.json", "w") do io
    JSON.write(io, str_data)
end

open(cd*"/unpretty_str2json.json", "w") do io
    JSON.write(io, unpretty_str_data)
end

data = JSON.parsefile(cd*"/str2json.json")

open(cd*"/str2json.json", "r") do io
    str_from_json = read(io, String)
    dict_from_str = JSON.parse(str_from_json)
end

using BenchmarkTools
using JSON
cd = @__DIR__

dict_data = Dict("name"      => "Jang, Wonyoung",
                 "age"       => 19,
                 "group"     => "IVE",
                 "nicknames" => ["Wonnyo", "Gatgi", "Lucky-Vicky"])

@btime begin
    open(cd*"/dict2json.json", "w") do io
        JSON.print(io, dict_data)
    end
    data = JSON.parsefile(cd*"/str2json.json")
end

# 137.000 μs (68 allocations: 4.04 KiB)
# 134.400 μs (68 allocations: 4.04 KiB)
# 133.200 μs (68 allocations: 4.04 KiB)