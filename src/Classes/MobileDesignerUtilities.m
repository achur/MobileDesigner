//
//  MobileDesignerUtilities.m
//  MobileDesigner
//

#import "MobileDesignerUtilities.h"
#import <QuartzCore/QuartzCore.h>


@implementation MobileDesignerUtilities


+ (UIImage *)screencapture:(UIView *)view {
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
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

@end
