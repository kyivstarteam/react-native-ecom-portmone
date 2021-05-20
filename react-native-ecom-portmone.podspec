require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-ecom-portmone"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-ecom-portmone
                   DESC
  s.homepage     = "https://github.com/kyivstarteam/react-native-ecom-portmone"
  s.license      = "MIT"
  s.authors      = { "Kyivstar" => "y.onipko@kyivstar.net" }
  s.platforms    = { :ios => "9.0" }
  s.swift_version = "5"
  s.source       = { :git => "https://github.com/kyivstarteam/react-native-ecom-portmone.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.dependency "React"
  s.dependency "PortmoneSDKEcom", "1.7.8"
end

