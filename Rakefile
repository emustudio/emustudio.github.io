# frozen_string_literal: true

require 'fileutils'

# Reference-style link names that intentionally don't need {:target="_blank"}
# (internal anchors / kramdown reference definitions)
LINK_REF_EXCLUSIONS = %w[instantiation initialization memoryBanks ssem-mem].freeze

DOC_SOURCE_DIR  = '_documentation'
DOC_OUTPUT_DIR  = 'documentation'
DOC_SUBSITES    = %w[user developer].freeze

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def find_files(dir, extension)
  Dir.glob(File.join(dir, '**', "*.#{extension}"))
end

def report_problems(description, problems)
  if problems.empty?
    puts "  ✓ #{description}: OK"
  else
    puts "  ✗ #{description}: #{problems.size} problem(s) found"
    problems.each { |p| puts "    #{p}" }
  end
  problems
end

def run_or_fail(cmd)
  puts "  → #{cmd}"
  system(cmd) || abort("Command failed: #{cmd}")
end

# ---------------------------------------------------------------------------
# Lint tasks  (namespace :lint)
# ---------------------------------------------------------------------------

namespace :lint do
  desc 'Check that reference-style links in docs have {:target="_blank"}'
  task :target_blank do
    puts 'Lint: checking {:target="_blank"} on reference-style links …'
    # Pattern: whitespace, then [text][ref] NOT followed by {
    pattern = /\s\[[^\]]*\]\[[^\]]*\][^{]/
    exclusion_pattern = LINK_REF_EXCLUSIONS.map { |e| Regexp.escape("[#{e}]") }.join('|')

    problems = []
    find_files(DOC_SOURCE_DIR, 'md').each do |file|
      File.readlines(file, encoding: 'utf-8').each_with_index do |line, idx|
        next unless line.match?(pattern)
        next if line.match?(/#{exclusion_pattern}/)

        problems << "#{file}:#{idx + 1}: #{line.strip}"
      end
    end

    report_problems('target_blank', problems)
    abort 'Lint target_blank failed' unless problems.empty?
  end

  desc 'Check that no unreplaced {imagepath} remains in generated HTML'
  task :imagepath do
    puts 'Lint: checking for unreplaced {imagepath} in generated HTML …'

    problems = []
    find_files(DOC_OUTPUT_DIR, 'html').each do |file|
      File.readlines(file, encoding: 'utf-8').each_with_index do |line, idx|
        if line.include?('{imagepath}')
          problems << "#{file}:#{idx + 1}: #{line.strip}"
        end
      end
    end

    report_problems('imagepath', problems)
    abort 'Lint imagepath failed' unless problems.empty?
  end

  desc 'Check that site.baseurl usage is always followed by /'
  task :baseurl_slash do
    puts 'Lint: checking baseurl ends with slash …'

    # Match href="{{ site.baseurl }}X" where X is NOT / or {
    pattern = /href=["']?\{\{\s*site\.baseurl\s*\}\}[^\/{]/
    exclude_dirs = %w[_posts _site documentation _documentation vendor .bundle .git]

    problems = []
    Dir.glob('**/*.{html,md}').each do |file|
      next if exclude_dirs.any? { |d| file.start_with?(d) }

      File.readlines(file, encoding: 'utf-8').each_with_index do |line, idx|
        if line.match?(pattern)
          problems << "#{file}:#{idx + 1}: #{line.strip}"
        end
      end
    end

    report_problems('baseurl_slash', problems)
    abort 'Lint baseurl_slash failed' unless problems.empty?
  end

  desc 'Check for accidental spaces between link and {:target="_blank"}'
  task :link_spaces do
    puts 'Lint: checking for accidental spaces before {:target="_blank"} …'

    pattern = /\s\{:target="_blank"\}/
    exclude_dirs = %w[_site vendor .bundle .git Rakefile]

    problems = []
    Dir.glob('**/*.{html,md}').each do |file|
      next if exclude_dirs.any? { |d| file.start_with?(d) }
      # Skip this Rakefile and build scripts (they mention the pattern literally)
      next if file == 'Rakefile' || file.end_with?('build.sh')

      File.readlines(file, encoding: 'utf-8').each_with_index do |line, idx|
        if line.match?(pattern)
          problems << "#{file}:#{idx + 1}: #{line.strip}"
        end
      end
    end

    report_problems('link_spaces', problems)
    abort 'Lint link_spaces failed' unless problems.empty?
  end

  desc 'Check for broken internal markdown links (files that do not exist)'
  task :broken_links do
    puts 'Lint: checking for broken internal markdown links …'

    # Matches [text](relative-path) — ignores http/https/mailto/anchor-only links
    link_pattern = /\[([^\]]*)\]\((?!https?:\/\/)(?!mailto:)(?!#)([^)]+)\)/

    problems = []
    find_files(DOC_SOURCE_DIR, 'md').each do |file|
      dir = File.dirname(file)
      fence = nil
      File.readlines(file, encoding: 'utf-8').each_with_index do |line, idx|
        # Ignore the contents of fenced examples, not just their delimiters.
        if fence
          fence = nil if line.match?(/\A {0,3}#{Regexp.escape(fence[0])}{#{fence.length},}\s*\z/)
          next
        end
        if (opening = line.match(/\A {0,3}(`{3,}|~{3,})/))
          fence = opening[1]
          next
        end
        # Skip if the match is inside backtick-delimited inline code
        code_stripped = line.gsub(/`[^`]*`/, '')

        code_stripped.scan(link_pattern) do |_text, href|
          # Strip anchor and query string
          path = href.split('#').first.split('?').first
          next if path.nil? || path.empty?
          next if path.start_with?('/') # absolute site paths resolved at build time
          next if path.start_with?('{') # liquid/variable paths
          # Skip purely numeric "paths" — usually false positives from code snippets
          next if path.match?(/\A\d+\z/)

          target = File.join(dir, path)
          unless File.exist?(target)
            problems << "#{file}:#{idx + 1}: broken link to '#{path}'"
          end
        end
      end
    end

    report_problems('broken_links', problems)
    abort 'Lint broken_links failed' unless problems.empty?
  end
end

desc 'Run all pre-build lint checks'
task lint: %w[lint:target_blank lint:link_spaces lint:baseurl_slash lint:broken_links]

desc 'Run all post-build lint checks'
task 'lint:post_build': %w[lint:imagepath]

# ---------------------------------------------------------------------------
# Build tasks  (namespace :build)
# ---------------------------------------------------------------------------

namespace :build do
  desc 'Build documentation sub-sites (user & developer)'
  task :docs do
    puts 'Building documentation sub-sites …'
    DOC_SUBSITES.each do |subsite|
      dir = File.join(DOC_SOURCE_DIR, subsite)
      unless File.directory?(dir)
        puts "  ⚠ Skipping #{dir} (not found)"
        next
      end

      puts "  Building #{subsite} documentation …"
      Dir.chdir(dir) do
        Bundler.with_unbundled_env do
          run_or_fail 'bundle install --quiet'
          run_or_fail 'JEKYLL_ENV=production bundle exec jekyll build'
        end
      end
    end
  end

  desc 'Build the root Jekyll site'
  task :site do
    puts 'Building root site …'
    run_or_fail 'JEKYLL_ENV=production bundle exec jekyll build --verbose'
  end
end

desc 'Full production build: lint → clean → build docs → build site → post-build lint'
task build: %w[lint clean build:docs build:site lint:post_build] do
  puts
  puts '✓ Build completed successfully!'
end

# ---------------------------------------------------------------------------
# Clean / Serve
# ---------------------------------------------------------------------------

desc 'Delete generated sites and Jekyll caches'
task :clean do
  puts 'Cleaning …'
  FileUtils.rm_rf(DOC_OUTPUT_DIR)
  system 'bundle exec jekyll clean'
  puts '  ✓ Clean complete'
end

desc 'Start the local Jekyll dev server (http://localhost:4000/)'
task :serve do
  puts 'Starting development server …'
  exec 'bundle exec jekyll serve --livereload'
end

# ---------------------------------------------------------------------------
# Default
# ---------------------------------------------------------------------------

task default: :build

