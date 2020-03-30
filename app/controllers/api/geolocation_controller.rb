class Api::GeolocationController < Api::ApiController
	before_action :check_api_token

    def index
		begin
			if !params[:ltdlng].nil?
				input = params[:ltdlng]

				check_input_params

				parse_input = input.split(',')
				latitude = parse_input[0]
				longitude = parse_input[1]

				location = get_location(latitude, longitude)
				cases = get_cases(location[:estado][-2..-1])
				
				render json: location.merge(cases)
			elsif !params[:uf].nil?
				cases = get_cases(params[:uf])

				render json: cases
			end

		rescue AidviceExceptions::UnauthorizedOperation
			render status: 401
        rescue AidviceExceptions::BadParameters
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

    def get_location(latitude, longitude)
		google_api_key = ENV['GOOGLE_API_KEY']
		
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

    	return location
    end
    def get_cases(estado)
    	request_url = "https://covid19-brazil-api.now.sh/api/report/v1/brazil/uf/" + estado
    	response_parsed = JSON.parse(HTTP.get(request_url).to_s)

    	output = {
    		casos_no_estado: response_parsed["cases"],
    		mortos_no_estado: response_parsed["deaths"],
    		suspeitos_no_estado: response_parsed["suspects"],
    		ultima_atualizacao_no_estado: response_parsed["datetime"]
    	}

    	return output
    end
end