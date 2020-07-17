require "generators/extensions"

module TerraBoi
	class TfCertGenerator < Rails::Generators::Base
		attr_accessor :application_name, :class_options
		class_option :domain_name, type: :string, default: 'example.com', aliases: ["d"]
		source_root File.expand_path('templates', __dir__)

		desc (<<-EOF
			Generate HTTPS cert for domain
			
			To execute, run rails generate terra_boi:tf_cert
			EOF
			.gsub(/\t/, '')
		)

		def init
			# defined in lib/generators/extensions
			self.application_name = generate_application_name
			self.class_options = options
		end

		def create_cert
			template "cert/main.tf.erb", "terraform/cert/main.tf"
			template "cert/var.tf.erb", "terraform/cert/var.tf"
		end
	end
end