require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |t|
  t.rcov = true
  t.rcov_opts = ["-xspec,Library,gems,site"]
end
task :default => :spec
