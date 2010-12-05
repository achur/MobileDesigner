//
//  ShapeInspectorViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "Shape.h"

@protocol ShapeInspectorDelegate

- (void)doneEditing:(BOOL)deleteShape;

@end


@interface ShapeInspectorViewController : UIViewController {
	UISlider* redSlider;
	UISlider* greenSlider;
	UISlider* blueSlider;
	UILabel* textureSelectedLabel;
	UIButton* removeTextureButton;
	Shape* shape;
	id <ShapeInspectorDelegate> delegate;
}

@property (retain) IBOutlet UISlider *redSlider;
@property (retain) IBOutlet UISlider *greenSlider;
@property (retain) IBOutlet UISlider *blueSlider;
@property (retain) IBOutlet UILabel *textureSelectedLabel;
@property (retain) IBOutlet UIButton *removeTextureButton;

@property (assign) Shape *shape;

@property (nonatomic, retain) id <ShapeInspectorDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shape:(Shape*)shp;

- (IBAction)selectTexturePressed:(UIButton*)sender;
- (IBAction)removeTexturePressed:(UIButton*)sender;
- (IBAction)deleteShapePressed:(UIButton*)sender;

@end
