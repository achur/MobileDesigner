//
//  MobileDesignerAppDelegate.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MobileDesignerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;
- (IBAction)createNewProject:(UIButton*)sender;
- (IBAction)loadExistingProject:(UIButton*)sender;

@end

