Pod::Spec.new do |s|
  s.name               = "ActiveStack"
  s.version            = "0.2.1"
  s.summary            = "Active Mobile Service Layer for ActiveStack iOS Clients."
  s.homepage           = "https://github.com/ActiveStack/active-client-sdk-objc"
  s.license            = 'MIT'
  s.author             = { "Brad Anderson Smith" => "brad@theappguy.guru" }
  s.source             = { :git => "https://github.com/ActiveStack/active-client-sdk-objc.git", :tag => s.version.to_s }
  s.platform           = :ios, '7.0'
  s.requires_arc       = true
  s.prefix_header_file = 'client-library/ActiveStack-Prefix.pch'
  s.source_files       = 'client-library/**/*'
  
  s.dependency 'gtm-oauth2'
  s.dependency 'Reachability'
  s.dependency 'socket.IO', '0.2.2'
  
  s.description      = <<-DESC
                       DESC
end
