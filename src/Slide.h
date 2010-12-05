//
//  Slide.h
//  MobileDesigner
//

#import <CoreData/CoreData.h>

@class Project;

@interface Slide :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Project * project;

+ (Slide *)slideWithImage:(NSData *)im project:(Project *)proj inManagedObjectContext:(NSManagedObjectContext *)context;

@end



