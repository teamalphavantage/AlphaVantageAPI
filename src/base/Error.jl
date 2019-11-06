# declare some types -
struct Result{T}
    value::T
end

struct AVKError
    message::String
end

function _is_path_valid(path_to_file::String)::Result{Bool}

    # the config file should be a json file, and should be reachable -
    # TODO: fill me in ...
    return Result{Bool}(true)
end

function _is_string_empty(raw_string::String)::Result{Bool}

    # if we have an empty string - return true
    if isempty(raw_string) == true
        return Result{Bool}(true)
    end

    # default Return is flase -
    return Result{Bool}(false)
end

function _check_missing_api_key(user_model::AVKUserModel)::(Union{T, Nothing} where T<:Any)

    # do we have the alpha_vantage_api_key -
    if (hasfield(AVKUserModel, :alphavantage_api_key) == false)
        # throw -
        return Result{AVKError}(AVKError("user model is missing API key information"))
    end

    # get the key -
    api_key = user_model.alphavantage_api_key

    # check -
    if (isempty(api_key) == true)

        # formulate an error message -
        error_message = "the API key is empty in the user model"

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end

    #
    return nothing
end

function _check_missing_symbol(stock_symbol::String)::(Union{T, Nothing} where T<:Any)

    if (isempty(stock_symbol) == true)

        # formulate an error message -
        error_message = "missing stock symbol"

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end

    # return nothing -
    return nothing
end

function _check_json_api_return_data(api_call_raw_data::String)::(Union{T, Nothing} where T<:Any)

    # well formed JSON?
    if _is_valid_json(api_call_raw_data).value == false
        return AVKError("invalid JSON $(api_call_raw_data)")
    end

    # need to check to see if legit data is coming back from the service -
    api_data_dictionary = JSON.parse(api_call_raw_data)
    if (haskey(api_data_dictionary,"Error Message") == true)

        # grab the error mesage -
        error_message = api_data_dictionary["Error Message"]

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end

    # need to check - are we hitting the API call limit?
    if (haskey(api_data_dictionary,"Note") == true)

        # grab the error mesage -
        error_message = api_data_dictionary["Note"]

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end

    # default -
    return nothing
end

function _check_user_model(user_model::AVKUserModel)::(Union{T, Nothing} where T<:Any)
    return Result{Bool}(true)
end


"""
    _is_valid_json(raw_string)->Bool

Checks to see if the input `string` is a valid JSON structure.
Returns `true` indicating valid JSON, `false` otherwise.
"""
function _is_valid_json(raw_string::String)::Result{Bool}

    # check: do we have an empty string?
    if (_is_string_empty(raw_string).value == true)
        return Result{Bool}(false)
    end

    # otherwise, to check to see if the string is valid JSON, try to
    # parse it.
    try
        JSON.parse(raw_string)
        return Result{Bool}(true)
    catch
        return Result{Bool}(false)
    end
end
