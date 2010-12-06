//
//  PresentedSlideViewController.h
//  MobileDesigner
//

#import <UIKit/UIKit.h>
#import "Slide.h";

@interface PresentedSlideViewController : UIViewController {
	UILabel* label;
	UIImageView* imageView;
	Slide *slide;
}

@property (retain) IBOutlet	UILabel* label;
@property (retain) IBOutlet	UIImageView* imageView;

- (id)initWithSlide:(Slide *)sl;

@end
