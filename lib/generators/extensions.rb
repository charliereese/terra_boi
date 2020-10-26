module TerraBoi
	module GeneratorHelpers
		# https://api.rubyonrails.org/classes/Rails/Generators/NamedBase.html#method-i-application_name
		def generate_application_name(separators: false)
			if defined?(Rails) && Rails.application
        app_name = Rails.application.class.name.split("::").first.underscore
        unless separators
          app_name = app_name.gsub('_', '') 
        end

        app_name
      else
        "application"
      end
    end

    def generate_terraform_files(args)
      args[:env].each do |env|
        template(args[:template], 
          "terraform_v2/#{env}/#{args[:file_path]}",
          {
            env: env,
            domain_name: (class_options && class_options[:domain_name]) || generate_application_name + '.com'
          }
        )
      end
    end
  end
end

class Rails::Generators::Base
  include TerraBoi::GeneratorHelpers
end
  
