//
//  MobileDesignerAppDelegate.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NewProjectViewController.h"

@interface MobileDesignerAppDelegate : NSObject <UIApplicationDelegate, ProjectCreatorDelegate> {
    
    UIWindow *window;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (readonly) BOOL iPad;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;
- (IBAction)createNewProject:(UIButton*)sender;
- (IBAction)loadExistingProject:(UIButton*)sender;

- (void)shouldCreateProject:(NSString*)name withWidth:(int)width height:(int)height andTexture:(UIImage*)tex;
- (void)handleCancel;

@end

