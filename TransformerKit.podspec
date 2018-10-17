Pod::Spec.new do |s|
  s.name     = 'TransformerKit'
  s.version  = '1.1.0'
  s.license  = 'MIT'
  s.summary  = 'A block-based API for NSValueTransformer, with a growing collection of useful examples.'
  s.homepage = 'https://github.com/mattt/TransformerKit'
  s.authors  = { 'Mattt' => 'mattt@me.com' }
  s.source   = { git: 'https://github.com/mattt/TransformerKit.git', tag: s.version }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/NSValueTransformer+TransformerKit.{h,m}', 'Sources/NSValueTransformerName.h'
  end

  s.subspec 'Cryptography' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.osx.source_files = 'Sources/TTTCryptographyTransformers.{h,m}'
    ss.osx.frameworks = 'Security'
  end

  s.subspec 'Data' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.osx.source_files = 'Sources/TTTDataTransformers.{h,m}'
    ss.osx.frameworks = 'Security'
  end

  s.subspec 'Date' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.source_files = 'Sources/TTTDateTransformers.{h,m}'
  end

  s.subspec 'JSON' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.source_files = 'Sources/TTTJSONTransformer.{h,m}'
  end

  s.subspec 'Image' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.source_files = 'Sources/TTTImageTransformers.{h,m}'
  end

  s.subspec 'String' do |ss|
    ss.dependency 'TransformerKit/Core'
    ss.source_files = 'Sources/TTTStringTransformers.{h,m}'
  end
end
