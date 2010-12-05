// 
//  Project.m
//  MobileDesigner
//

#import "Project.h"

#import "Shape.h"
#import "Slide.h"

@implementation Project 

@dynamic floorTexture;
@dynamic hasTexture;
@dynamic height;
@dynamic width;
@dynamic curSlideNumber;
@dynamic name;
@dynamic shapes;
@dynamic slides;

+ (Project *)searchByName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
	Project *project = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	
	NSError *error = nil;
	project = [[context executeFetchRequest:request error:&error] lastObject];
	
	return project;
}

+ (Project *)projectWithName:(NSString *)name width:(int)width height:(int)height texture:(NSData*)tex inManagedObjectContext:(NSManagedObjectContext *)context
{
	Project *project = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	
	NSError *error = nil;
	project = [[context executeFetchRequest:request error:&error] lastObject];
	
	if (!error && !project) {
		project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
		project.name = name;
		project.width = [NSNumber numberWithInt:width];
		project.height = [NSNumber numberWithInt:height];
		if(!tex) {
			project.hasTexture = [NSNumber numberWithBool:NO];
		} else {
			project.hasTexture = [NSNumber numberWithBool:YES];
			project.floorTexture = tex;
		}
		project.curSlideNumber = [NSNumber numberWithInt:0];
	}
	
	return project;
}

- (void)addShapeWithColor:(int)col tlx:(double)lx tly:(double)ly tlz:(double)lz 
					  brx:(double)rx bry:(double)ry brz:(double)rz type:(int)t inManagedObjectContext:(NSManagedObjectContext *)context 
{
	Shape *shape = [Shape shapeWithColor:col tlx:lx tly:ly tlz:lz brx:rx bry:ry brz:rz type:t project:self inManagedObjectContext:context];
	NSLog(@"Here we have (%f, %f) to (%f, %f)", [shape.tlx doubleValue], [shape.tly doubleValue], [shape.brx doubleValue], [shape.bry doubleValue]);
	[self addShapesObject:shape];
}

- (void)addSlideWithImage:(NSData *)im inManagedObjectContext:(NSManagedObjectContext*)context
{
	Slide *slide = [Slide slideWithImage:im project:self inManagedObjectContext:context];
	// advance current slide number
	self.curSlideNumber = [NSNumber numberWithInt:(1 + [self.curSlideNumber intValue])];
	[self addSlidesObject:slide];
}



- (NSString *)firstLetterOfName
{
	return [[self.name substringToIndex:1] capitalizedString];
}

@end
