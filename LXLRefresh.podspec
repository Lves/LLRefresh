#
#  Be sure to run `pod spec lint LLRefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "LXLRefresh"
  s.module_name  = 'LLRefresh'
  s.version      = "0.1.0"
  s.summary      = "LLRefresh is a pull&push to refresh library written in Swift"
  s.homepage     = "https://github.com/Lves/LLRefresh"
  s.license      = "MIT"
  s.author             = { "lixingle" => "lvesli@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Lves/LLRefresh.git", :tag => "#{s.version}" }
  s.source_files  = "LLRefresh/**/*" , "LLRefresh/**/**/*.swift" , "LLRefresh/**/*.swift"
  s.resource  = "LLRefresh/LLRefresh.bundle"
end
