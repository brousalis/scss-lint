require 'spec_helper'

describe SCSSLint::Linter::BangFormat do
  context 'when no bang is used' do
    let(:scss) { <<-SCSS }
      p {
        color: #000;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000
    SASS

    it { should_not report_lint }
  end

  context 'when !important is used correctly' do
    let(:scss) { <<-SCSS }
      p {
        color: #000 !important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000 !important
    SASS

    it { should_not report_lint }
  end

  context 'when !important has no space before' do
    let(:scss) { <<-SCSS }
      p {
        color: #000!important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000!important
    SASS

    it { should report_lint line: 2 }
  end

  context 'when !important has a space after' do
    let(:scss) { <<-SCSS }
      p {
        color: #000 ! important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000 ! important
    SASS

    it { should report_lint line: 2 }
  end

  context 'when !important has a space after and config allows it' do
    let(:linter_config) { { 'space_before_bang' => true, 'space_after_bang' => true } }

    let(:scss) { <<-SCSS }
      p {
        color: #000 ! important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000 ! important
    SASS

    it { should_not report_lint }
  end

  context 'when !important has a space before but config does not allow it' do
    let(:linter_config) { { 'space_before_bang' => false, 'space_after_bang' => true } }

    let(:scss) { <<-SCSS }
      p {
        color: #000 ! important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000 ! important
    SASS

    it { should report_lint line: 2 }
  end

  context 'when !important has no spaces around and config allows it' do
    let(:linter_config) { { 'space_before_bang' => false, 'space_after_bang' => false } }

    let(:scss) { <<-SCSS }
      p {
        color: #000!important;
      }
    SCSS

    let(:sass) { <<-SASS }
      p
        color: #000!important
    SASS

    it { should_not report_lint }
  end

  context 'when ! appears within a string' do
    let(:scss) { <<-SCSS }
      p:before { content: "!important"; }
      p:before { content: "imp!ortant"; }
      p:after { content: '!'; }
      div:before { content: 'important!'; }
      div:after { content: '  !  '; }
      p[attr="foo!bar"] {};
      p[attr='foo!bar'] {};
      p[attr="!foobar"] {};
      p[attr='foobar!'] {};
      $foo: 'bar!';
      $foo: "bar!";
      $foo: "!bar";
      $foo: "b!ar";
    SCSS

    let(:sass) { <<-SASS }
      p:before
        content: "!important"
      p:before
        content: "imp!ortant"
      p:after
        content: '!'
      div:before
        content: 'important!'
      div:after
        content: '  !  '
      p[attr="foo!bar"]
      p[attr='foo!bar']
      p[attr="!foobar"]
      p[attr='foobar!']
      $foo: 'bar!'
      $foo: "bar!"
      $foo: "!bar"
      $foo: "b!ar"
    SASS

    it { should_not report_lint }
  end

  context 'when !<word> is not followed by a semicolon' do
    let(:scss) { <<-SCSS }
      .class {
        margin: 0 !important
      }
    SCSS

    it 'does not loop forever' do
      subject.should_not report_lint
    end
  end
end
