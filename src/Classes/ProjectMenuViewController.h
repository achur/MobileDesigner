//
//  ProjectMenuViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "Project.h"


@interface ProjectMenuViewController : UIViewController {
	NSManagedObjectContext *managedObjectContext;
	Project *project;
}

@property (readonly) BOOL iPad;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Project *project;

- (id)initWithProject:(Project*)project inManagedObjectContext:(NSManagedObjectContext*)ctx;

- (IBAction)editorView:(UIButton*)sender;
- (IBAction)previewView:(UIButton*)sender;
- (IBAction)editSlidesView:(UIButton*)sender;
- (IBAction)playlistView:(UIButton*)sender;
- (IBAction)deleteProject:(UIButton*)sender;

@end
