# define constants here -
const alphavantage_api_url_string = "https://www.alphavantage.co/query"
const path_to_package = dirname(pathof(@__MODULE__))

# load offical packages here -
using DataFrames
using CSV
using HTTP
using JSON
using Dates
using Logging

# load our code here -
include("./base/Network.jl")
include("./base/Utility.jl")
include("./base/User.jl")
include("./base/Error.jl")
include("./base/Handlers.jl")
include("./base/Log.jl")

# STS code includes go here -
include("./sts_functions/STSDaily.jl")
include("./sts_functions/STSMonthly.jl")
