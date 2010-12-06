//
//  PresentedSlideViewController.m
//  MobileDesigner
//
//  Created by Manoli Liodakis on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PresentedSlideViewController.h"


@implementation PresentedSlideViewController

@synthesize imageView;
@synthesize label;

- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (id)initWithSlide:(Slide *)sl {
	NSString* nibname = @"";
	if([self iPad]) nibname = @"PresentedSlideViewController-iPad";
	else nibname = @"PresentedSlideViewController";
	if ((self = [super initWithNibName:nibname bundle:nil])) {
		slide = sl;
	}
	return self;
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		
		UINavigationController *navcon = self.navigationController;
		[navcon popViewControllerAnimated:NO];
		PresentedSlideViewController *esvc = [[PresentedSlideViewController alloc] initWithSlide:[slide nextSlide]];
		[navcon pushViewController:esvc animated:YES];
		
		NSLog(@"Tapity tap tap");
	}
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	label.text = slide.text;
	imageView.image = [UIImage imageWithData:slide.image];
	UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	tapgr.numberOfTapsRequired = 1;
	[self.view addGestureRecognizer:tapgr];
	[tapgr release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
