function is_path_valid(path_to_file::String)

    # the config file should be a json file, and should be reachable -
    # TODO: fill me in ...
    return true
end

function is_string_empty(raw_string::String)::Bool
    return isempty(raw_string)
end

"""
    is_valid_json(raw_string::String)::Bool

Checks to see if the input string is a valid JSON structure. Returns true indicating valid JSON, false otherwise.

# Examples
```jldoctest
julia> test_data = "{\"symbol_array\":[\"AAPL\",\"MSFT\"]}"
"{\"symbol_array\":[\"AAPL\",\"MSFT\"]}"

julia> is_valid_json(test_data)
true
```
"""
function is_valid_json(raw_string::String)::Bool

    # check: do we have an empty string?
    if (is_string_empty(raw_string) == true)
        return false
    end

    # otherwise, to check to see if the string is valid JSON, try to
    # parse it.
    try
        JSON.parse(raw_string)
        return true
    catch
        return false
    end
end
