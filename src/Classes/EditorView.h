//
//  EditorView.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "Shape.h"

@protocol EditorViewDelegate
- (void)modelChanged;
- (void)shapeSelected:(Shape *)shape;
- (Project *)project;
- (NSManagedObjectContext *)managedObjectContext;
- (int)offsetHeight;
@end

@interface EditorView : UIView {
	id <EditorViewDelegate> delegate;
	
	double left;
	double right;
	double top;
	double bottom;
	
	
}

- (void)update;

@end
