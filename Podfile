# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'starter_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  ensemble_starter_path = '../starter_module'
  load File.join(ensemble_starter_path, '.ios', 'Flutter', 'podhelper.rb')
  install_all_flutter_pods(ensemble_starter_path)

end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end