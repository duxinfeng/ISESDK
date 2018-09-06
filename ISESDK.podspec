

Pod::Spec.new do |s|


  s.name         = "ISESDK"

  s.version      = "0.0.1"

  s.summary      = "讯飞SDK评测简单封装(自用)"

  s.homepage     = "https://github.com/duxinfeng/ISESDK"

  s.license      = "MIT"
  
  s.author             = { "Xinfeng Du" => "duxinfeng99@gmail.com" }

  s.social_media_url   = "https://github.com/duxinfeng"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/duxinfeng/ISESDK.git", :tag => "#{s.version}" }
 
  s.vendored_frameworks = "ISESDK/iflyMSC.framework"

 #  s.subspec 'ISEResults' do |ss|
	# ss.source_files = 'ISESDK/ISEResults/*.{h,m}'
 #  end

 #  s.subspec 'XXBSpeechEvaluator' do |ss|
	# ss.source_files = 'ISESDK/*', 'ISESDK/XXBSpeechEvaluator/*.{h,m}'
 #  end

  # s.subspec "ISEResults" do |ISEResults|

  #   ISEResults.source_files  = "ISESDK/ISEResults/*.{h,m}"

  # end

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "ISESDK/ISEResults/*", "ISESDK/XXBSpeechEvaluator/*"

  # s.public_header_files = "Classes/**/*.h"

 	s.frameworks = 'CoreLocation', 'CoreTelephony', 'AVFoundation', 'AudioToolbox', 'SystemConfiguration', 'QuartzCore', 'CoreGraphics'
  	s.libraries = 'z','c++'


  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
