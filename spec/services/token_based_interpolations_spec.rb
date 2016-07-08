require 'spec_helper'

describe 'TokenBasedInterpolations', type: :unit do
  describe 'With several tokens to replace in text' do
    let(:tokens) { { 'asdf' => '123', 'fdsa' => '321' } }

    it 'should replace all tokens for the corresponding value' do
      text = 'first instance {{asdf}}, second {{asdf}}, last {{fdsa}}'

      result_text = TokenBasedInterpolations.interpolate(tokens, text)

      expect(result_text).to eq 'first instance 123, second 123, last 321'
    end
  end
end
