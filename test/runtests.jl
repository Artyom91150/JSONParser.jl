using JSONParser
using Test, JSON

@testset "JSONParser.jl" begin
    json_string = read("data.json", String)
    test_json = JSON.parse(json_string)

    sorted_res = parse_json(test_json)

    open("output.csv", "w") do io
        write_csv(io, sorted_res)
    end

    output = open(f->read(f, String), "output.csv")
    test_output = open(f->read(f, String), "test_output.csv")

    @test isequal(output, test_output)
end
