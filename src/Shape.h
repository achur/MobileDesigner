//
//  Shape.h
//  MobileDesigner
//

#import <CoreData/CoreData.h>

@class Project;

@interface Shape :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * hasTexture;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * tly;
@property (nonatomic, retain) NSNumber * brz;
@property (nonatomic, retain) NSNumber * tlx;
@property (nonatomic, retain) NSData * texture;
@property (nonatomic, retain) NSNumber * bry;
@property (nonatomic, retain) NSNumber * blz;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * tlz;
@property (nonatomic, retain) Project * project;

@end



