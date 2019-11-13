function execute_sts_daily_api_call(user_model::AVKUserModel, stock_symbol::String; data_type::Symbol = :json, outputsize::Symbol = :compact, logger::Union{Nothing,AbstractLogger} = nothing)::(Union{T, Nothing} where T<:Any)

    # some error checks -
    # is user_model valid?
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

    # use the alpha_vantage_api to download the data -
    url = "$(alphavantage_api_url_string)?function=TIME_SERIES_DAILY&symbol=$(stock_symbol)&apikey=$(api_key)&datatype=$(string(data_type))&outputsize=$(string(outputsize))"
    api_call_result = _http_get_call_with_url(url)
    if (typeof(api_call_result.value) == AVKError)
        return api_call_result
    end

    # we should have a string result -
    api_call_raw_data = api_call_result.value

    # make a call to log -
    if logger != nothing
        debug_log_api_call(logger, user_model,url)
    end

    # make the calls, depending upon the type -
    if (data_type == :json)

        # process -
        data_series_key = "Time Series (Daily)"
        return _process_raw_json_api_data_sts(api_call_raw_data, data_series_key)

    elseif (data_type == :csv)

        # return the data back to the caller -
        return _process_raw_csv_api_data(api_call_raw_data)
    else
        # formulate the error message -
        error_message = "$(data_type) is not supported. Supported values are {:json,:csv}"

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end
end
