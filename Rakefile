require 'open3'
require_relative './lib/piktur/docs.rb'

# @see YARD::CLI::YardoptsCommand#parse_arguments
# @return [Array]
def default_yardopts
  Piktur::Docs::YARDOPTS.split(/\s/)
end

# @return [Array]
def default_files
  Piktur::Docs::FILES.split(/\s/)
end

# @return [Array]
def add_local_yardopts(path, options = [])
  path     = Pathname(path)
  yardopts = path.join('.yardopts')
  return unless yardopts.exist?
  yardopts.each_line.with_object(options) do |ln, a|
    a.push(*ln.split(/\s/))
  end
end

libraries = {}
Piktur::Docs.libraries.each do |name, (libver)|
  # Access gem info with `libver.gemspec` ie. `libver.gemspec.version`
  next unless (path = libver.source_path)
  libraries[name] = path
end

namespace :yard do
  libraries.each do |name, path|
    desc "Generate YARD Documentation for #{name}"
    task name do
      # yardoc [options] [source_files [- extra_files]]
      # cmd = "yardoc #{default_yardopts.join(' ')} #{default_files.join(' ')}"
      Open3.popen3('yardoc', chdir: path) do |i, o, e|
        puts o.gets until o.eof?
        puts e.gets until o.eof?
      end
    end
  end

  desc 'Generate YARD Documentation for all libraries'
  task :all do
    libraries.each_key { |name| Rake::Task["yard:#{name}"].invoke }
  end
end
