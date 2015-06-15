require 'spec_helper'

describe SCSSLint::Linter::Comment do
  context 'when no comments exist' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          margin: 0;
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          margin: 0
      SASS

      it { should_not report_lint }
    end
  end

  context 'when comment is a single line comment' do
    context 'scss' do
      let(:scss) { '// Single line comment' }

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { '// Single line comment' }

      it { should_not report_lint }
    end
  end

  context 'when comment is a single line comment at the end of a line' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          margin: 0; // Comment at end of line
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          margin: 0 // Comment at end of line
      SASS

      it { should_not report_lint }
    end
  end

  context 'when comment is a multi-line comment' do
    context 'scss' do
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

      it { should report_lint line: 4 }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        h1
          color: #eee
        /*
         * This is a multi-line comment that should report a lint
         */
        p
          color: #DDD
      SASS

      it { should report_lint line: 3 }
    end
  end

  context 'when multi-line-style comment is a at the end of a line' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        h1 {
          color: #eee; /* This is a comment */
        }
      SCSS

      it { should report_lint line: 2 }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        h1
          color: #eee /* This is a comment */
      SASS

      it { should report_lint line: 2 }
    end
  end

  context 'when multi-line comment is allowed by config' do
    let(:linter_config) { { 'allowed' => '^[/\\* ]*Copyright' } }
    let(:scss) { <<-SCSS }
      /* Copyright someone. */
      a {
        color: #DDD;
      }
    SCSS

    it { should_not report_lint }
  end

  context 'when multi-line comment is not allowed by config' do
    let(:linter_config) { { 'allowed' => '^[/\\* ]*Copyright' } }
    let(:scss) { <<-SCSS }
      /* Other multiline. */
      p {
        color: #DDD;
      }
    SCSS

    it { should report_lint }
  end
end
