require 'spec_helper'

describe SCSSLint::Linter::ColorKeyword do
  context 'when a color is specified as a hex' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          color: #fff;
        }
      SCSS

      it { should_not report_lint }
    end
  end

  context 'when a color is specified as a keyword' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          color: white;
        }
      SCSS

      it { should report_lint line: 2 }
    end
  end

  context 'when a color keyword exists in a shorthand property' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          border: 1px solid black;
        }
      SCSS

      it { should report_lint line: 2 }
    end
  end

  context 'when a property contains a color keyword as a string' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          content: 'white';
        }
      SCSS

      it { should_not report_lint }
    end
  end

  context 'when a function call contains a color keyword' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          color: function(red);
        }
      SCSS

      it { should report_lint line: 2 }
    end
  end

  context 'when a mixin include contains a color keyword' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          @include some-mixin(red);
        }
      SCSS

      it { should report_lint line: 2 }
    end
  end

  context 'when the "transparent" color keyword is used' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          @include mixin(transparent);
        }
      SCSS

      it { should_not report_lint }
    end
  end

  context 'when color keyword appears in a string identifier' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          content: content-with-blue-in-name;
        }
      SCSS

      it { should_not report_lint }
    end
  end

  context 'when a color keyword is used in a map declaration as keys' do
    let(:scss) { <<-SCSS }
      $palette: (
        white: (
          first:   #fff,
          second:  #ccc,
          third:   #000
        ),
        'black': (
          first:   #000,
          second:  #ccc,
          third:   #fff
        )
      );
    SCSS

    it { should_not report_lint }
  end
end
