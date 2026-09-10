source 'https://rubygems.org'

require 'json'
require 'open-uri'

versions = {
  'jekyll' => '~> 4.3',
  'jekyll-sitemap' => '1.4.0',
  'kramdown' => '2.4.0',
  'rouge' => '3.30.0'
}

begin
  gh_versions = JSON.parse(URI('https://pages.github.com/versions.json').read)
  versions['jekyll-sitemap'] = gh_versions['jekyll-sitemap'] if gh_versions['jekyll-sitemap']
  versions['kramdown'] = gh_versions['kramdown'] if gh_versions['kramdown']
  versions['rouge'] = gh_versions['rouge'] if gh_versions['rouge']
rescue StandardError
  # Fall back to the default versions when offline.
end

gem 'rake'
gem 'asciidoctor'
gem 'pygments.rb'

group :jekyll_plugins do
  gem 'jekyll', versions['jekyll']
  gem 'jekyll-sitemap', versions['jekyll-sitemap']
  gem 'jekyll-asciidoc', '~> 3.0'
  gem 'jekyll-octicons'
  gem 'asciidoctor-diagram'
end

gem 'kramdown', versions['kramdown']
gem 'rouge', versions['rouge']
gem "webrick", "~> 1.7"
