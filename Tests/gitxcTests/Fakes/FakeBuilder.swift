
import Foundation

struct FakeBuilder {

}

//------------------------------------
// MARK: Plist Text
//------------------------------------
extension FakeBuilder {
    
    static func stringWithConflict() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <<<<<<< HEAD
        <string>2</string>
        =======
        <string>3</string>
        >>>>>>> otherBranch
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <key>UIApplicationSupportsIndirectInputEvents</key>
        <true/>
        <key>UILaunchScreen</key>
        <dict/>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
        <string>armv7</string>
        </array>
        <key>UISupportedInterfaceOrientations</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        <key>UISupportedInterfaceOrientations~ipad</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        </dict>
        </plist>
        """
    }

    static func stringWithOtherConflict() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <<<<<<< HEAD
        <string>1.0</string>
        =======
        <string>1.1</string>
        >>>>>>> otherBranch
        <key>CFBundleVersion</key>
        <string>2</string>
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <key>UIApplicationSupportsIndirectInputEvents</key>
        <true/>
        <key>UILaunchScreen</key>
        <dict/>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
        <string>armv7</string>
        </array>
        <key>UISupportedInterfaceOrientations</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        <key>UISupportedInterfaceOrientations~ipad</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        </dict>
        </plist>
        """
    }

    static func misformattedStringWithConflict() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <<<<<<< HEAD
        <string>2</string>
        =======
        <string>3</string>
        >>>>>>> otherBranch
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <dict/>
        <array>
        </plist>
        """
    }
    
    static func stringWithTwoConflicts() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <<<<<<< HEAD
        <string>1.0</string>
        =======
        <string>1.1</string>
        >>>>>>> otherBranch
        <key>CFBundleVersion</key>
        <<<<<<< HEAD
        <string>2</string>
        =======
        <string>3</string>
        >>>>>>> otherBranch
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <key>UIApplicationSupportsIndirectInputEvents</key>
        <true/>
        <key>UILaunchScreen</key>
        <dict/>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
        <string>armv7</string>
        </array>
        <key>UISupportedInterfaceOrientations</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        <key>UISupportedInterfaceOrientations~ipad</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        </dict>
        </plist>
        """
    }

    static func stringWithTwoChangesInConflict() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <<<<<<< HEAD
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <string>2</string>
        =======
        <string>1.1</string>
        <key>CFBundleVersion</key>
        <string>3</string>
        >>>>>>> otherBranch
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <key>UIApplicationSupportsIndirectInputEvents</key>
        <true/>
        <key>UILaunchScreen</key>
        <dict/>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
        <string>armv7</string>
        </array>
        <key>UISupportedInterfaceOrientations</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        <key>UISupportedInterfaceOrientations~ipad</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        </dict>
        </plist>
        """
    }

    static func stringWithoutConflict() -> String {
        
    """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>$(DEVELOPMENT_LANGUAGE)</string>
        <key>CFBundleExecutable</key>
        <string>$(EXECUTABLE_NAME)</string>
        <key>CFBundleIdentifier</key>
        <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>$(PRODUCT_NAME)</string>
        <key>CFBundlePackageType</key>
        <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
        <key>CFBundleVersion</key>
        <string>2</string>
        <key>LSRequiresIPhoneOS</key>
        <true/>
        <key>UIApplicationSceneManifest</key>
        <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <true/>
        </dict>
        <key>UIApplicationSupportsIndirectInputEvents</key>
        <true/>
        <key>UILaunchScreen</key>
        <dict/>
        <key>UIRequiredDeviceCapabilities</key>
        <array>
        <string>armv7</string>
        </array>
        <key>UISupportedInterfaceOrientations</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        <key>UISupportedInterfaceOrientations~ipad</key>
        <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
        </array>
        </dict>
        </plist>
        """
    }

}
