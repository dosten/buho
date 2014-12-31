#!/usr/bin/env ruby

require "buho/version"

require 'rubygems'
require 'optparse'
require 'listen'
require 'haml'

##
# Buho module
#
module Buho

  ##
  # Watcher class
  #
  class Watcher

    ##
    # Watch changes, compile and save it
    #
    def watch

      # Input dir
      @input  = nil

      # Output dir
      @output = nil

      # Compiled HTML
      @compiled = nil

      # Gem name
      puts "\n","-" * 41
      puts " Buho #{Buho::VERSION}"
      puts " Copyright (c) 2013 Diego Saint Esteben"
      puts "-" * 41, "\n"

      # Options
      self.opts

      # Print input/output paths
      puts "Input dir: #{@input}"
      puts "Output dir: #{@output}"

      # Ready to watch..
      puts "\nReady to watch...\n\n"

      # Listen
      Listen.to(@input, :filter => /\.haml$/, :relative_paths => true) do |modified, added, removed|

        # Walk into modified files
        modified.each do |path|

          # Paths
          input  = File.join(@input, path)
          output = File.join(@output, path).gsub!('.haml', '.html')

          # Watching message
          puts ">> Watching #{input}"

          # Compile HAML file and save in @compiled
          self.compile input

          # Write HTML into output path
          self.write output

          # Compilation successfully
          puts ">> Compiling #{input} into #{output}"
        end
      end
    end

    ##
    # Configure CLI options
    #
    def opts

      # Handle CLI options
      OptionParser.new do |opts|

        # Set separator
        opts.separator nil

        # Option to set input directory or raise a exception if not exists
        opts.on('-i', '--input [dir]', String, 'Set input directory.', 'If omit this option, input path has been used instead') do |i|
          begin
            @input = File.join('.', i)
            raise IOError unless File.exists? @input
          rescue IOError
            puts ">> Error: Input directory not found\n\n"
            exit
          end
        end

        # Option to set output directory or raise a exception if not exists
        opts.on('-o', '--output [dir]', String, 'Set output directory.') do |o|
          @output = File.join('.', o)
        end

        # Show help info
        opts.on('-h', '--help', 'Show help info.') do
          puts opts;
          exit
        end

        # Parse!
        opts.parse!
      end

      begin
        raise OptionParser::MissingArgument if @input == nil
      rescue OptionParser::MissingArgument
        puts ">> Error: Missing argument --input\n\n"
        exit
      end

      # If output dir has not been defined, use input dir instead
      @output ||= @input
    end

    ##
    # Compile HAML
    #
    def compile(path)
      begin
        # Read HAML and compile it
        haml = File.open(path).read
        @compiled = Haml::Engine.new(haml).render
      rescue Haml::Error => e
        #Error compiling message
        puts ">> Error: \"#{e.message}\" at line #{e.line}"
      end
    end

    ##
    # Write compiled HTML into HTML file
    #
    def write(path)

      # Create directory tree
      dirname = File.dirname(path)
      FileUtils.mkdir_p(dirname)

      # Save compiled HTML into file
      File.open(path, 'w') do |f|
        f << @compiled
      end
    end
  end
end