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
- (Shape *)selectedShape;
@end

@interface EditorView : UIView {
	id <EditorViewDelegate> delegate;
	
	double left;
	double right;
	double top;
	double bottom;
	
	BOOL hasDrawn;
	
	UIImage* cachedFloorTexture;
	
	int selectedKnob;
}

- (void)update;

@property double left;
@property double right;
@property double top;
@property double bottom;

@end
