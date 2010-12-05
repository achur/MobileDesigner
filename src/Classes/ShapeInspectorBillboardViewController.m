//
//  ShapeInspectorBillboardViewController.m
//  MobileDesigner
//

#import "ShapeInspectorBillboardViewController.h"
#import "Shape.h"

@implementation ShapeInspectorBillboardViewController

@synthesize	baseTextField;
@synthesize	heightTextField;
@synthesize	centerXTextField;
@synthesize centerYTextField;
@synthesize	radiusTextField;

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
	if([self iPad]) nibname = @"ShapeInspectorBillboardViewController-iPad";
	else nibname = @"ShapeInspectorBillboardViewController";
	if ((self = [super initWithNibName:nibname bundle:nil shape:shp])) {
	}
	return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	double centerX = [centerXTextField.text doubleValue];
	double centerY = [centerYTextField.text doubleValue];
	double base = [baseTextField.text doubleValue];
	double height = [heightTextField.text doubleValue];
	double radius = [radiusTextField.text doubleValue];
	self.shape.tlx = [NSNumber numberWithDouble:(centerX - radius)];
	self.shape.tly = [NSNumber numberWithDouble:(centerY - radius)];
	self.shape.brx = [NSNumber numberWithDouble:(centerX + radius)];
	self.shape.bry = [NSNumber numberWithDouble:(centerY + radius)];
	self.shape.tlz = [NSNumber numberWithDouble:(base + height)];
	self.shape.brz = [NSNumber numberWithDouble:base];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	double h1 = [self.shape.brz doubleValue];
	double h2 = [self.shape.tlz doubleValue];
	double centerX = ([self.shape.tlx doubleValue] + [self.shape.brx doubleValue])/2;
	double centerY = ([self.shape.tly doubleValue] + [self.shape.bry doubleValue])/2;
	double radius = centerX - [self.shape.tlx doubleValue];
	if(radius < 0) radius *= -1;
	baseTextField.text = [NSString stringWithFormat:@"%.2f", h1 < h2 ? h1 : h2];
	heightTextField.text = [NSString stringWithFormat:@"%.2f", h1 < h2 ? h2 - h1 : h1 - h2];
	centerXTextField.text = [NSString stringWithFormat:@"%.2f", centerX];
	centerYTextField.text = [NSString stringWithFormat:@"%.2f", centerY];
	radiusTextField.text = [NSString stringWithFormat:@"%.2f", radius];
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
