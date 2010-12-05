//
//  OnlineTextureSelectorViewController.m
//  MobileDesigner
//
//  Created by Manoli Liodakis on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OnlineTextureSelectorViewController.h"


@implementation OnlineTextureSelectorViewController

@synthesize urlBar;
@synthesize chooserButton;
@synthesize web;
@synthesize delegate;


- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (id)initWithDelegate:(id) del { // need to change this declaration.
	NSString *nibname = @"";
	if([self iPad]) nibname = @"OnlineTextureSelectorViewController-iPad";
	else nibname = @"OnlineTextureSelectorViewController";
	if((self = [super initWithNibName:nibname bundle:nil])) {
		self.delegate = del;
	}
	return self;
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navType {
	urlBar.text = [request.URL absoluteString];
	NSString *ext = [[[request.URL absoluteURL] path] pathExtension];
	if([ext isEqualToString:@"jpg"] ||
	   [ext isEqualToString:@"jpeg"] ||
	   [ext isEqualToString:@"gif"] ||
	   [ext isEqualToString:@"png"] ||
	   [ext isEqualToString:@"bmp"] ||
	   [ext isEqualToString:@"ico"] ||
	   [ext isEqualToString:@"cur"] ||
	   [ext isEqualToString:@"xbm"]) {
		chooserButton.enabled = YES;
	} else {
		chooserButton.enabled = NO;
	}
	return YES;
}

- (IBAction)navigate:(UIButton*)sender {
	NSURL *googleImages = [NSURL URLWithString:urlBar.text];
	NSURLRequest *req = [NSURLRequest requestWithURL:googleImages];
	[self.web loadRequest:req];
}

- (IBAction)selectImage:(UIButton*)sender {
	UIImage* myImage = [UIImage imageWithData: 
						[NSData dataWithContentsOfURL: 
						 [NSURL URLWithString:urlBar.text]]];
	[delegate imageSelected:myImage];
	[self.navigationController popViewControllerAnimated:YES];
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
	NSURL *googleImages = [NSURL URLWithString:@"http://images.google.com/"];
	NSURLRequest *req = [NSURLRequest requestWithURL:googleImages];
	[self.web loadRequest:req];
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
