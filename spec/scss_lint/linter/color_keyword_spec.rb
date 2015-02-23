require 'spec_helper'

describe SCSSLint::Linter::ColorKeyword do
  context 'when a color is specified as a hex' do
    let(:scss) { <<-SCSS }
      p {
        color: #fff;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #fff
    SASS

    it { should_not report_lint }
  end

  context 'when a color is specified as a keyword' do
    let(:scss) { <<-SCSS }
      p {
        color: white;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: white
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a color keyword exists in a shorthand property' do
    let(:scss) { <<-SCSS }
      p {
        border: 1px solid black;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        border: 1px solid black
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a property contains a color keyword as a string' do
    let(:scss) { <<-SCSS }
      p {
        content: 'white';
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        content: 'white'
    SASS

    it { should_not report_lint }
  end

  context 'when a function call contains a color keyword' do
    let(:scss) { <<-SCSS }
      p {
        color: function(red);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: function(red)
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a mixin include contains a color keyword' do
    let(:scss) { <<-SCSS }
      p {
        @include some-mixin(red);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        +some-mixin(red)
    SASS

    it { should report_lint line: 2 }
  end

  context 'when the "transparent" color keyword is used' do
    let(:scss) { <<-SCSS }
      p {
        @include mixin(transparent);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        +mixin(transparent)
    SASS

    it { should_not report_lint }
  end

  context 'when color keyword appears in a string identifier' do
    let(:scss) { <<-SCSS }
      p {
        content: content-with-blue-in-name;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        content: content-with-blue-in-name
    SASS

    it { should_not report_lint }
  end
end
