Pod::Spec.new do |s|
  s.name         = 'RunKit'
  s.version      = '1.0.1'
  s.summary      = 'A Swift Wrapper for Grand Central Dispatch (GCD) Framework that supports method chaining'
  s.homepage     = 'https://github.com/khoiln/RunKit.git'
  s.license      = { :type => 'MIT' }
  s.author             = { 'Khoi' => 'khoi.geeky@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.homepage           = 'https://github.com/khoiln/RunKit'
  s.source       = { :git => 'https://github.com/khoiln/RunKit.git', :tag => s.version }
  s.source_files  = 'Source/**/*.{swift,h,m}'
  s.requires_arc = true
end
