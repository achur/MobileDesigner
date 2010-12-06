//
//  EditSlideViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "Slide.h"

@protocol SlideEditDelegate

- (void)updateTableData;
- (NSManagedObjectContext *)managedObjectContext;

@end


@interface EditSlideViewController : UIViewController <UITextFieldDelegate> {
	UITextField* captionField;
	UIImageView* imageView;
	
	id <SlideEditDelegate> delegate;
	
	Slide *slide;
}

@property (retain) IBOutlet	UITextField* captionField;
@property (retain) IBOutlet	UIImageView* imageView;
@property (assign) id <SlideEditDelegate> delegate;

- (id)initWithSlide:(Slide *)sl;

- (IBAction)deleteSlidePressed:(UIButton*)sender;

@end
