require 'spec_helper'

describe SCSSLint::Linter::ImportPath do
  context 'when the path includes no directories' do
    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "filename";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "filename"' }

        it { should_not report_lint }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "_filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "_filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "filename.scss"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "_filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "_filename.scss"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and multiple files are @imported' do
      context 'and neither have leading underscores or filename extensions' do
        context 'scss' do
          let(:scss) { '@import "foo", "bar";' }

          it { should_not report_lint }
        end

        context 'sass' do
          let(:sass) { '@import "foo", "bar"' }

          it { should_not report_lint }
        end
      end

      context 'and the second has a leading underscore' do
        context 'scss' do
          let(:scss) { '@import "foo", "_bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "foo", "_bar"' }

          it { should report_lint line: 1 }
        end
      end

      context 'and the first has a filename extension' do
        context 'scss' do
          let(:scss) { '@import "foo.scss", "bar";' }

          it { should report_lint line: 1 }
        end

        xcontext 'sass' do
          let(:sass) { '@import "foo.sass", "bar"' }

          it { should report_lint line: 1 }
        end
      end
    end
  end

  context 'when the path includes directories' do
    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/filename";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/filename"' }

        it { should_not report_lint }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "../to/_filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "../to/_filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "/path/to/filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "/path/to/filename.scss"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/_filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/_filename.scss"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and multiple files are @imported' do
      context 'and neither have leading underscores or filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo", "../../bar";' }

          it { should_not report_lint }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo", "../../bar"' }

          it { should_not report_lint }
        end
      end

      context 'and the second has a leading underscore' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo", "../../_bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo", "../../_bar"' }

          it { should report_lint line: 1 }
        end
      end

      context 'and the first has a filename extension' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo.scss", "../../bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo.scss", "../../bar"' }

          it { should report_lint line: 1 }
        end
      end
    end
  end

  context 'when option `leading_underscore` is true' do
    let(:linter_config) { { 'leading_underscore' => true } }

    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "../to/_filename";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "../to/_filename"' }

        it { should_not report_lint }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "/path/to/filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "/path/to/filename.sass"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/_filename.scss";' }

        it { should report_lint line: 1 }
      end

      xcontext 'sass' do
        let(:sass) { '@import "path/to/_filename.sass"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and multiple files are @imported' do
      context 'and neither have leading underscores or filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo", "../../bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo", "../../bar"' }

          it { should report_lint line: 1 }
        end
      end

      context 'and both have a leading underscore' do
        context 'scss' do
          let(:scss) { '@import "path/to/_foo", "../../_bar";' }

          it { should_not report_lint }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/_foo", "../../_bar"' }

          it { should_not report_lint }
        end
      end

      context 'and only one has a leading underscore' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo.scss", "../../_bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo.scss", "../../_bar"' }

          it { should report_lint line: 1 }
        end
      end
    end
  end

  context 'when option `filename_extension` is true' do
    let(:linter_config) { { 'filename_extension' => true } }

    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "../to/_filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "../to/_filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "/path/to/filename.scss";' }

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { '@import "/path/to/filename.sass"' }

        it { should_not report_lint }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/_filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/_filename.sass"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and multiple files are @imported' do
      context 'and neither have leading underscores or filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo", "../../bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo", "../../bar"' }

          it { should report_lint line: 1 }
        end
      end

      context 'and both have filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo.scss", "../../bar.scss";' }

          it { should_not report_lint }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo.scss", "../../bar.scss"' }

          it { should_not report_lint }
        end
      end

      context 'and only one has a filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo.scss", "../../bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo.scss", "../../bar"' }

          it { should report_lint line: 1 }
        end
      end
    end
  end

  context 'when options `leading_underscore` and `filename_extension` are true' do
    let(:linter_config) { { 'leading_underscore' => true, 'filename_extension' => true } }

    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "path/to/filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "../to/_filename";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "../to/_filename"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "/path/to/filename.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "/path/to/filename.sass"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "path/to/_filename.scss";' }

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { '@import "path/to/_filename.sass"' }

        it { should_not report_lint }
      end
    end

    context 'and multiple files are @imported' do
      context 'and neither have leading underscores or filename extensions' do
        context 'scss' do
          let(:scss) { '@import "path/to/foo", "../../bar";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/foo", "../../bar"' }

          it { should report_lint line: 1 }
        end
      end

      context 'and both have filename extensions and leading underscores' do
        context 'scss' do
          let(:scss) { '@import "path/to/_foo.scss", "../../_bar.scss";' }

          it { should_not report_lint }
        end

        xcontext 'sass' do
          let(:sass) { '@import "path/to/_foo.scss", "../../_bar.sass"' }

          it { should_not report_lint }
        end
      end

      context 'and only one has both a filename extension and a leading underscore' do
        context 'scss' do
          let(:scss) { '@import "path/to/_foo.scss", "../../bar.scss";' }

          it { should report_lint line: 1 }
        end

        context 'sass' do
          let(:sass) { '@import "path/to/_foo.sass", "../../bar.sass"' }

          it { should report_lint line: 1 }
        end
      end
    end
  end

  context 'when the @import directive compiles directly to a CSS @import rule' do
    context 'and the @import is a CSS file' do
      context 'scss' do
        let(:scss) { '@import "_foo.css";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "_foo.css"' }

        it { should_not report_lint }
      end
    end

    context 'and the @import contains a protocol' do
      context 'scss' do
        let(:scss) { '@import "http://foo.com/_bar.css";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "http://foo.com/_bar.css"' }

        it { should_not report_lint }
      end
    end

    context 'and the @import contains a media query' do
      context 'scss' do
        let(:scss) { '@import "_foo.css" screen;' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "_foo.css" screen' }

        it { should_not report_lint }
      end
    end

    context 'and the @import is a URL' do
      context 'scss' do
        let(:scss) { '@import url(_foo.css);' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import url(_foo.css)' }

        it { should_not report_lint }
      end
    end

    context 'and the @import contains interpolation' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          $family: unquote("Droid+Sans");
          @import url("http://fonts.googleapis.com/css?family=\#{$family}");
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          $family: unquote("Droid+Sans")
          @import url("http://fonts.googleapis.com/css?family=\#{$family}")
        SASS

        it { should_not report_lint }
      end
    end
  end

  context 'when the partial has the same name as its directory' do
    context 'and the filename has no leading underscore or filename extension' do
      context 'scss' do
        let(:scss) { '@import "foo/foo";' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '@import "foo/foo"' }

        it { should_not report_lint }
      end
    end

    context 'and the filename has a leading underscore' do
      context 'scss' do
        let(:scss) { '@import "_foo/_foo";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "_foo/_foo"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a filename extension' do
      context 'scss' do
        let(:scss) { '@import "foo/foo.scss";' }

        it { should report_lint line: 1 }
      end

      xcontext 'sass' do
        let(:sass) { '@import "foo/foo.sass"' }

        it { should report_lint line: 1 }
      end
    end

    context 'and the filename has a leading underscore and a filename extension' do
      context 'scss' do
        let(:scss) { '@import "_foo/_foo.scss";' }

        it { should report_lint line: 1 }
      end

      context 'sass' do
        let(:sass) { '@import "_foo/_foo.sass"' }

        it { should report_lint line: 1 }
      end
    end
  end
end
