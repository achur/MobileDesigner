//
//  Shape.h
//  MobileDesigner
//

#import <CoreData/CoreData.h>

#define SHAPETYPELEVEL 0
#define SHAPETYPEWALL 1
#define SHAPETYPEBILLBOARD 2

@class Project;

@interface Shape :  NSManagedObject  
{
}

+ (Shape *)shapeWithColor:(int)col tlx:(double)lx tly:(double)ly tlz:(double)lz 
						brx:(double)rx bry:(double)ry brz:(double)rz type:(int)t project:(Project *)proj inManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL)hitTextAtX:(double)xval Y:(double)yval;

@property (nonatomic, retain) NSNumber * hasTexture;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * tly;
@property (nonatomic, retain) NSNumber * brz;
@property (nonatomic, retain) NSNumber * tlx;
@property (nonatomic, retain) NSData * texture;
@property (nonatomic, retain) NSNumber * bry;
@property (nonatomic, retain) NSNumber * brx;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * tlz;
@property (nonatomic, retain) Project * project;

@end



