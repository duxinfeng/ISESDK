
Pod::Spec.new do |s|

  s.name         = "ISESDK"

  s.version      = "0.1.0"

  s.summary      = "讯飞SDK评测简单封装(自用)"

  s.homepage     = "https://github.com/duxinfeng/ISESDK"

  s.license      = "MIT"

  s.author             = { "Xinfeng Du" => "duxinfeng99@gmail.com" }

  s.social_media_url   = "https://github.com/duxinfeng"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/duxinfeng/ISESDK.git", :tag => "#{s.version}" }

  s.vendored_frameworks = "iflyMSC.framework"
 
  s.source_files = '*.{h,m}','ISEResults/*.{h,m}'

  s.subspec 'ISEResults' do |ss|

    ss.source_files = 'ISEResults/*.{h,m}'

  end

 s.frameworks = 'CoreLocation', 'CoreTelephony', 'AVFoundation', 'AudioToolbox', 'SystemConfiguration', 'QuartzCore', 'CoreGraphics'

 s.libraries = 'z','c++'

 s.requires_arc = true


end
