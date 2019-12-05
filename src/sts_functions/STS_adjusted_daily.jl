function execute_sts_adjusted_daily_api_call(user_model::AVKUserModel, stock_symbol::String; data_type::Symbol = :json, outputsize::Symbol = :compact, logger::Union{Nothing,AbstractLogger} = nothing)::(Union{T, Nothing} where T<:Any)
    # some error checks -
    # is user_models valid?
    check_result = _check_user_model(user_model)
    if (check_result != nothing && typeof(check_result.value) == AVKError)
        return check_result
    end

    # do we have the API key?
    check_result = _check_missing_api_key(user_model)
    if (check_result != nothing && typeof(check_result.value) == AVKError)
        return check_result
    end

    # do we have a stock_symbol -
    check_result = _check_missing_symbol(stock_symbol)
    if (check_result != nothing && typeof(check_result.value) == AVKError)
        return check_result
    end

    # get key's and id -
    api_key = user_model.alphavantage_api_key

    #call to alpha_vantage_api to get data
    url = "$(alphavantage_api_url_string)?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$(stock_symbol)&apikey=$(api_key)&datatype=$(string(data_type))&outputsize=$(string(outputsize))"
    api_call_result = _http_get_call_with_url(url)
    if (typeof(api_call_result.value) == AVKError)
        return api_call_result
    end#keep the same as daily call

    #check that result value is a string
    #this is also new but doesn't change between time periods
    if (typeof(api_call_result.value) isa String == false)
        println("Call result is not valid type")#error from not correct data output
    else
        api_call_raw_data = api_call_result.value
    end

    #call to logger
    if logger != nothing
        debug_log_api_call(logger, user_model, url)
    end
    #parse json if data called as a .json
    if (data_type == :json)
        #process json
        data_series_key = "Time Series (Daily)"
        return _process_raw_json_api_data_sts_adjusted(api_call_raw_data, data_series_key)

    elseif (data_type == :csv)
        #return process .csv
        return _process_raw_csv_api_data(api_call_raw_data, data_series_key)
    else
        #tell user they requested an unsupported type of data
        error_message = "$(data_type) isn't supported by AlphaVantage. Supported values are {:json, :csv}"
        return Result{AVKError}(AVKError(error_message))
    end
end
