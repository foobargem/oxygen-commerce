desc "Add schema information (as comments) to model files"

task :annotate_models do
  require File.join(File.dirname(__FILE__), "../annotate_models.rb")
  AnnotateModels.do_annotations
end

task :annotate_plugin_models do
  require File.join(File.dirname(__FILE__), "../annotate_models.rb")
  AnnotateModels.do_annotations(plugins_only=true)
end