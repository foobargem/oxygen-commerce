# Install hook code here
require "fileutils"

plugin_dir = File.dirname(__FILE__)
root_dir = File.join(plugin_dir, '..', '..', '..')



# copy master image files
FileUtils.makedirs File.join(root_dir, 'public', 'images', 'master')


[
  "arrow_dropdown.gif", 
  "button_bg.png", 
  "background-gradient.gif", 
  "header-background.gif",
  "spinner.gif",
  "transparentGif.gif"
].each do |s|
  FileUtils.copy(
    File.join(plugin_dir, 'images', s), 
    File.join(root_dir, 'public', 'images', 'master', s)
  )
end



# copy javascript files
# File.makedirs File.join(root_dir, 'public', 'javascripts')

["suddenlybunt", "behaviors", "prototype"].each do |s|
  FileUtils.copy(
    File.join(plugin_dir, 'javascripts', "#{s}.js"), 
    File.join(root_dir, 'public', 'javascripts', "#{s}.js")
  )
end



# copy xml files
FileUtils.makedirs File.join(root_dir, 'public', 'stylesheets', 'xml')

[
  "ellipsis.xml"
].each do |s|
  FileUtils.copy(
    File.join(plugin_dir, 'xml', s), 
    File.join(root_dir, 'public', 'stylesheets', 'xml', s)
  )
end

