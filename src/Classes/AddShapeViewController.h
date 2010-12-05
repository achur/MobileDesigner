//
//  AddShapeViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>

@protocol AddShapeDelegate

- (void)addShape:(int)type;

@end

@interface AddShapeViewController : UITableViewController {
	
	id <AddShapeDelegate> delegate;
}

@property (nonatomic, retain) id <AddShapeDelegate> delegate;

@end
