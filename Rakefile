# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:spec) do |rubocop|
  rubocop.options << '--auto-correct'
  rubocop.options << '--display-cop-names'
  rubocop.options << '--extra-details'
  rubocop.options << '--display-style-guide'
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb'] # optional
  # t.options = ['--any', '--extra', '--opts'] # optional
  t.options = ['-Mredcarpet', '--plugin', 'yard-struct']
  t.stats_options = ['--list-undoc'] # optional
end

desc 'YARD Server'
task :'yard-server' do
  `yard server`
end

desc 'analyze langauges in use'
task linguist: :build do
  puts `github-linguist`
end

task default: :spec
task test: :spec
task 'yard-server': :yard
task 'yard-server': :build
