//
//  MobileDesignerUtilities.m
//  MobileDesigner
//

#import "MobileDesignerUtilities.h"
#import <QuartzCore/QuartzCore.h>


@implementation MobileDesignerUtilities


+ (UIImage *)screencapture:(UIView *)view {
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	screenRect.origin.y = 64; // padding for the navigation controller
	screenRect.size.height -= 64;
	
	UIGraphicsBeginImageContext(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
	
	[view.layer renderInContext:ctx];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

+ (NSData *)screencaptureData:(UIView *)view {
	UIImage *newImage = [MobileDesignerUtilities screencapture:view];
	
	UIGraphicsEndImageContext();
	
	return UIImagePNGRepresentation(newImage);
}

+ (UIColor*)colorFromInt:(int)color {
	float red = (color & 0xFF000000) >> 24;
	float green = (color & 0x00FF0000) >> 16;
	float blue = (color & 0x0000FF00) >> 8;
	red /= 255;
	green /= 255;
	blue /= 255;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (int)intFromR:(int)r G:(int)g B:(int)b {
	if( r < 0 ) r = 0;
	if( g < 0 ) g = 0;
	if( b < 0 ) b = 0;
	if( r > 255 ) r = 255;
	if( g > 255 ) g = 255;
	if( b > 255 ) b = 255;
	return (r << 24) | (g << 16) | (b << 8);
}

@end
