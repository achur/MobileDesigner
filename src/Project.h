//
//  Project.h
//  MobileDesigner
//

#import <CoreData/CoreData.h>

@class Shape;
@class Slide;

@interface Project :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * floorTexture;
@property (nonatomic, retain) NSNumber * hasTexture;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * curSlideNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* shapes;
@property (nonatomic, retain) NSSet* slides;

+ (Project *)projectWithName:(NSString *)name width:(int)width height:(int)height texture:(NSData*)tex inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Project *)searchByName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)addShapeWithColor:(int)col tlx:(double)lx tly:(double)ly tlz:(double)lz 
					  brx:(double)rx bry:(double)ry brz:(double)rz type:(int)t inManagedObjectContext:(NSManagedObjectContext *)context;

- (void)addSlideWithImage:(NSData *)im inManagedObjectContext:(NSManagedObjectContext*)context;

@end


@interface Project (CoreDataGeneratedAccessors)
- (void)addShapesObject:(Shape *)value;
- (void)removeShapesObject:(Shape *)value;
- (void)addShapes:(NSSet *)value;
- (void)removeShapes:(NSSet *)value;

- (void)addSlidesObject:(Slide *)value;
- (void)removeSlidesObject:(Slide *)value;
- (void)addSlides:(NSSet *)value;
- (void)removeSlides:(NSSet *)value;

@end

