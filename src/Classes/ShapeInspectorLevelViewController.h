//
//  ShapeInspectorLevelViewController.h
//  MobileDesigner
//
//  Created by Manoli Liodakis on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShapeInspectorViewController.h"

@interface ShapeInspectorLevelViewController : ShapeInspectorViewController <UITextFieldDelegate>{
	UITextField* baseTextField;
	UITextField* heightTextField;
	UITextField* rectWidth;
	UITextField* rectHeight;
	UITextField* topLeftX;
	UITextField* topLeftY;
}

@property (retain) IBOutlet	UITextField* baseTextField;
@property (retain) IBOutlet	UITextField* heightTextField;
@property (retain) IBOutlet	UITextField* rectWidth;
@property (retain) IBOutlet	UITextField* rectHeight;
@property (retain) IBOutlet	UITextField* topLeftX;
@property (retain) IBOutlet	UITextField* topLeftY;

- (id)initWithShape:(Shape *)shp;


@end
