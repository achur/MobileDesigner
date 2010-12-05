// 
//  Shape.m
//  MobileDesigner
//

#import "Shape.h"

#import "Project.h"

@implementation Shape 

@dynamic hasTexture;
@dynamic color;
@dynamic tly;
@dynamic brz;
@dynamic tlx;
@dynamic texture;
@dynamic bry;
@dynamic brx;
@dynamic type;
@dynamic tlz;
@dynamic project;

+ (Shape *)shapeWithColor:(int)col tlx:(double)lx tly:(double)ly tlz:(double)lz 
					  brx:(double)rx bry:(double)ry brz:(double)rz type:(int)t project:(Project *)proj inManagedObjectContext:(NSManagedObjectContext *)context
{
	Shape *shape = nil;
	
	shape = [NSEntityDescription insertNewObjectForEntityForName:@"Shape" inManagedObjectContext:context];
	shape.color = [NSNumber numberWithInt:col];
	shape.tlx = [NSNumber numberWithDouble:lx];
	shape.tly = [NSNumber numberWithDouble:ly];
	shape.tlz = [NSNumber numberWithDouble:lz];
	shape.brx = [NSNumber numberWithDouble:rx];
	shape.bry = [NSNumber numberWithDouble:ry];
	shape.brz = [NSNumber numberWithDouble:rz];
	shape.type = [NSNumber numberWithInt:t];
	shape.project = proj;
	
	return shape;
}

- (BOOL)hitTextAtX:(double)xval Y:(double)yval
{
	return (([self.tlx doubleValue] < xval && xval < [self.brx doubleValue]) || ([self.brx doubleValue] < xval && xval < [self.tlx doubleValue])) &&
			(([self.tly doubleValue] < yval && yval < [self.bry doubleValue]) || ([self.bry doubleValue] < yval && yval < [self.tly doubleValue]));
}


@end
