// 
//  Slide.m
//  MobileDesigner
//

#import "Slide.h"

#import "Project.h"

@implementation Slide 

@dynamic image;
@dynamic number;
@dynamic text;
@dynamic project;

+ (Slide *)slideWithImage:(NSData *)im project:(Project *)proj inManagedObjectContext:(NSManagedObjectContext *)context
{
	Slide *slide = nil;
	
	slide = [NSEntityDescription insertNewObjectForEntityForName:@"Slide" inManagedObjectContext:context];
	slide.image = im;
	slide.text = @"";
	slide.project = proj;
	slide.number = proj.curSlideNumber;
	
	return slide;
}

@end
