//
//  EditorViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "EditorView.h"
#import "Project.h"
#import "AddShapeViewController.h"
#import "ShapeInspectorViewController.h"

@interface EditorViewController : UIViewController <EditorViewDelegate, AddShapeDelegate, ShapeInspectorDelegate> {
	EditorView *editorView;
	Project *project;
	NSManagedObjectContext *managedObjectContext;
	Shape *selectedShape;
	UIButton *inspectButton;
}

@property (readonly) BOOL iPad;

@property (retain) IBOutlet EditorView *editorView;
@property (retain) IBOutlet UIButton *inspectButton;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Shape *selectedShape;

- (IBAction)addNewShape:(UIButton*)sender;
- (IBAction)takeSnapshot:(UIButton*)sender;
- (IBAction)inspectShape:(UIButton*)sender;

- (void)modelChanged;
- (void)shapeSelected:(Shape *)shape;
- (Project *)project;

- (void)doneEditing:(BOOL)deleteShape;

- (void)addShape:(int)type;

@end
