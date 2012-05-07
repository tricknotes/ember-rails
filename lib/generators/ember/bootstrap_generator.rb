require 'generators/ember/generator_helpers'

module Ember
  module Generators
    class BootstrapGenerator < ::Rails::Generators::Base
      include Ember::Generators::GeneratorHelpers

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a default Ember.js folder layout in app/assets/javascripts/ember"

      class_option :skip_git, :type => :boolean, :aliases => "-g", :default => false, :desc => "Skip Git keeps"

      def inject_ember
        application_file = "app/assets/javascripts/application.js"

        inject_into_file(application_file, :before => "//= require_tree") do
          dependencies = [
            "//= require ember",
            "//= require ember-data",
            "//= require_self",
            "//= require #{application_name.underscore}",
            "#{application_name.camelize} = Ember.Application.create();"
          ]
          dependencies.join("\n").concat("\n")
        end
      end

      def create_dir_layout
        %W{models controllers views states helpers templates}.each do |dir|
          empty_directory "#{ember_path}/#{dir}"
          create_file "#{ember_path}/#{dir}/.gitkeep" unless options[:skip_git]
        end
      end

      def create_app_file
        template "app.js", "#{ember_path}/#{application_name.underscore}.js"
      end

      def create_state_manager_file
        template "states.js", "#{ember_path}/states/app_states.js"
      end
    end
  end
end