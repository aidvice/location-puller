class Api::GeolocationController < ApplicationController
    def index
        begin
        	input = params[:ltdlng]

        	check_input_params

        	google_api_key = ENV['GOOGLE_API_KEY']

        	parse_input = input.split(',')
        	latitude = parse_input[0]
        	longitude = parse_input[1]

        	request_url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' + latitude + ',' + longitude + '&key=' + google_api_key

        	google_geocoding_parsed_response = JSON.parse(HTTP.get(request_url).to_s)
        	address_components = google_geocoding_parsed_response["results"].first["address_components"]


        	location = {
        		numero: address_components.first["long_name"],
        		nome_da_rua: address_components[1]["long_name"],
        		bairro: address_components[2]["long_name"],
        		cidade: address_components[3]["long_name"],
        		estado: address_components[4]["long_name"] + ', ' + address_components[4]["short_name"],
        		pais: address_components[5]["long_name"] + ', ' + address_components[5]["short_name"],
        		CEP: address_components[6]["long_name"]
        	}

        	render json: location
        rescue AidviceExceptions::BadParameters
        	Rails.logger.info "Error"
        	render json: {message: "Parâmetros incorretos. Espera-se: ltdlng=x,y."}, status: 400
        rescue => e
        	Rails.logger.error e.message
        	Rails.logger.error e.backtrace.join("\n")
        end
    end

    def check_input_params
    	if params[:ltdlng].nil? || params[:ltdlng].split(',').size != 2
    		raise AidviceExceptions::BadParameters
    	end
    end
end