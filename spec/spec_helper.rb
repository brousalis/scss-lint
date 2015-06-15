require 'scss_lint'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

def lint(style, syntax)
  initial_indent = style[/\A(\s*)/, 1]
  normalized = style.gsub(/^#{initial_indent}/, '')

  local_config = if respond_to?(:linter_config)
                   linter_config
                 else
                   SCSSLint::Config.default.linter_options(subject)
                 end

  if style
    subject.run(SCSSLint::Engine.new({code: normalized}, syntax), local_config)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end

  config.mock_with :rspec do |c|
    c.syntax = :should
  end

  config.before(:each) do
    # If running a linter spec, run the described linter against the CSS code
    # for each example. This significantly DRYs up our linter specs to contain
    # only tests, since all the setup code is now centralized here.
    if described_class <= SCSSLint::Linter
      if defined? scss
        lint(scss, :scss)
      elsif defined? sass
        lint(sass, :sass)
      end
    end
  end
end
