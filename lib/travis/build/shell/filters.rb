module Travis
  module Build
    module Shell
      module Filters
        module Assertion
          def code
            options[:assert] ? assert(super) : super
          end

          def assert(code)
            "#{code}\ntravis_assert"
          end
        end

        module Timing
          def code
            timing = options[:timing]
            echo = options[:echo]
            timing && echo ? measure(super) : super
          end

          def measure(code)
            code = "( time #{code} 2>&3; ) 3>&2 2> /tmp/timing.out"
            "travis_time_start\n#{code}\ntravis_time_finish"
          end
        end

        module Echoize
          def code
            echo = options[:echo]
            echo ? echoize(super, echo.is_a?(String) ? echo : nil) : super
          end

          def echoize(code, echo = nil)
            "echo #{escape("$ #{echo || @code}")}\n#{code}"
          end
        end

        module Retry
          def code
            options[:retry] ? add_retry(super) : super
          end

          def add_retry(code)
            "travis_retry #{code}"
          end
        end
      end
    end
  end
end
