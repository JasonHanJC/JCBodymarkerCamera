Pod::Spec.new do |s|
  s.name             = 'JCBodymarkerCamera'
  s.version          = '0.1.2'
  s.summary          = 'JCBodymarkerCamera is a special camera for body measurement.'

  s.description      = <<-DESC
JCBodymarkerCamera is a special camera for body measurement. It is built with Apple's AVFoundation framework. The camera main view has a bodymarker for you to pose your body and it has a camera vertical level indicator for you to correct your device vertical angle.
                       DESC

  s.homepage         = 'https://github.com/JasonHan1990/JCBodymarkerCamera'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JasonHan1990' => 'namrie1990@gmail.com' }
  s.source           = { :git => 'https://github.com/JasonHan1990/JCBodymarkerCamera.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.2'

  s.source_files = 'JCBodymarkerCamera/Classes/**/*'
  
  s.resource_bundles = {
    'JCBodymarkerCamera' => ['JCBodymarkerCamera/Assets/Images.xcassets']
  }

  s.frameworks = 'UIKit', 'AVFoundation', 'CoreMotion'
  s.dependency 'Masonry', '~> 1.1.0'
end
