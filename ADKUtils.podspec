Pod::Spec.new do |s|
  s.name             = "ADKUtils"
  s.version          = "0.1"
  s.summary          = "Utils for AsyncDisplayKit(Texture)"
  s.homepage         = "https://github.com/msfrms/ADKUtils"
  s.license          = 'Apache License 2.0'
  s.author           = { "msfrms" => "msfrms@gmail.com" }

  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.source           = { :git => 'https://github.com/msfrms/ADKUtils.git', :tag => s.version }
  s.source_files	   = 'Source/*.swift'

  s.frameworks       = 'Foundation'
  s.module_name      = 'ADKUtils'
  s.dependency 'SUtils', '~> 0.1'
  s.dependency 'Texture', '~> 3.0.0'
  
end
