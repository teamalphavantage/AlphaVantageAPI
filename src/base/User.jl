struct AVKUserModel

    # data for user -
    alphavantage_api_email::String
    alphavantage_api_key::String

    # constructor -
    function AVKUserModel(api_email::String="teamalphavantage@gmail.com",api_key::String="SKHF9DT43T4S8IR6")
        new(api_email,api_key)
    end
end

function _check_if_user_dictionary_contains_correct_keys(user_data_dictionary::Dict{String,Any})::Result{Bool}

    # the user dictionary should contain a user_data root, and a alpha_vantage_api_key child -
    # TODO: fill me in ...
    return Result{Bool}(true)
end

# -- PUBLIC METHODS HERE ------------------------------------------------------- #
"""
    build_api_user_model(path) -> {Result{AVKError} or Result{AVKUserModel}}

Takes a `path` string which points to a JSON configuration file.
Returns either a Result{AVKError} if something went wrong, or a Result{AVKUserModel} object holding the user email and AlphaVantage API key.
The AVKError and AVKUserModel can be accessed using the `value` field on the Result return wrapper
"""
function build_api_user_model(path_to_configuration_file::String)::(Union{T, Nothing} where T<:Any)

    # some users checks -
    # did the user pass in a legit path?
    check_result = _is_path_valid(path_to_configuration_file)
    if (typeof(check_result.value) == Bool && check_result.value == false)
        error_message = "error: $(path_to_configuration_file) in not a valid path"
        return Result{AVKError}(AVKError(error_message))
    end

    # ok, path seems legit - load the default user information from the config.json file -
    user_json_dictionary = JSON.parsefile(path_to_configuration_file)

    # does the user dictionary contain the correct keys?
    if (_check_if_user_dictionary_contains_correct_keys(user_json_dictionary) == false)
        error_message = "error: missing keys in user configuration dictionary"
        return Result{AVKError}(AVKError(error_message))
    end

    # -- DO NOT EDIT BELOW THIS LINE ------------------------------------------#

    # grab the user data -
    alpha_vantage_api_key = user_json_dictionary["user_data"]["alpha_vantage_api_key"]
    alpha_vantage_api_email = user_json_dictionary["user_data"]["alpha_vantage_api_email"]

    # build APIUserModel -
    api_user_model = AVKUserModel(alpha_vantage_api_email, alpha_vantage_api_key)

    # return the user_data_dictionary -
    return Result{AVKUserModel}(api_user_model)
    # -------------------------------------------------------------------------#
end
