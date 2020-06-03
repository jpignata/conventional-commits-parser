require 'spec_helper'

describe Parser do
  let(:parser) { Parser.new(msg) }
  let(:commit) { parser.commit }

  before { parser.parse }

  context 'a one-line commit message' do
    let(:msg) { 'feat: Allow users to reset passwords' }

    it { expect(commit.type).to eq(:feat) }
    it { expect(commit.subject).to eq('Allow users to reset passwords') }
  end

  context 'a one-line commit message that is a breaking change' do
    let(:msg) { 'feat!: New API' }

    it { expect(commit.type).to eq(:feat) }
    it { expect(commit.subject).to eq('New API') }
    it { expect(commit.breaking).to eq('New API') }
  end

  context 'a one-line commit message with a scope' do
    let(:msg) { 'fix(testutils): Fix flakiness in suite' }

    it { expect(commit.type).to eq(:fix) }
    it { expect(commit.subject).to eq('Fix flakiness in suite') }
    it { expect(commit.scope).to eq('testutils') }
  end

  context 'a multi-line commit message with breaking changes' do
    let(:msg) do
      <<~EOF
        feat: completely refactor the API

        BREAKING CHANGE: The old API won't work, sry.
      EOF
    end

    it { expect(commit.type).to eq(:feat) }
    it { expect(commit.subject).to eq('completely refactor the API') }
    it { expect(commit.breaking).to eq('The old API won\'t work, sry.') }
    it { expect(commit.footer.size).to eq(1) }
    it { expect(commit.footer['BREAKING CHANGE']).to eq('The old API won\'t work, sry.') }
  end

  context 'a multi-line commit message with footer items' do
    let(:msg) do
      <<~EOF
        feat: completely refactor the API

        BREAKING CHANGE: The old API won't work, sry.
        Reviewed-by: Dwayne Johnson
        Refs #133
      EOF
    end

    it { expect(commit.footer.size).to eq(3) }
    it { expect(commit.footer['BREAKING CHANGE']).to eq('The old API won\'t work, sry.') }
    it { expect(commit.footer['Reviewed-by']).to eq('Dwayne Johnson') }
    it { expect(commit.footer['Refs']).to eq('#133') }
  end

  context 'a multi-line commit message with a multi-line footer item' do
    let(:msg) do
      <<~EOF
        feat: completely refactor the API

        BREAKING CHANGE: The old API won't work, sry. The reason why is because
        I broke it. Look, I'm sorry, ok?
        Fired-By: Boss
      EOF
    end

    it { expect(commit.footer.size).to eq(2) }
    it { expect(commit.footer['BREAKING CHANGE']).to eq("The old API won\'t work, sry. The reason why is because\nI broke it. Look, I\'m sorry, ok?") }

    describe 'footer keys are case insensitive' do
      it { expect(commit.footer['Fired-By']).to eq('Boss') }
      it { expect(commit.footer['fired-by']).to eq('Boss') }
      it { expect(commit.footer['fIrEd-BY']).to eq('Boss') }
      it { expect(commit.footer).to have_key('Fired-By') }
      it { expect(commit.footer).to have_key('fired-by') }
      it { expect(commit.footer).to have_key('fIrEd-BY') }
    end
  end

  context 'a multi-line commit message with a body' do
    let(:msg) do
      <<~EOF
        feat: Add some snazzy new feature

        Feature is new. Feature is also snazzy.

        Closes: #123
      EOF
    end

    it { expect(commit.body).to eq('Feature is new. Feature is also snazzy.') }
    it { expect(commit.footer['Closes']).to eq('#123') }
  end

  context 'a multi-line commit that does not conform to the spec' do
    let(:msg) do
      <<~EOF
        this is a: subject without a type or scope

        this is a body
      EOF
    end

    it { expect(commit.type).to eq(:change) }
    it { expect(commit.scope).to be(nil) }
    it { expect(commit.subject).to eq('this is a: subject without a type or scope') }
    it { expect(commit.body).to eq('this is a body') }
    it { expect(commit.footer).to be_empty }
  end
end
