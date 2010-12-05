//
//  MobileDesignerUtilities.h
//  MobileDesigner
//

#import <Foundation/Foundation.h>


@interface MobileDesignerUtilities : NSObject {
}

+ (UIImage *)screencapture:(UIView *)view;
+ (NSData *)screencaptureData:(UIView *)view;

+ (UIColor*)colorFromInt:(int)color;
+ (int)intFromR:(int)r G:(int)g B:(int)b;

@end
