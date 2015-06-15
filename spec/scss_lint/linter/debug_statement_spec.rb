require 'spec_helper'

describe SCSSLint::Linter::DebugStatement do
  context 'when no debug statements are present' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          color: #fff;
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          color: #fff
      SASS

      it { should_not report_lint }
    end
  end

  context 'when a debug statement is present' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @debug 'This is a debug statement';
      SCSS

      it { should report_lint line: 1 }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        @debug 'This is a debug statement'
      SASS

      it { should report_lint line: 1 }
    end
  end
end
