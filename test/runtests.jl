using AlphaVantage
using Test

# -- User creation tests ------------------------------------------------------- #
function build_api_user_model_test()

    # initialize -
    my_current_dir = pwd()   # where am I?
    path_to_config_file = my_current_dir*"/configuration/Configuration.json"

    # build the api user model -
    user_model = build_api_user_model(path_to_config_file)
    user_email = user_model.alphavantage_api_email

    # is the user email teamalphavantage@gmail.com?
    if (user_email == "teamalphavantage@gmail.com")
        return true
    end

    # return -
    return false
end
#------------------------------------------------------------------------------- #

@testset "user_test_set" begin
    @test build_api_user_model_test() == true
end
