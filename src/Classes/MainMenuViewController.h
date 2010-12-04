//
//  MainMenuViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "ProjectRoutingDelegates.h"


@interface MainMenuViewController : UIViewController <ProjectCreatorDelegate, ProjectOpenerDelegate> {
	NSManagedObjectContext *managedObjectContext;
}


@property (readonly) BOOL iPad;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)createNewProject:(UIButton*)sender;
- (IBAction)loadExistingProject:(UIButton*)sender;
- (void)openProject:(Project*) project;


- (void)shouldCreateProject:(NSString*)name withWidth:(int)width height:(int)height andTexture:(NSData*)tex;
- (void)handleCancel;

@end
