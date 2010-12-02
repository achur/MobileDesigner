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
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* shapes;
@property (nonatomic, retain) NSSet* slides;

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

