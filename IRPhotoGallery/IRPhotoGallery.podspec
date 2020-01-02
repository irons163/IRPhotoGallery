Pod::Spec.new do |spec|
  spec.name         = "IRPhotoGallery"
  spec.version      = "1.0.1"
  spec.summary      = "Make a Button Group to control."
  spec.description  = "Make a Button Group to control."
  spec.homepage     = "https://github.com/irons163/IRPhotoGallery.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/irons163/IRPhotoGallery.git", :tag => spec.version.to_s }
# spec.source       = { :path => '.' }
  spec.source_files  = "IRPhotoGallery/**/*.{h,m}"
  spec.dependency 'SDWebImage', '~> 4.0'
  spec.dependency 'IRCameraViewController'
  spec.resources = ["IRPhotoGallery/**/*.xib"]
  spec.info_plist = {
    'NSCameraUsageDescription' => 'Please allow to access your camera.',
    'NSPhotoLibraryUsageDescription' => 'Please allow to access your album.'
  }
#  spec.pod_target_xcconfig = { 'INFOPLIST_FILE' => '$(POD_TARGET_SRCROOT)/Info.plist' }
#  spec.subspec 'IRPhotoGallery' do |subs|
#    subs.name = "IRPhotoGalleryB"
#    subs.resource_bundles = {
#      'IRPhotoGallery' => ["**/*.xib", "IRPhotoGallery/**/*.xib"]
#    }
#    subs.source_files  = ["**/*.xib", "IRPhotoGallery/**/*.xib"]
#  end
end

