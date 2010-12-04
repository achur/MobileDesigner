//
//  EditorViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "EditorView.h"
#import "Project.h"


@interface EditorViewController : UIViewController <EditorViewDelegate> {
	EditorView *editorView;
	Project *project;
	NSManagedObjectContext *managedObjectContext;
}

@property (readonly) BOOL iPad;

@property (retain) IBOutlet EditorView *editorView;

@property (nonatomic, retain) Project *project;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)addNewShape:(UIButton*)sender;
- (IBAction)takeSnapshot:(UIButton*)sender;
- (IBAction)inspectShape:(UIButton*)sender;

- (void)modelChanged;
- (void)shapeSelected:(Shape *)shape;
- (Project *)project;

@end
