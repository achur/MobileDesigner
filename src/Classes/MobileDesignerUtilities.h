//
//  MobileDesignerUtilities.h
//  MobileDesigner
//

#import <Foundation/Foundation.h>


@interface MobileDesignerUtilities : NSObject {
}

+ (UIImage *)screencapture:(UIView *)view withPadding:(int)padding;
+ (NSData *)screencaptureData:(UIView *)view withPadding:(int)padding;

+ (UIColor*)colorFromInt:(int)color;
+ (int)intFromR:(int)r G:(int)g B:(int)b;

@end
