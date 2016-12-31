# frozen_string_literal: true

require_relative './lib/piktur/docs'

namespace :yard do
  desc 'Fetch source code from remote repository'
  task :prepare do
    puts 'Fetching remote source'
    Piktur::Docs.prepare
    puts 'Finished'
  end

  libs = Dir[Piktur.root.parent.join('piktur_*')].collect! { |e| File.basename(e) }

  # @see YARD::CLI::YardoptsCommand#parse_arguments
  defaults = %w(
    --verbose
    --backtrace
    --debug
    --protected
    --private
    --embed-mixins
    --hide-void-return
    --use-cache
    --markup
    markdown
    --markup-provider
    redcarpet
    --exclude
    db/migrate/**
    --exclude
    spec/**
  )
  # Frozen string literal seems to break this
  # --single-db
  # --use-cache

  desc 'Generate YARD Documentation for all libraries'
  # @example
  #   rake yard
  #   rake yard OPTS='--override --default --opts'
  # @see file:.yardopts
  YARD::Rake::YardocTask.new do |t|
    options = defaults.dup
    options.unshift('--db', '.yardoc')

    t.name    = :all
    t.options = defaults
    t.files   = %w(
      piktur_core
      piktur_api
      lib
      -
      **/README.markdown
    )
    # t.files = libs << ./lib

    t.stats_options = %w(--list-undoc)
  end

  libs.each do |lib|
    desc "Generate YARD Documentation for #{lib}"
    YARD::Rake::YardocTask.new do |t|
      # Piktur::Docs.root.relative_path_from(Piktur.root.parent).join(lib)
      path    = Piktur::Docs.root.join(lib)
      options = defaults.dup
      options.push('--output-dir', lib)

      yardoc = path.join('.yardoc')
      options.unshift('--db', yardoc.to_s)

      if (yardopts = path.join('.yardopts')).exist?
        yardopts.each_line.with_object(options) do |e, a|
          a.push(*e.split(/\s/))
        end
      end

      source_path     = Piktur.root.parent.join(lib)
      t.name          = lib.split('piktur_')[-1]
      t.files         = %W(
        #{source_path}
        -
        #{lib}/README.markdown
      )
      t.options       = options
      t.stats_options = %w(--list-undoc)

      # t.before        = lambda do
      #   (libs - [lib]).select do |e|
      #     yardoc = "docs/#{e}/.yardoc"
      #     # YARD::Registry.load_yardoc(yardoc) if File.exist?(yardoc)
      #     YARD::Registry.load!(yardoc) if File.exist?(yardoc)
      #   end
      # end
    end
  end
end
