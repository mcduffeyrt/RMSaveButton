Pod::Spec.new do |s|
  s.name             = "RMSaveButton"
  s.version          = "0.1.0"
  s.summary          = "A drop-in replacement for a click-to-save action in iOS.."
  s.homepage         = "https://github.com/mcduffeyrt/RMSaveButton"
  # s.screenshots     = "https://cloud.githubusercontent.com/assets/11640459/7904109/c2bbda6c-07b5-11e5-984e-773b680cc9b7.png"
  s.license          = 'MIT'
  s.author           = { "Richard McDuffey" => "richard.t.mcduffey@gmail.com" }
  s.source           = { :git => "https://github.com/mcduffeyrt/RMSaveButton.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/mcduff_isdatguy'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

s.source_files = 'RMSaveButton/RMSaveButton.{h,m}'
  s.resource_bundles = {
    'RMSaveButton' => ['Pod/Assets/*.png']
  }
end
