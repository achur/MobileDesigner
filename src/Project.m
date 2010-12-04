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
	}
	
	return project;
}


- (NSString *)firstLetterOfName
{
	return [[self.name substringToIndex:1] capitalizedString];
}

@end
