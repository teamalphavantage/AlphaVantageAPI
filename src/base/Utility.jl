function process_raw_csv_api_data(api_call_raw_data::String)

    # check: do we have an empty string?
    # check: legit string?

    # need to check to see if legit data is coming back from the service -
    if (is_valid_json(api_call_raw_data) == true)
        api_data_dictionary = JSON.parse(api_call_raw_data)
        if (haskey(api_data_dictionary,"Error Message") == true)

            # grab the error mesage -
            error_message = api_data_dictionary["Error Message"]

            # throw -
            throw(error(error_message))
        else

            # formulate an error message -
            error_message = "Error: CSV type returns JSON without error message"

            # throw -
            throw(error(error_message))
        end
    end

    # create a data table from the CSV data -
    tmp_data_table = CSV.read(IOBuffer(api_call_raw_data))

    # sort the table according to the timestamps -
    idx_sort = sortperm(tmp_data_table[:,1])

    # create a sorted data table -
    sorted_data_table = tmp_data_table[idx_sort,:]

    # return the sorted table -
    return sorted_data_table
end
