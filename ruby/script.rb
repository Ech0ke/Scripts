# Display the current working directory
puts "Current Directory: #{Dir.pwd}"

# List files in the current directory
puts "Files in Current Directory:"
Dir.entries(Dir.pwd).each do |file|
  puts "- #{file}" unless File.directory?(file)
end

# Create a new directory
new_dir_name = "test_directory"
Dir.mkdir(new_dir_name)
puts "Created directory: #{new_dir_name}"

# Create a new file and write content to it
new_file_name = "#{new_dir_name}/test_file.txt"
File.open(new_file_name, "w") do |file|
  file.puts "This is a test file created using Ruby!"
end
puts "Created file: #{new_file_name}"

# Read content from the newly created file
puts "Content of #{new_file_name}:"
puts File.read(new_file_name)

# Execute a system command
puts "Running 'dir' command:"
puts `dir`

# Pause until the user presses Enter
puts "Press Enter to continue..."
gets

# Remove the file within the directory
File.delete(new_file_name)
puts "Removed file: #{new_file_name}"

# Remove the directory
Dir.rmdir(new_dir_name)
puts "Removed directory: #{new_dir_name}"