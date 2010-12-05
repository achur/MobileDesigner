//
//  ShapeInspectorWallViewController.h
//  MobileDesigner
//


#import <UIKit/UIKit.h>
#import "ShapeInspectorViewController.h"

@interface ShapeInspectorWallViewController : ShapeInspectorViewController {
	UITextField* baseTextField;
	UITextField* heightTextField;
	UITextField* startX;
	UITextField* startY;
	UITextField* endX;
	UITextField* endY;
}

@property (retain) IBOutlet	UITextField* baseTextField;
@property (retain) IBOutlet	UITextField* heightTextField;
@property (retain) IBOutlet	UITextField* startX;
@property (retain) IBOutlet	UITextField* startY;
@property (retain) IBOutlet	UITextField* endX;
@property (retain) IBOutlet	UITextField* endY;

- (id)initWithShape:(Shape *)shp;


@end
