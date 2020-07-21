require 'byebug'

module TerraBoi
	class Railtie < ::Rails::Railtie
		rake_tasks do
			load 'tasks/terra_boi_tasks.rake'
		end
	end
end
