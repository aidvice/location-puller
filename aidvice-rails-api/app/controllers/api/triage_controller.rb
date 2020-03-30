class Api::TriageController < ApplicationController
    def index
        begin
            check_params

            user_input = params
            user_score = {}
            user_score[:dengue] = calcula_score_dengue(user_input)
            user_score[:gripe] = calcula_score_gripe(user_input)
            user_score[:covid] = calcula_score_covid(user_input)
        
            symptoms_highlights = get_symptoms_highlights(user_input)
        
            max_score = {
                dengue: 12.6,
                covid: 8.4,
                gripe: 6.4
            }

            user_score_normalizado = {
                score_dengue: (user_score[:dengue]/max_score[:dengue]).round(4),
                score_covid: (user_score[:covid]/max_score[:covid]).round(4),
                score_gripe: (user_score[:gripe]/max_score[:gripe]).round(4)
            }

            render json: user_score_normalizado.merge(highlights: symptoms_highlights)
        rescue AidviceExceptions::BadParameters
            render json: {message: "Parâmetros incorretos."}, status: 400
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    def calcula_score_covid(user_input) 
        score = 0
        score += 1.2 if user_input[:tosse]
        score += 1.2 if user_input[:febre]
        score += 1.2 if user_input[:cansaco]
        score += 1.2 if user_input[:dificuldade_respirar]
        score += 1 if user_input[:dor_peito]
        score += 1 if user_input[:dor_cabeca]
        score += 1 if user_input[:dor_garganta]
        score += 0.6 if user_input[:diarreia]

        return score.round(1)
    end
    def calcula_score_dengue(user_input)
        score = 0
        score += 1.2 if user_input[:febre_subita]
        score += 1.2 if user_input[:dor_muscular]
        score += 1.2 if user_input[:dor_olhos]
        score += 1 if user_input[:coceira]
        score += 1 if user_input[:manchas_erupcoes]
        score += 1 if user_input[:falta_apetite]
        score += 1 if user_input[:dor_cabeca]
        score += 1 if user_input[:dor_ossos]
        score += 1 if user_input[:dor_abdomen]
        score += 1 if user_input[:cansaco]
        score += 0.8 if user_input[:nausea_vomito]
        score += 0.8 if user_input[:diarreia]
        score += 0.4 if user_input[:febre]
        
        return score.round(1)
    end
    def calcula_score_gripe(user_input)
        score = 0
        score += 1.2 if user_input[:febre]
        score += 1.2 if user_input[:dor_muscular]
        score += 1 if user_input[:dor_cabeca]
        score += 1 if user_input[:coriza]
        score += 1 if user_input[:dor_garganta]
        score += 1 if user_input[:tosse]

        return score.round(1)
    end
    def get_symptoms_highlights(user_input)
        symptoms_highlights = []
        if user_input[:tosse] && user_input[:febre] && user_input[:dificuldade_respirar] && user_input[:cansaco]
            symptoms_highlights << {
                doenca: "covid",
                sintomas_chave: ["tosse seca", "febre", "dificuldade para respirar", "cansaço"]
            }
        end
        if user_input[:febre] && user_input[:febre_subita] && user_input[:dor_olhos] && user_input[:dor_muscular]
            symptoms_highlights << {
                doenca: "dengue",
                sintomas_chave: ["febre súbita", "dor atrás dos olhos", "dor muscular"]
            }
        end
        if user_input[:febre] && user_input[:dor_muscular] && !user_input[:febre_subita] && user_input[:coriza]
            symptoms_highlights << {
                doenca: "gripe",
                sintomas_chave: ["febre", "dor muscular", "coriza"]
            }
        end

        return symptoms_highlights
    end
    
    
    def check_params
        mandatory_params = get_mandatory_params
        json_params = params
        json_params_keys = params.keys - ['controller', 'action', 'triage']

        if !((mandatory_params & json_params_keys) == mandatory_params) || !(17..18).include?(json_params_keys.size) || (json_params.keys.map! {|key| !!json_params[key] == json_params[key] if !['controller', 'action', 'triage'].include?(key)}).include?(false)
            raise AidviceExceptions::BadParameters
        end
    end
    def get_mandatory_params
        return ['febre', 'dor_muscular', 'cansaco', 'tosse', 'dificuldade_respirar',
        'dor_peito', 'dor_garganta', 'dor_cabeca', 'diarreia', 'dor_olhos', 'manchas_erupcoes',
        'falta_apetite', 'dor_ossos', 'nausea_vomito', 'dor_abdomen', 'coriza', 'coceira']
    end
end

