Apitome.setup do |config|
  config.mount_at = '/api/docs'
  config.root = nil
  config.doc_path = 'doc/api'
  config.title = 'Mr.Wattson API Documentation'
  config.layout = 'apitome/application'
  config.code_theme = 'default'
  config.css_override = nil
  config.js_override = nil
  config.readme = '../api.md'
  config.single_page = true
end
