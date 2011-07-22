# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

# enhances rake with alias_task_chain method.
module Pelorus
  module RakeExtensions
    module AliasTaskChain
      def alias_task_chain(enhancable_task, feature)
        chained_orignal_name = "#{ enhancable_task }_without_#{ feature }"
        chained_enhanced_name = "#{ enhancable_task }_with_#{ feature }"
        target_task = Rake::Task[enhancable_task]
        tasks = Rake.application.instance_variable_get(:@tasks)
        target_task.instance_variable_set(:@name, chained_orignal_name)
        tasks.delete(enhancable_task)
        tasks[chained_orignal_name] = target_task
        task(enhancable_task => chained_enhanced_name)
      end
    end
  end
end

send :include, Pelorus::RakeExtensions::AliasTaskChain

require 'tasks/rails'
