# encoding: utf-8

# Gem development tasks
require "bundler/gem_tasks"

# Import Rspec rake tasks, with spec as default
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

begin
  require 'bundler'
rescue LoadError => e
  warn("warning: Could not load bundler: #{e}")
  warn("         Some rake tasks will not be defined")
else
  Bundler::GemHelper.install_tasks
end

namespace :annotate do
  desc "Annotates Gemfile"
  task :gemfile, :gempath do |t, args|
    require 'rubygems'
    require 'annotate_gemfile'

    gemfile_path = args[:gempath]
    gemfile_path ||= File.dirname(__FILE__) + '/Gemfile'    

    puts "AnnotateGemfile Version: #{AnnotateGemfile::Version::STRING}"
    puts "Gemfile Path: #{gemfile_path.inspect}"

    annotater = AnnotateGemfile::Annotator.new(gemfile_path)
    parser = AnnotateGemfile::Parser.parse(gemfile_path)
    gemfile_array = parser.gemfile_array
    gemfile_meta = parser.gemfile_meta

    puts "Gemfile Meta\n--------\n#{gemfile_meta.inspect}\n--------"
  end
end