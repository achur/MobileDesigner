//
//  MobileDesignerUtilities.h
//  MobileDesigner
//

#import <Foundation/Foundation.h>


@interface MobileDesignerUtilities : NSObject {
}

+ (UIImage *)screencapture:(UIView *)view;
+ (NSData *)screencaptureData:(UIView *)view;

@end
