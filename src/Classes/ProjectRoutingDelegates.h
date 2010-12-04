/*
 *  ProjectRoutingDelegates.h
 *  MobileDesigner
 */

#import "Project.h"
#import <UIKit/UIKit.h>


@protocol ProjectOpenerDelegate<NSObject>

- (void)openProject:(Project*) project;

@end

@protocol ProjectCreatorDelegate<NSObject>

- (void)shouldCreateProject:(NSString*)name withWidth:(int)width height:(int)height andTexture:(NSData*)tex;
- (void)handleCancel;
- (NSManagedObjectContext *)managedObjectContext;

@end