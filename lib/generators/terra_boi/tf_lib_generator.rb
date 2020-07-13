require "generators/extensions"

module TerraBoi
	class TfLibGenerator < Rails::Generators::Base
		attr_accessor :application_name
		source_root File.expand_path('templates', __dir__)

		TEMPLATES = {
			scripts: [
				"push_to_ecr.sh",
				"update_service_pull_from_ecr.sh",
			],
			task_templates: [
				"web_app.json",
				"head_worker.json",
			],
			terraform_modules: [
				"ecs_cluster/main.tf",
				"ecs_cluster/var.tf",

				"ecs_web_app/ecs_role.tf",
				"ecs_web_app/load_balancer.tf",
				"ecs_web_app/main.tf",
				"ecs_web_app/output.tf",
				"ecs_web_app/var.tf",

				"ecs_worker/ecs_role.tf",
				"ecs_worker/main.tf",
				"ecs_worker/output.tf",
				"ecs_worker/var.tf",
			]
		}

		desc (<<-EOF
			Generate lib directory with templates, scripts, and modules for deploying application containers to AWS ECS
			
			To execute, run rails generate terra_boi:lib
			EOF
			.gsub(/\t/, '')
		)

		def init
			# defined in lib/generators/extensions
			self.application_name = generate_application_name
		end

		def create_ecr
			TEMPLATES.each do |dir, file_arr|
				file_arr.each do |filename|
					template "lib/#{dir}/#{filename}.erb", "terraform_v2/lib/#{dir}/#{filename}" 
				end
			end
		end
	end
end