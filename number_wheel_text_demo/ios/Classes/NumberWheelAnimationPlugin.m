#import "NumberWheelAnimationPlugin.h"
#if __has_include(<number_wheel_animation/number_wheel_animation-Swift.h>)
#import <number_wheel_animation/number_wheel_animation-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "number_wheel_animation-Swift.h"
#endif

@implementation NumberWheelAnimationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNumberWheelAnimationPlugin registerWithRegistrar:registrar];
}
@end
