require 'spec_helper'

describe SCSSLint::Linter::EmptyLineBetweenBlocks do
  context 'when there are multiple rule sets' do
    context 'with blank lines between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          a {
          }

          b {
          }

          p {
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          a

          b

          p
        SASS

        it { should_not report_lint }
      end
    end

    context 'with no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          a {
          }
          b {
          }
          p {
          }
        SCSS

        it { should report_lint line: 2 }
        it { should report_lint line: 4 }
        it { should_not report_lint line: 6 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          a
          b
          p
        SASS

        it { should report_lint line: 1 }
        it { should report_lint line: 2 }
        it { should_not report_lint line: 3 }
      end
    end
  end

  context 'when a rule set contains nested rule sets' do
    context 'and the nested rule sets have no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            a {
            }
            b {
            }
          }
        SCSS

        it { should report_lint line: 3 }
        it { should_not report_lint line: 5 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          p
            a
            b
        SASS

        it { should report_lint line: 2 }
        it { should_not report_lint line: 3 }
      end
    end

    context 'and the nested rule sets have a blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            a {
            }

            b {
            }
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          p
            a

            b
        SASS

        it { should_not report_lint }
      end
    end

    context 'and the nested rule set has a property preceding it' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            margin: 0;
            a {
            }
          }
        SCSS

        it { should report_lint line: 3 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          p
            margin: 0
            a
        SASS

        it { should report_lint line: 3 }
      end
    end

    context 'and the nested rule set has a property and empty line preceding it' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            margin: 0;

            a {
            }
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          p
            margin: 0

            a
        SASS

        it { should_not report_lint }
      end
    end
  end

  context 'when a rule set is in an @if statement with an @else following it' do
    let(:scss) { <<-SCSS }
      @if $condition {
        p {
        }
      } @else {
        p {
        }
      }
    SCSS

    it { should_not report_lint }
  end

  context 'when mixins are defined' do
    context 'and there is no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @mixin mixin1() {
          }
          @mixin mixin2() {
          }
        SCSS

        it { should report_lint line: 2 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          +mixin1()
          +mixin2()
        SASS

        it { should report_lint line: 2 }
      end
    end

    context 'and there is a blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @mixin mixin1() {
          }

          @mixin mixin2() {
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          +mixin1()

          +mixin2()
        SASS

        it { should_not report_lint }
      end
    end
  end

  context 'when mixins are included without content' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          @include mixin1();
          property: blah;
          @include mixin2(4);
        }
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        p
          +mixin1()
          property: blah
          +mixin2(4)
      SASS

      it { should_not report_lint }
    end
  end

  context 'when mixins are included with content' do
    context 'and there is no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @include mixin1() {
            property: value;
          }
          @include mixin2() {
            property: value;
          }
        SCSS

        it { should report_lint line: 3 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          +mixin1()
            property: value
          +mixin2()
            property: value
        SASS

        it { should report_lint line: 3 }
      end
    end

    context 'and there is a blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @include mixin1() {
            property: value;
          }

          @include mixin2() {
            property: value;
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          +mixin1()
            property: value

          +mixin2()
            property: value
        SASS

        it { should_not report_lint }
      end
    end
  end

  context 'when functions are defined' do
    context 'and there is no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @function func1() {
          }
          @function func2() {
          }
        SCSS

        it { should report_lint line: 2 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          @function func1()
          @function func2()
        SASS

        it { should report_lint line: 2 }
      end
    end

    context 'and there is a blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @function func1() {
          }

          @function func2() {
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          @function func1()

          @function func2()
        SASS

        it { should_not report_lint }
      end
    end
  end

  context 'when a rule set is preceded by a comment' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
        }

        // This is a comment
        p {
        }
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        a

        // This is a comment
        p
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a rule set is immediately followed by a comment' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
        } // A comment

        a {
        } /* Another comment */
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        a // A comment

        a /* Another comment */
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule set is followed by a comment on the next line' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
        }
        // A trailing comment (often a control comment)

        b {
        }
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        a
        // A trailing comment (often a control comment)

        b
      SASS

      it { should_not report_lint }
    end
  end

  context 'when there are multiple placeholder rule sets' do
    context 'with blank lines between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          %a {
          }

          %b {
          }

          %c {
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          %a

          %b

          %c
        SASS

        it { should_not report_lint }
      end
    end

    context 'with no blank line between them' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          %a {
          }
          %b {
          }
          %c {
          }
        SCSS

        it { should report_lint line: 2 }
        it { should report_lint line: 4 }
        it { should_not report_lint line: 6 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          %a
          %b
          %c
        SASS

        it { should report_lint line: 1 }
        it { should report_lint line: 2 }
        it { should_not report_lint line: 3 }
      end
    end
  end

  context 'when blocks occupy a single line' do
    let(:linter_config) { { 'ignore_single_line_blocks' => ignore_single_line_blocks } }

    let(:scss) { <<-SCSS }
      .icon-up { &:before { content: '^'; } }
      .icon-right { &:before { content: '>'; } }
      @include some-mixin { content: '<'; }
      @include some-other-mixin { content: 'v'; }
    SCSS

    context 'and the `ignore_single_line_blocks` option is true' do
      let(:ignore_single_line_blocks) { true }

      it { should_not report_lint }
    end

    context 'and the `ignore_single_line_blocks` option is false' do
      let(:ignore_single_line_blocks) { false }

      it { should report_lint line: 1 }
      it { should report_lint line: 2 }
      it { should report_lint line: 3 }
    end
  end
end
