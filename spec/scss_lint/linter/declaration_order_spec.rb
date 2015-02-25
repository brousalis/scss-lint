require 'spec_helper'

describe SCSSLint::Linter::DeclarationOrder do
  context 'when rule is empty' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule contains only properties' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          background: #000;
          margin: 5px;
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          background: #000
          margin: 5px
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule contains only mixins' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          @include border-radius(5px);
          @include box-shadow(5px);
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          +border-radius(5px)
          +box-shadow(5px)
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule contains no mixins or properties' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          a {
            color: #f00;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          a
            color: #f00
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule contains properties after nested rules' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          a {
            color: #f00;
          }

          color: #f00;
          margin: 5px;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          a
            color: #f00

          color: #f00
          margin: 5px
      SASS

      it { should report_lint }
    end
  end

  context 'when @extend appears before any properties or rules' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        .warn {
          font-weight: bold;
        }
        .error {
          @extend .warn;
          color: #f00;
          a {
            color: #ccc;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        .warn
          font-weight: bold

        .error
          @extend .warn
          color: #f00
          a
            color: #ccc
      SASS

      it { should_not report_lint }
    end
  end

  context 'when @extend appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        .warn {
          font-weight: bold;
        }
        .error {
          color: #f00;
          @extend .warn;
          a {
            color: #ccc;
          }
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        .warn
          font-weight: bold

        .error
          color: #f00
          @extend .warn
          a
            color: #ccc
      SASS

      it { should report_lint }
    end
  end

  context 'when nested rule set' do
    context 'contains @extend before a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            a {
              @extend foo;
              color: #f00;
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          p
            a
              @extend foo
              color: #f00
        SASS

        it { should_not report_lint }
      end
    end

    context 'contains @extend after a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            a {
              color: #f00;
              @extend foo;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          p
            a
              color: #f00
              @extend foo
        SASS

        it { should report_lint }
      end
    end

    context 'contains @extend after nested rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            a {
              span {
                color: #000;
              }
              @extend foo;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          p
            a
              span
                color: #000

              @extend foo
        SASS

        it { should report_lint }
      end
    end
  end

  context 'when @include appears' do
    context 'before a property and rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .error {
            @include warn;
            color: #f00;
            a {
              color: #ccc;
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .error
            @include warn
            color: #f00
            a
              color: #ccc
        SASS

        it { should_not report_lint }
      end
    end

    context 'after a property and before a rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .error {
            color: #f00;
            @include warn;
            a {
              color: #ccc;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .error
            color: #f00
            @include warn
            a
              color: #ccc
        SASS

        it { should report_lint }
      end
    end
  end

  context 'when @include that features @content appears' do
    context 'before a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .foo {
            @include breakpoint("phone") {
              color: #ccc;
            }
            color: #f00;
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .foo
            +breakpoint("phone")
              color: #ccc

            color: #f00
        SASS

        it { should report_lint }
      end
    end

    context 'after a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .foo {
            color: #f00;
            @include breakpoint("phone") {
              color: #ccc;
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .foo
            color: #f00
            +breakpoint("phone")
              color: #ccc
        SASS

        it { should_not report_lint }
      end
    end

    context 'before an @extend' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .foo {
            @include breakpoint("phone") {
              color: #ccc;
            }
            @extend .bar;
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .foo
            +breakpoint("phone")
              color: #ccc

            @extend .bar
        SASS

        it { should report_lint }
      end
    end

    context 'before a rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .foo {
            @include breakpoint("phone") {
              color: #ccc;
            }
            a {
              color: #fff;
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .foo
            +breakpoint("phone")
              color: #ccc

            a
              color: #fff
        SASS

        it { should_not report_lint }
      end
    end

    context 'after a rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          .foo {
            a {
              color: #fff;
            }
            @include breakpoint("phone") {
              color: #ccc;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          .foo
            a
              color: #fff

            +breakpoint("phone")
              color: #ccc
        SASS

        it { should report_lint }
      end
    end

    context 'with its own nested rule set' do
      context 'before a property' do
        context 'scss' do
          let(:scss) { <<-SCSS }
            @include breakpoint("phone") {
              a {
                color: #000;
              }
              color: #ccc;
            }
          SCSS

          it { should report_lint }
        end

        context 'sass' do
          let(:sass) { <<-SASS }
            +breakpoint("phone")
              a
                color: #000

              color: #ccc
          SASS

          it { should report_lint }
        end
      end

      context 'after a property' do
        context 'scss' do
          let(:scss) { <<-SCSS }
            @include breakpoint("phone") {
              color: #ccc;
              a {
                color: #000;
              }
            }
          SCSS

          it { should_not report_lint }
        end

        context 'sass' do
          let(:sass) { <<-SASS }
            +breakpoint("phone")
              color: #ccc
              a
                color: #000
          SASS

          it { should_not report_lint }
        end
      end
    end
  end

  context 'when the nesting is crazy deep' do
    context 'and nothing is wrong' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          div {
            ul {
              @extend .thing;
              li {
                @include box-shadow(yes);
                background: green;
                a {
                  span {
                    @include border-radius(5px);
                    color: #000;
                  }
                }
              }
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          div
            ul
              @extend .thing
              li
                +box-shadow(yes)
                background: green
                a
                  span
                    +border-radius(5px)
                    color: #000
        SASS

        it { should_not report_lint }
      end
    end

    context 'and something is wrong' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          div {
            ul {
              li {
                a {
                  span {
                    color: #000;
                    @include border-radius(5px);
                  }
                }
              }
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          div
            ul
              li
                a
                  span
                    color: #000
                    +border-radius(5px)
        SASS

        it { should report_lint }
      end
    end
  end

  context 'when inside a @media query and rule set' do
    context 'contains @extend before a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @media only screen and (max-width: 1px) {
            a {
              @extend foo;
              color: #f00;
            }
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          @media only screen and (max-width: 1px)
            a
              @extend foo
              color: #f00
        SASS

        it { should_not report_lint }
      end
    end

    context 'contains @extend after a property' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @media only screen and (max-width: 1px) {
            a {
              color: #f00;
              @extend foo;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          @media only screen and (max-width: 1px)
            a
              color: #f00
              @extend foo
        SASS

        it { should report_lint }
      end
    end

    context 'contains @extend after nested rule set' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @media only screen and (max-width: 1px) {
            a {
              span {
                color: #000;
              }
              @extend foo;
            }
          }
        SCSS

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          @media only screen and (max-width: 1px)
            a
              span
                color: #000

              @extend foo
        SASS

        it { should report_lint }
      end
    end
  end

  context 'when a pseudo-element appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          &:hover {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          &:hover
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a pseudo-element appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          &:focus {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          &:focus
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a chained selector appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          &.is-active {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          &.is-active
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a chained selector appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          &.is-active {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          &.is-active
            color: #000
          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a selector with parent reference appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          .is-active & {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          .is-active &
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a selector with parent reference appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          .is-active & {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          .is-active &
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a pseudo-element appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          &:before {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          &:before
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a pseudo-element appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          &:before {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          &:before
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a direct descendent appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          > .foo {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          > .foo
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a direct descendent appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          > .foo {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          > .foo
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when an adjacent sibling appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          & + .foo {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          & + .foo
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when an adjacent sibling appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          & + .foo {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          & + .foo
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a general sibling appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          & ~ .foo {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          & ~ .foo
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a general sibling appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          & ~ .foo {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          & ~ .foo
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end

  context 'when a descendent appears after a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          color: #fff;
          .foo {
            color: #000;
          }
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          color: #fff
          .foo
            color: #000
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a descendent appears before a property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        a {
          .foo {
            color: #000;
          }
          color: #fff;
        }
      SCSS

      it { should report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        a
          .foo
            color: #000

          color: #fff
      SASS

      it { should report_lint }
    end
  end
end
