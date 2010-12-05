//
//  ShapeInspectorWallViewController.m
//  MobileDesigner
//


#import "ShapeInspectorWallViewController.h"
#import "Shape.h"

@implementation ShapeInspectorWallViewController


@synthesize baseTextField;
@synthesize heightTextField;
@synthesize startX;
@synthesize startY;
@synthesize endX;
@synthesize endY;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (id)initWithShape:(Shape *)shp
{
	NSString *nibname = @"";
	if([self iPad]) nibname = @"ShapeInspectorWallViewController-iPad";
	else nibname = @"ShapeInspectorWallViewController";
	if ((self = [super initWithNibName:nibname bundle:nil shape:shp])) {
	}
	return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	double tlx = [startX.text doubleValue];
	double tly = [startY.text doubleValue];
	double base = [baseTextField.text doubleValue];
	double height = [heightTextField.text doubleValue];
	double brx = [endX.text doubleValue];
	double bry = [endY.text doubleValue];
	self.shape.tlx = [NSNumber numberWithDouble:tlx];
	self.shape.tly = [NSNumber numberWithDouble:tly];
	self.shape.brx = [NSNumber numberWithDouble:brx];
	self.shape.bry = [NSNumber numberWithDouble:bry];
	self.shape.tlz = [NSNumber numberWithDouble:(base + height)];
	self.shape.brz = [NSNumber numberWithDouble:base];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	double h1 = [self.shape.brz doubleValue];
	double h2 = [self.shape.tlz doubleValue];
	double tlx = [self.shape.tlx doubleValue];
	double tly = [self.shape.tly doubleValue];
	double brx = [self.shape.brx doubleValue];
	double bry = [self.shape.bry doubleValue];
	baseTextField.text = [NSString stringWithFormat:@"%.2f", h1 < h2 ? h1 : h2];
	heightTextField.text = [NSString stringWithFormat:@"%.2f", h1 < h2 ? h2 - h1 : h1 - h2];
	startX.text = [NSString stringWithFormat:@"%.2f", tlx < brx ? tlx : brx];
	startY.text = [NSString stringWithFormat:@"%.2f", tlx < brx ? tly : bry];
	endX.text = [NSString stringWithFormat:@"%.2f", tlx < brx ? brx : tlx];
	endY.text = [NSString stringWithFormat:@"%.2f", tlx < brx ? bry : tly];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSRange index = [textField.text rangeOfString:@"."]; 
	if (index.location != NSNotFound){
		int len = textField.text.length;
		index.location = index.location+1;
		index.length = len - index.location;
		index = [textField.text rangeOfString:@"." options:NSLiteralSearch range:index];
		if(index.location != NSNotFound){
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"You can only have one decimal!" 
														   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[[alert autorelease] show];
			return NO;
		}
		
	}
	NSCharacterSet *decimal = [NSCharacterSet characterSetWithCharactersInString: @".123456789"];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:textField.text];
	if (![decimal isSupersetOfSet:inStringSet]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"You can only include numbers and decimals!" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[[alert autorelease] show];
		return NO;
	}
	[textField resignFirstResponder];
	return YES;
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
