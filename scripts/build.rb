#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'fileutils'

# Configuration
SRC_DIR = 'src'
DATA_DIR = File.join(SRC_DIR, 'data')
PAGES_DIR = File.join(SRC_DIR, 'pages')
OUTPUT_DIR = 'public'

# Ensure output directory exists
FileUtils.mkdir_p(OUTPUT_DIR)

# Process all .erb files in src/pages/
Dir.glob(File.join(PAGES_DIR, '**', '*.erb')).each do |template_file|
  # Get relative path and remove .erb extension for output
  relative_path = template_file.sub(PAGES_DIR + '/', '')
  output_file = relative_path.sub(/\.erb$/, '')
  output_path = File.join(OUTPUT_DIR, output_file)

  # Determine translation file (assumes translation.en.yaml for now)
  translation_file = File.join(DATA_DIR, 'translation.en.yaml')

  puts "Processing #{relative_path}..."
  puts "  Translation: #{translation_file}"

  # Load translation data
  t = YAML.load_file(translation_file)

  # Load ERB template
  template_content = File.read(template_file)

  # Create ERB template
  erb = ERB.new(template_content)

  # Render template with translation data
  puts "  Rendering..."
  result = erb.result(binding)

  # Ensure output subdirectories exist
  FileUtils.mkdir_p(File.dirname(output_path))

  # Write output
  puts "  Writing to #{output_path}..."
  File.write(output_path, result)

  puts "  ✓ Generated successfully! (#{File.size(output_path)} bytes)"
end

puts "\n✓ All pages generated successfully!"
