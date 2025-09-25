using JSON3
cd = @__DIR__

dict_data = Dict("name"      => "Jang, Wonyoung",
                 "age"       => 20,
                 "group"     => "IVE",
                 "nicknames" => ["Wonnyo", "Gatgi", "Lucky-Vicky"])

# 딕셔너리를 json 파일로 저장
JSON3.write(cd*"/wonnyo.json", dict_data)

open(cd*"/wonnyo.json", "w") do io
    JSON3.write(io, dict_data)
end

# 예쁘게 저장
open(cd*"/pretty_wonnyo.json", "w") do io
    JSON3.pretty(io, dict_data)
end


str_data = """
{
    "name": "Jang, Wonyoung",
    "age": 20,
    "group": "IVE",
    "nicknames": ["Wonnyo", "Gatgi", "Lucky-Vicky"]
}
"""

# 문자열을 json 파일로 저장
JSON3.write(cd*"/wonnyo.json", JSON3.read(str_data))

# 예쁘게 저장
open(cd*"/pretty_wonnyo.json", "w") do io
    JSON3.pretty(io, str_data)
end

json_data = JSON3.read(cd*"/wonnyo.json")
str_from_json = read(cd*"/wonnyo.json", String)