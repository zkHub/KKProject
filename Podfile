#添加使用库的地址
#source 'https://gitee.com/zkHub/MySpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://cdn.cocoapods.org/'

# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

pod 'Reachability'


target 'KKProject' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
   use_frameworks!

  # Pods for KKProject
    pod 'YYKit'
    pod 'AFNetworking'
    pod 'SDWebImage'
    pod 'OpenUDID'
    pod 'Masonry'
    pod 'MJExtension'
    pod 'MJRefresh'
    pod 'MBProgressHUD'
    pod 'ReactiveObjC'
    pod 'FMDB'
    pod 'SocketRocket'
    pod 'SnapKit'
    pod "HJDanmaku"
#    pod 'MMKV'
    
    #私有库
#    pod 'podLibTest'

target 'MonitorFlow' do

end
#
#
#  target 'KKProjectTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end
#
#  target 'KKProjectUITests' do
#    inherit! :search_paths
#    # Pods for testing
#  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end

  

end
