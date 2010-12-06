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

- (Slide *)nextSlide
{
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Slide" inManagedObjectContext:[self managedObjectContext]];
	request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"number"
																				   ascending:YES]];
	
	request.predicate = [NSPredicate predicateWithFormat:@"project == %@ AND number > %@", self.project, self.number];
	request.fetchBatchSize = 20;
	NSError *error = nil;
	Slide *sld = [[[self managedObjectContext] executeFetchRequest:request error:&error] objectAtIndex:0];
	
	[request release];
	
	return sld;
}

@end
