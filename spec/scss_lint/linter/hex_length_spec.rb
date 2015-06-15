require 'spec_helper'

describe SCSSLint::Linter::HexLength do
  let(:linter_config) { { 'style' => style } }
  let(:style) { 'short' }

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

  context 'when rule contains properties with valid hex code' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          color: #1234ab;
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          color: #1234ab
      SASS

      it { should_not report_lint }
    end
  end

  context 'when ID selector starts with a hex code' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        #aabbcc {
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        #aabbcc
      SASS

      it { should_not report_lint }
    end
  end

  context 'when color is specified as a color keyword' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        p {
          @include box-shadow(0 0 1px 1px gold);
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        p
          +box-shadow(0 0 1px 1px gold)
      SASS

      it { should_not report_lint }
    end
  end

  context 'when short style is preferred' do
    let(:style) { 'short' }

    context 'with short hex code' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            background: #ccc;
            background: #CCC;
            @include crazy-color(#fff);
          }
        SCSS

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { <<-SASS }
          p
            background: #ccc
            background: #CCC
            +crazy-color(#fff)
        SASS

        it { should_not report_lint }
      end
    end

    context 'with long hex code that could be condensed to 3 digits' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          p {
            background: #cccccc;
            background: #CCCCCC;
            @include crazy-color(#ffffff);
          }
        SCSS

        it { should report_lint line: 2 }
        it { should report_lint line: 3 }
        it { should report_lint line: 4 }
      end
    end
  end

  context 'when long style is preferred' do
    let(:style) { 'long' }

    context 'with long hex code that could be condensed to 3 digits' do
      let(:scss) { <<-SCSS }
        p {
          background: #cccccc;
          background: #CCCCCC;
          @include crazy-color(#ffffff);
        }
      SCSS

      it { should_not report_lint }
    end

    context 'with short hex code' do
      let(:scss) { <<-SCSS }
        p {
          background: #ccc;
          background: #CCC;
          @include crazy-color(#fff);
        }
      SCSS

      it { should report_lint line: 2 }
      it { should report_lint line: 3 }
      it { should report_lint line: 4 }
    end
  end
end
