require 'spec_helper'

describe SCSSLint::Linter::HexValidation do
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

  context 'when rule contains valid hex codes or color keyword' do
    gradient_css = 'progid:DXImageTransform.Microsoft.gradient' \
                   '(startColorstr=#99000000, endColorstr=#99000000)'

    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          background: #000;
          color: #FFFFFF;
          border-color: red;
          filter: #{gradient_css};
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          background: #000
          color: #FFFFFF
          border-color: red
          filter: #{gradient_css}
      SASS

      it { should_not report_lint }
    end
  end

  context 'when rule contains invalid hex codes' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          background: #dd;
          color: #dddd;
        }
      SCSS

      it { should report_lint line: 2 }
      it { should report_lint line: 3 }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        p
          background: #dd
          color: #dddd
      SASS

      it { should report_lint line: 2 }
      it { should report_lint line: 3 }
    end
  end
end
