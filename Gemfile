source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(URI('https://pages.github.com/versions.json').read)

gem 'asciidoctor'
gem 'pygments.rb'

group :jekyll_plugins do
  gem 'github-pages', versions['github-pages']
  gem 'jekyll', versions['jekyll']
  gem 'jekyll-sitemap', versions['jekyll-sitemap']
  gem 'jekyll-asciidoc', '2.1.1'
  gem 'jekyll-octicons'
  gem 'jekyll-commonmark-ghpages', versions['jekyll-commonmark-ghpages']
  gem 'asciidoctor-diagram'
end

gem "webrick", "~> 1.7"
