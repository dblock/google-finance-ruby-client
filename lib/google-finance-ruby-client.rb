require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response_middleware'
require 'hashie'
require_relative 'google-finance/version'
require_relative 'google-finance/faraday_middleware/preprocessor'
require_relative 'google-finance/errors'
require_relative 'google-finance/api'
require_relative 'google-finance/resource'
require_relative 'google-finance/quote'
require_relative 'google-finance/quotes'
require_relative 'google-finance/price'
require_relative 'google-finance/prices'
