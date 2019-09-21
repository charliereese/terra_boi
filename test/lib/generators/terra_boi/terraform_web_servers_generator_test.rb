require 'test_helper'
require 'generators/terra_boi/web_servers_generator'

module TerraBoi
  class WebServersGeneratorTest < Rails::Generators::TestCase
    tests WebServersGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    test "generator runs without errors" do
      assert_nothing_raised do
        run_generator ["arguments"]
      end
    end
  end
end
