//
//  NewProjectViewController.m
//  MobileDesigner
//

#import "NewProjectViewController.h"


@implementation NewProjectViewController

@synthesize projectTitleField;
@synthesize widthField;
@synthesize heightField;
@synthesize mapItButton;
@synthesize okButton;
@synthesize cancelButton;


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
	mapView=[[MKMapView alloc] initWithFrame:self.view.frame];
	//mapView.showsUserLocation=TRUE;
	mapView.delegate=self;
	
	CLLocationManager *locationManager=[[CLLocationManager alloc] init];
	locationManager.delegate=self;
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	
	[locationManager startUpdatingLocation];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if(textField == projectTitleField) {
		NSCharacterSet *charactersToRemove =
			[[ NSCharacterSet alphanumericCharacterSet ] invertedSet ];
		
		NSString *trimmedReplacement =
			[ string stringByTrimmingCharactersInSet:charactersToRemove ];
	
		return [string length] == [trimmedReplacement length];
	} else if(textField == heightField || textField == widthField) {
		NSCharacterSet *charactersToRemove = 
			[[ NSCharacterSet decimalDigitCharacterSet ] invertedSet ];
		
		NSString *trimmedReplacement =
		[ string stringByTrimmingCharactersInSet:charactersToRemove ];
		
		return [string length] == [trimmedReplacement length];
	}
	return YES;
}

-(IBAction)okPressed:(UIButton*)sender
{
	NSLog(@"Ok Pressed");
}

- (IBAction)cancelPressed:(UIButton*)sender
{
	NSLog(@"Cancel Pressed");	
}


- (IBAction)mapItButtonPressed:(UIButton*)sender
{
	UIViewController *viewController = [[UIViewController alloc] init];
	
	viewController.view = mapView;
	[self.navigationController pushViewController:viewController animated:YES];
	 
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	location=newLocation.coordinate;
	//One location is obtained.. just zoom to that location
	
	MKCoordinateRegion region;
	region.center=location;
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta=.005;
	span.longitudeDelta=.005;
	region.span=span;
	
	[mapView setRegion:region animated:TRUE];
	
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
