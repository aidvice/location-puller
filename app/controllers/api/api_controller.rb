class Api::ApiController < ApplicationController
    def check_api_token
        p params
        if params[:key] != ENV['API_TOKEN']
            raise AidviceExceptions::UnauthorizedOperation
        end
    end
    
end