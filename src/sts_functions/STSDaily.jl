function process_raw_json_api_data_sts_daily(api_call_raw_data::String)::(Union{T, Nothing} where T<:Any)

    # is the data coming back well formed, and does it contain valid data?
    check_result = _check_json_api_return_data(api_call_raw_data)
    if check_result != nothing
        return check_result
    end

    # if we get here, we have valid JSON. Build dictionary -
    api_data_dictionary = JSON.parse(api_call_raw_data)

    # grab the time series data -
    time_series_key = "Time Series (Daily)"
    if (haskey(api_data_dictionary, time_series_key) == false)

        # throw an error -
        error_message = "Error: Missing the Time series key = $(time_series_key)"

        # throw -
        return AVKError(error_message)
    end

    # array of keys -
    data_key_label_array = ["1. open", "2. high", "3. low", "4. close", "5. volume"]
    number_of_fields = length(data_key_label_array)

    # initialize storage for the fields -
    timestamp_array = Dates.Date[]
    open_price_array = Float64[]
    high_price_array = Float64[]
    low_price_array = Float64[]
    close_price_array = Float64[]
    volume_array = Int64[]

    # ok, we have the time series key, go through the data and load into the table -
    time_series_dictionary = api_data_dictionary[time_series_key]
    time_series_key_array = collect(keys(time_series_dictionary))
    for timestamp_value in time_series_key_array

        # get the local_dictionary -
        local_dictionary = time_series_dictionary[timestamp_value]

        # cache -
        push!(timestamp_array, Dates.Date(timestamp_value,"yyyy-mm-dd"))

        # add the price data -
        for key_index = 1:number_of_fields

            # grab key -
            local_key = data_key_label_array[key_index]
            value = local_dictionary[local_key]

            # populate the array's -
            if (key_index == 1)
                push!(open_price_array, parse(Float64, value))
            elseif (key_index == 2)
                push!(high_price_array, parse(Float64, value))
            elseif (key_index == 3)
                push!(low_price_array, parse(Float64, value))
            elseif (key_index == 4)
                push!(close_price_array, parse(Float64, value))
            else
                push!(volume_array, parse(Int64, value))
            end
        end
    end

    # we need to sort the timestamps, to make them in reverse order -
    idx_sort = sortperm(timestamp_array)

    # build the data frame -
    data_frame = DataFrame(timestamp=timestamp_array[idx_sort], open=open_price_array[idx_sort], high=high_price_array[idx_sort], low=low_price_array[idx_sort], close=close_price_array[idx_sort], volume=volume_array[idx_sort])

    # return the data back to the caller -
    return Result{DataFrame}(data_frame)
end

function execute_sts_daily_api_call(user_model::AVKUserModel, stock_symbol::String; data_type::Symbol = :json, outputsize::Symbol = :compact)::(Union{T, Nothing} where T<:Any)

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

    # make the calls, depending upon the type -
    if (data_type == :json)

        # process -
        return process_raw_json_api_data_sts_daily(api_call_raw_data)

    elseif (data_type == :csv)

        # return the data back to the caller -
        return process_raw_csv_api_data(api_call_raw_data)
    else
        # formulate the error message -
        error_message = "$(data_type) is not supported. Supported values are {:json,:csv}"

        # throw -
        return Result{AVKError}(AVKError(error_message))
    end
end
