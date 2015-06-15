require 'spec_helper'

describe SCSSLint::Linter::ElsePlacement do
  context 'when @if contains no accompanying @else' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition {
          $var: 1;
        }
      SCSS

      it { should_not report_lint }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        @if $condition
          $var: 1
      SASS

      it { should_not report_lint }
    end
  end

  context 'when @else is on different line' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition {
          $var: 1;
        }
        @else {
          $var: 0;
        }
      SCSS

      it { should report_lint line: 4 }
    end

    context 'sass' do
      let(:sass) { <<-SASS }
        @if $condition
          $var: 1
        @else
          $var: 0
      SASS

      it { should report_lint line: 3 }
    end
  end

  context 'when @else is on the same line as previous curly' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition {
          $var: 1;
        } @else {
          $var: 0;
        }
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        @if $condition
          $var: 1
        @else
          $var: 0
      SASS

      it { should_not report_lint }
    end
  end

  context 'when `@else if` is on different line' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition {
          $var: 1;
        }
        @else if $other_condition {
          $var: 2;
        }
        @else {
          $var: 0;
        }
      SCSS

      it { should report_lint line: 4 }
      it { should report_lint line: 7 }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        @if $condition
          $var: 1
        @else if $other_condition
          $var: 2
        @else
          $var: 0
      SASS

      it { should report_lint line: 3 }
      it { should report_lint line: 5 }
    end
  end

  context 'when `@else if` is on the same line as previous curly' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition {
          $var: 1;
        } @else if $other_condition {
          $var: 2;
        } @else {
          $var: 0;
        }
      SCSS

      it { should_not report_lint }
    end

    xcontext 'sass' do
      let(:sass) { <<-SASS }
        @if $condition
          $var: 1
        @else if $other_condition
          $var: 2
        @else
          $var: 0
      SASS

      it { should_not report_lint }
    end
  end

  context 'when @else is on same line as @if' do
    context 'scss' do
      let(:scss) { <<-SCSS }
        @if $condition { $var: 1; } @else { $var: 0; }
      SCSS

      it { should_not report_lint }
    end
  end

  context 'when placement of @else on a new line is preferred' do
    let(:linter_config) { { 'style' => 'new_line' } }

    context 'when @else is on a new line' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @if $condition {
            $var: 1;
          }
          @else {
            $var: 0;
          }
        SCSS

        it { should_not report_lint }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          @if $condition
            $var: 1
          @else
            $var: 0
        SASS

        it { should_not report_lint }
      end
    end

    context 'when @else is on the same line as previous curly brace' do
      context 'scss' do
        let(:scss) { <<-SCSS }
          @if $condition {
            $var: 1;
          } @else {
            $var: 0;
          }
        SCSS

        it { should report_lint line: 3 }
      end

      xcontext 'sass' do
        let(:sass) { <<-SASS }
          @if $condition
            $var: 1
          @else
            $var: 0
        SASS

        it { should report_lint line: 3 }
      end
    end
  end
end
