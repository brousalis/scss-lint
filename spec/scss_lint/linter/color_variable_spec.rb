require 'spec_helper'

describe SCSSLint::Linter::ColorVariable do
  context 'when a color literal is used in a variable declaration' do
    let(:scss) { <<-SCSS }
      $my-color: #f00;
    SCSS

    let(:sass) { <<-SASS }
      $my-color: #f00
    SASS

    it { should_not report_lint }
  end

  context 'when a color literal is used in a property' do
    let(:scss) { <<-SCSS }
      p {
        color: #f00;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #f00
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a color literal is used in a function call' do
    let(:scss) { <<-SCSS }
      p {
        color: my-func(#f00);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: my-func(#f00)
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a color literal is used in a mixin' do
    let(:scss) { <<-SCSS }
      p {
        @include my-mixin(#f00);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        +my-mixin(#f00)
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a color literal is used in a shorthand property' do
    let(:scss) { <<-SCSS }
      p {
        border: 1px solid #f00;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        border: 1px solid #f00
    SASS

    it { should report_lint line: 2 }
  end

  context 'when a number is used in a property' do
    let(:scss) { <<-SCSS }
      p {
        z-index: 9000;
        transition-duration: 250ms;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        z-index: 9000
        transition-duration: 250ms
    SASS

    it { should_not report_lint }
  end

  context 'when a non-color keyword is used in a property' do
    let(:scss) { <<-SCSS }
      p {
        overflow: hidden;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        overflow: hidden
    SASS

    it { should_not report_lint }
  end

  context 'when a variable is used in a property' do
    let(:scss) { <<-SCSS }
      p {
        color: $my-color;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: $my-color
    SASS

    it { should_not report_lint }
  end

  context 'when a variable is used in a function call' do
    let(:scss) { <<-SCSS }
      p {
        color: my-func($my-color);
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: my-func($my-color)
    SASS

    it { should_not report_lint }
  end

  context 'when a variable is used in a shorthand property' do
    let(:scss) { <<-SCSS }
      p {
        border: 1px solid $my-color;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        border: 1px solid $my-color
    SASS

    it { should_not report_lint }
  end
end
