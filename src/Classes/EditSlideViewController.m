//
//  EditSlideViewController.m
//  MobileDesigner
//
//  Created by Manoli Liodakis on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditSlideViewController.h"
#import "Project.h"

@implementation EditSlideViewController

@synthesize captionField;
@synthesize imageView;
@synthesize delegate;


- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (id)initWithSlide:(Slide *)sl {
	NSString* nibname = @"";
	if([self iPad]) nibname = @"EditSlideViewController-iPad";
	else nibname = @"EditSlideViewController";
	if ((self = [super initWithNibName:nibname bundle:nil])) {
		slide = sl;
	}
	return self;
}

- (IBAction)deleteSlidePressed:(UIButton*)sender {
	Project *proj = slide.project;
	[proj removeSlidesObject:slide];
	Slide *toDelete = slide;
	slide = nil;
	[[delegate managedObjectContext] deleteObject:toDelete];
	[self.navigationController popViewControllerAnimated:YES];
	[delegate updateTableData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
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
	captionField.text = slide.text;
	imageView.image = [UIImage imageWithData:slide.image];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	 slide.text = captionField.text;
	 
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
