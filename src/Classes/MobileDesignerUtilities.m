//
//  MobileDesignerUtilities.m
//  MobileDesigner
//
//  Created by Manoli Liodakis on 12/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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

@end
