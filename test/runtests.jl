using AlphaVantage
using Test
using DataFrames
using Logging
using JSON

# -- User creation tests ------------------------------------------------------- #
function build_api_user_model_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    user_model = user_model_result.value
    user_email = user_model.alphavantage_api_email

    # is the user email the same as in Configuration.json?
    user_json_dictionary = JSON.parsefile(path_to_config_file)
    alpha_vantage_api_email = user_json_dictionary["user_data"]["alpha_vantage_api_email"]
    if (user_email == alpha_vantage_api_email)
        return true
    end
    @show user_model
    @show user_email
    # return -
    return false
end

function download_daily_appl_sts_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_daily_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=nothing)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_daily_appl_sts_with_logging_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # create a simple logger -
    path_to_log_file = my_current_dir*"/logs/log.txt"
    io = open(path_to_log_file, "a+")
    simple_logger = SimpleLogger(io, Logging.Debug)

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_daily_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=simple_logger)

    # close -
    close(io)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_daily_adjusted_appl_sts_test()
    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_adjusted_daily_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=nothing)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_daily_adjusted_appl_sts_with_logging_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # create a simple logger -
    path_to_log_file = my_current_dir*"/logs/log.txt"
    io = open(path_to_log_file, "a+")
    simple_logger = SimpleLogger(io, Logging.Debug)

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_adjusted_daily_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=simple_logger)

    # close -
    close(io)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_monthly_appl_sts_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_monthly_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=nothing)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_monthly_appl_sts_with_logging_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # create a simple logger -
    path_to_log_file = my_current_dir*"/logs/log.txt"
    io = open(path_to_log_file, "a+")
    simple_logger = SimpleLogger(io, Logging.Debug)

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_monthly_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=simple_logger)

    # close -
    close(io)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_weekly_appl_sts_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_weekly_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=nothing)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    end

    # return -
    return false
end

function download_weekly_appl_sts_with_logging_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # create a simple logger -
    path_to_log_file = my_current_dir*"/logs/log.txt"
    io = open(path_to_log_file, "a+")
    simple_logger = SimpleLogger(io, Logging.Debug)

    # build the api user model -
    user_model_result = build_api_user_model(path_to_config_file)
    if (typeof(user_model_result.value) == AVKError)
        @show typeof(user_model_result.value)
        return false
    end

    # get the user model, we'll need this to make an API call -
    user_model = user_model_result.value

    # make an API call -
    stock_symbol = "aapl"
    data_type = :json
    outputsize = :compact
    api_call_result = execute_sts_weekly_api_call(user_model, stock_symbol; data_type = data_type, outputsize = outputsize, logger=simple_logger)

    # close -
    close(io)
    @show typeof(api_call_result.value)

    # check -
    if (typeof(api_call_result.value) == DataFrame)
        return true
    else
        @show(typeof(api_call_result.value))
    end

    # return -
    return false
end





#------------------------------------------------------------------------------- #

@testset "user_test_set" begin
    @test build_api_user_model_test() == true
end

@testset "execute_sts_daily_api_call_set" begin
    #@test download_daily_appl_sts_test() == true
    @test download_daily_appl_sts_with_logging_test() == true
end

@testset "execute_sts_monthly_api_call_set" begin
    #@test download_monthly_appl_sts_test() == true
    @test download_monthly_appl_sts_with_logging_test() == true
end
#=
@testset "execute_sts_weekly_api_call_set" begin
    @test download_weekly_appl_sts_with_logging_test() == true
    #@test download_weekly_appl_sts_test() == true
end
=#
#Errors coming from testing more often than 10 calls per minute going to just logging tests
@testset "execute_sts_adjusted_api_call_set" begin
    @test download_daily_adjusted_appl_sts_test() == true
    #@test download_daily_adjusted_appl_sts_with_logging_test() == true
end
