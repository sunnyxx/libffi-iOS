Pod::Spec.new do |s|
  s.name             = 'libffi-iOS'
  s.version          = '1.0.0'
  s.summary          = 'Stable libffi library for iOS (i386, x86_64, armv7, arm64) which has been fully verified.'
  s.description      = <<-DESC
  libffi-iOS is built based on libffi-3.2.1, provides universal library
  (i386, x86_64, armv7, arm64), both ffi_call and ffi_closure are fully
  tested.
  https://github.com/sunnyxx/libffi-iOS
  by sunnyxx
                       DESC
  s.platform         = :ios
  s.homepage         = 'https://github.com/sunnyxx/libffi-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunnyxx' => 'sunyuan1713@gmail.com' }
  s.source           = { :git => 'https://github.com/sunnyxx/libffi-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '6.0'

  s.vendored_libraries = 'libffi/libffi.a'
  s.source_files = 'libffi/*.h'
end
