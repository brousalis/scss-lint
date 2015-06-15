require 'spec_helper'

describe SCSSLint::Linter::EmptyRule do
  context 'when rule is empty' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
        }
      SCSS

      it { should report_lint line: 1 }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
      SASS

      it { should report_lint line: 1 }
    end
  end

  context 'when rule contains an empty nested rule' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          background: #000;
          display: none;
          margin: 5px;
          padding: 10px;
          a {
          }
        }
      SCSS

      it { should report_lint line: 6 }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          background: #000
          display: none
          margin: 5px
          padding: 10px
          a
      SASS

      it { should report_lint line: 6 }
    end
  end
end
