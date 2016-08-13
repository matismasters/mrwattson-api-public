class TokenBasedInterpolations
  def self.interpolate(tokens, text)
    return '' if text.nil?
    result_text = text
    tokens.each do |token, replacement|
      result_text = result_text.gsub("{{#{token}}}", replacement)
    end
    result_text
  end
end
