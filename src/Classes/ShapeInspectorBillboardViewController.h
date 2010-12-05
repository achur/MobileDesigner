//
//  ShapeInspectorBillboardViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "ShapeInspectorViewController.h"


@interface ShapeInspectorBillboardViewController : ShapeInspectorViewController {
	UITextField* baseTextField;
	UITextField* heightTextField;
	UITextField* centerXTextField;
	UITextField* centerYTextField;
	UITextField* radiusTextField;
}

@property (retain) IBOutlet	UITextField* baseTextField;
@property (retain) IBOutlet	UITextField* heightTextField;
@property (retain) IBOutlet	UITextField* centerXTextField;
@property (retain) IBOutlet	UITextField* centerYTextField;
@property (retain) IBOutlet	UITextField* radiusTextField;

- (id)initWithShape:(Shape *)shp;

@end
