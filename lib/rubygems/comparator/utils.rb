require 'rainbow'

class Gem::Comparator
  module Utils
    include Gem::UserInteraction

    SPACE = ' '
    DEFAULT_INDENT = SPACE*7
    OPERATORS = ['=', '!=', '>', '<', '>=', '<=', '~>']
    VERSION_REGEX = /\A(\d+\.){0,}\d+(\.[a-zA-Z]+\d{0,1}){0,1}\z/
    SHEBANG_REGEX = /\A#!.*/
    SPEC_PARAMS = %w[ author
                      authors
                      bindir
                      cert_chain
                      date
                      description
                      email
                      executables
                      extensions
                      has_rdoc
                      homepage
                      license
                      licenses
                      metadata
                      name
                      platform
                      post_install_message
                      rdoc_options
                      require_paths
                      required_ruby_version
                      required_rubygems_version
                      requirements
                      rubygems_version
                      signing_key
                      summary
                      version ]
    SPEC_FILES_PARAMS = %w[ files
                            test_files
                            extra_rdoc_files ]
    DEPENDENCY_PARAMS = %w[ runtime_dependency
                            development_dependency ]
    GEMFILE_PARAMS = %w[ gemfiles ]

    # Duplicates or obvious changes
    FILTER_WHEN_BRIEF = %w[ author
                            date
                            license
                            platform
                            rubygems_version
                            version ]

    private

      def param_exists?(param)
        (SPEC_PARAMS.include? param) ||
        (SPEC_FILES_PARAMS.include? param) ||
        (DEPENDENCY_PARAMS.include? param) ||
        (GEMFILE_PARAMS.include? param)
      end

      def filter_params(params, param, brief_mode = false)
        if param
          if params.include? param
            return [param]
          else
            return []
          end
        end
        if brief_mode
          filter_for_brief_mode(params)
        else
          params
        end
      end

      def filter_for_brief_mode(params)
        params.delete_if{ |p| FILTER_WHEN_BRIEF.include?(p) }
      end

      ##
      # Print info only in verbose mode

      def info(msg)
        say msg if Gem.configuration.really_verbose
      end

      def warn(msg)
        say Rainbow("WARNING: #{msg}").red
      end

      def error(msg)
        say Rainbow("ERROR: #{msg}").red
        exit 1
      end
  end
end