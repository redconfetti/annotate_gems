# encoding: utf-8

module AnnotateGemfile
  class Parser

    GEM_DEFINITION_REGEX = /^\s*gem\s*["'][a-zA-Z0-9_-]*["']/
    GEM_NAME_EXTRACT_REGEX = /^\s*gem\s*["'](.*?)["']/

    def self.datetime_string
      Time.now.strftime("%m-%d-%y-%H_%M_%S")
    end

    def self.is_gem_definition?(line)
      line.match(GEM_DEFINITION_REGEX) ? true : false
    end

    def self.extract_gemname(line)
      raise ArgumentError, "Argument string does not contain gem definition" unless self.is_gem_definition?(line)
      line.match(GEM_NAME_EXTRACT_REGEX)[1]
    end

    def initialize(gemfile_path)
      @gemfile_path     = gemfile_path
      @gemfile_array    = []
      @gemfile_meta = []
      @gem_dependencies = []
      load_gemfile(@gemfile_path)
    end

    def load_gemfile(filepath)
      raise IOError, "Gemfile not found at #{filepath}" unless File.exist?(filepath)
      @gemfile_contents = IO.read(filepath)
    end

    def remove_commented_lines
      @gemfile_contents.gsub!(/^\s*#.*\n+/,'')
    end

    def load_gemfile_array
      raise RuntimeError, "Gemfile contents not present" if @gemfile_contents.nil?
      @gemfile_array = @gemfile_contents.lines.to_a
    end

    def load_dependencies
      builder = Bundler::Dsl.new
      @gem_dependencies = builder.eval_gemfile(@gemfile_path)
    end

    def build_meta_array
      raise RuntimeError, "Gemfile lines not loaded" if @gemfile_array.empty?
      @gemfile_array.each_with_index do |line,index|
        if self.class.is_gem_definition?(line)
          gem_name = self.class.extract_gemname(line)
          @gemfile_meta << { :line => index, :name => gem_name }
        end
      end
      @gemfile_meta
    end

  end # Parser
end # AnnotateGemfile
