require 'spec_helper'

describe SCSSLint::Linter::Comment do
  context 'when no comments exist' do
    let(:scss) { <<-SCSS }
      p {
        margin: 0;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        margin: 0
    SASS

    it { should_not report_lint }
  end

  context 'when comment is a single line comment' do
    let(:scss) { '// Single line comment' }
    let(:sass) { '// Single line comment' }

    it { should_not report_lint }
  end

  context 'when comment is a single line comment at the end of a line' do
    let(:scss) { <<-SCSS }
      p {
        margin: 0; // Comment at end of line
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        margin: 0 // Comment at end of line
    SASS

    it { should_not report_lint }
  end

  context 'when comment is a multi-line comment' do
    let(:scss) { <<-SCSS }
      h1 {
        color: #eee;
      }
      /*
       * This is a multi-line comment that should report a lint
       */
      p {
        color: #DDD;
      }
    SCSS

    # TODO: This passes but seems like it shouldn't
    let(:sass) { <<-SASS }
      h1
        color: #eee
      /*
       * This is a multi-line comment that should report a lint
       */
      p
        color: #DDD
    SASS

    it { should report_lint line: 4 }
  end

  context 'when multi-line-style comment is a at the end of a line' do
    let(:scss) { <<-SCSS }
      h1 {
        color: #eee; /* This is a comment */
      }
    SCSS

    let(:sass) { <<-SASS }
      h1
        color: #eee /* This is a comment */
    SASS

    it { should report_lint line: 2 }
  end
end
