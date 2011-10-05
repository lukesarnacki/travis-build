require 'hashr'

module Travis
  module Build
    module Job
      class Test
        class Ruby < Test
          class Config < Hashr
            define :rvm => 'default', :gemfile => 'Gemfile'
          end

          def setup
            super
            setup_ruby
            setup_bundler if gemfile?
          end

          def install
            bundle_install if gemfile?
          end

          protected

            def setup_ruby
              shell.execute("rvm use #{config.rvm}")
            end

            def setup_bundler
              shell.export('BUNDLE_GEMFILE', "#{shell.cwd}/#{config.gemfile}")
            end

            def gemfile?
              shell.file_exists?(config.gemfile)
            end

            def bundle_install
              shell.execute("bundle install #{config.bundler_args}".strip, :timeout => :install)
            end
            assert :bundle_install

            def script
              if config.script?
                config.script
              elsif gemfile?
                'bundle exec rake'
              else
                'rake'
              end
            end
        end
      end
    end
  end
end