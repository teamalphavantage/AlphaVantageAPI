struct APIUserModel

    # data for user -
    alphavantage_api_email::String
    alphavantage_api_key::String

    # constructor -
    function APIUserModel(api_email::String="teamalphavantage@gmail.com",api_key::String="SKHF9DT43T4S8IR6")
        new(api_email,api_key)
    end
end

function check_if_user_dictionary_contains_correct_keys(user_data_dictionary::Dict{String,Any})

    # the user dictionary should contain a user_data root, and a alpha_vantage_api_key child -
    # TODO: fill me in ...
    return true
end

function build_api_user_model(path_to_configuration_file::String)::APIUserModel

    # some users checks -
    # did the user pass in a legit path?
    if (is_path_valid(path_to_configuration_file) == false)
        throw(error("error: $(path_to_configuration_file) in not a valid path"))
    end

    # ok, path seems legit - load the default user information from the config.json file -
    user_json_dictionary = JSON.parsefile(path_to_configuration_file)

    # does the user dictionary contain the correct keys?
    if (check_if_user_dictionary_contains_correct_keys(user_json_dictionary) == false)
        throw(error("error: missing keys in user configuration dictionary"))
    end

    # -- DO NOT EDIT BELOW THIS LINE ------------------------------------------#

    # grab the user data -
    alpha_vantage_api_key = user_json_dictionary["user_data"]["alpha_vantage_api_key"]
    alpha_vantage_api_email = user_json_dictionary["user_data"]["alpha_vantage_api_email"]

    # build APIUserModel -
    api_user_model = APIUserModel(alpha_vantage_api_email, alpha_vantage_api_key)

    # return the user_data_dictionary -
    return api_user_model
    # -------------------------------------------------------------------------#
end
