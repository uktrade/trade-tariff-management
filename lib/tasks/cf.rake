namespace :cf do
  desc 'Only run on the first application instance; e.g. you can use it to run db migrations'
  task :on_first_instance do
    instance_index = if ENV['VCAP_APPLICATION'] && JSON.parse(ENV['VCAP_APPLICATION'])
                       JSON.parse(ENV['VCAP_APPLICATION'])['instance_index']
                     end
    exit(0) unless instance_index.zero?
  end
end
