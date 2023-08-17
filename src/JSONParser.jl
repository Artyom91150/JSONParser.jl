module JSONParser

export parse_json, write_csv

function fill_pairs!(result_dict, node, prev_key = "")
    if typeof(node) <: Dict
        for key in keys(node)
            if prev_key != ""
                fill_pairs!(result_dict, node[key], prev_key * "_" * key)
            else
                fill_pairs!(result_dict, node[key], prev_key * key)
            end
        end
    else
        if haskey(result_dict, prev_key)
            push!(result_dict[prev_key], node)
        else
            result_dict[prev_key] = Vector{typeof(node)}()
            push!(result_dict[prev_key], node)
        end
    end
end

function parse_json(json)
    result = Dict()
    
    for obj in json
        fill_pairs!(result, obj)
    end

    return sort(collect(result), by = x -> x[1])
end

function write_headers(io::IO, vec_pair, separator = ",")
    print(io, join([header[1] for header in vec_pair], separator))
end

function write_values(io::IO, vec_pair, separator = ",")
    val_n = length(vec_pair[begin][2])
    key_n = length(vec_pair)
    for i in 1 : val_n
        for j in 1 : key_n
            print(io, string(vec_pair[j][2][i]))
            if j != key_n print(io, separator) end
        end
        if i != val_n print(io, "\n") end
    end
end

function write_csv(io::IO, vec_pair, separator = ",")
    write_headers(io, vec_pair, separator)
    print(io, "\n")
    write_values(io, vec_pair, separator)
end

end