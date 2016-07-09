require 'json'

class SlackNotifications
  def self.send(data)
    url = 'https://hooks.slack.com/services/' \
      'T1PBFK15F/B1Q79RS4E/oQ25vBJWCSu5dF0ADylZA8gu'

    payload = {
      json: {
        username: 'Mr.Wattson',
        color: '#00D000',
        fields: build_fields(data)
      }
    }

    HTTP.post(url, payload)
  end

  def self.build_fields(data)
    [{ title: data['title'], value: data['body'], short: false }]
  end
end
