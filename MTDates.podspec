Pod::Spec.new do |s|
  s.name         	= "MTDates"
  s.version      	= "0.14.1"
  s.summary      	= "A category on NSDate. 100+ date calculation methods."
  s.homepage     	= "https://github.com/mysterioustrousers/MTDates"
  s.license      	= 'MIT'
  s.author       	= { "Adam Kirk" => "atomkirk@gmail.com" }
  s.source       	= { :git => "https://github.com/mysterioustrousers/MTDates.git", :tag => "#{s.version}" }
  s.source_files 	= 'MTDates/*.{h,m}'
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.8"
  s.requires_arc 	= true
end
