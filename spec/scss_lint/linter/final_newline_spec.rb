require 'spec_helper'

describe SCSSLint::Linter::FinalNewline do
  let(:linter_config) { { 'present' => present } }

  context 'when trailing newline is preferred' do
    let(:present) { true }

    context 'when the file is empty' do
      context 'scss' do
        let(:scss) { '' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '' }

        it { should_not report_lint }
      end
    end

    context 'when the file ends with a newline' do
      context 'scss' do
        let(:scss) { "p {}\n" }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { "p \n" }

        it { should_not report_lint }
      end
    end

    context 'when the file does not end with a newline' do
      context 'scss' do
        let(:scss) { 'p {}' }

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { 'p' }

        it { should report_lint }
      end
    end
  end

  context 'when no trailing newline is preferred' do
    let(:present) { false }

    context 'when the file is empty' do
      context 'scss' do
        let(:scss) { '' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { '' }

        it { should_not report_lint }
      end
    end

    context 'when the file ends with a newline' do
      context 'scss' do
        let(:scss) { "p {}\n" }

        it { should report_lint }
      end

      context 'sass' do
        let(:sass) { "p \n" }

        it { should report_lint }
      end
    end

    context 'when the file does not end with a newline' do
      context 'scss' do
        let(:scss) { 'p {}' }

        it { should_not report_lint }
      end

      context 'sass' do
        let(:sass) { 'p' }

        it { should_not report_lint }
      end
    end
  end
end
