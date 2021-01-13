#!/bin/ruby

CONFIG_FILE_NAME = "template-config.json"
files = Dir["./template-templates/*.png"]
puts "Building configuration for #{files.length} template images...\n\n"

config_entries = []
files.each do |file|
    file_name = File.basename(file).split('.')[0]
    config_entries << {
        "name": file_name.gsub("-", " ").split.map(&:capitalize).join(' '),
        "filename": file_name,
        "iconCode": "\ue9db",
        "landscape": "false", 
        "categories": ["Custom"]
    }
end

file = File.new(CONFIG_FILE_NAME, 'w+')
file.write(config_entries.join("\n"))

puts "Success: Built new templates configuration file: #{CONFIG_FILE_NAME}\n\n"
puts "To install, ssh into your Remarkable2"
puts "  - Copy the source files to /usr/share/remarkable/templates/"
puts "  - Add the configuration data supplied in #{CONFIG_FILE_NAME} to the Remarkable2's templates.json file"
puts "  - You may need to restart the device\n\n"
puts "For more information, see https://remarkablewiki.com/tips/templates"
