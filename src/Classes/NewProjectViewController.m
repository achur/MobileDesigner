//
//  NewProjectViewController.m
//  MobileDesigner
//

// The amount to which we want to zoom so the map view automatically
// sizes to an "Average" project
#define MAPZOOMFACTOR 0.003

#import "NewProjectViewController.h"
#import "MobileDesignerUtilities.h"
#import "Project.h"

@implementation NewProjectViewController

@synthesize projectTitleField;
@synthesize widthField;
@synthesize heightField;
@synthesize mapItButton;
@synthesize okButton;
@synthesize cancelButton;
@synthesize textureAttachedLabel;
@synthesize delegate; 


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
	mappingLocation = NO;
	hasCenteredMap = NO;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if(textField == heightField || textField == widthField) {
		mappingLocation = NO;
		[textureAttachedLabel setHidden:YES];
	}
	return YES;
}

-(IBAction)okPressed:(UIButton*)sender
{
	if([projectTitleField.text length] <= 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Please enter a title" 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[[alert autorelease] show];
		return;
	} else if([Project searchByName:projectTitleField.text inManagedObjectContext:[delegate managedObjectContext]]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"That title is already taken.  Please select again." 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[[alert autorelease] show];
		return;
	}
	if([widthField.text length] <= 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Please enter a width" 
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[[alert autorelease] show];
		return;
	}
	if([heightField.text length] <= 0) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Please enter a height" 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[[alert autorelease] show];
		return;
	}
	int inputwidth = [widthField.text intValue];
	int inputheight = [heightField.text intValue];
    NSData* im = [MobileDesignerUtilities screencaptureData:mapView];	
	[self.navigationController popViewControllerAnimated:NO];
	[delegate shouldCreateProject:projectTitleField.text withWidth:inputwidth height:inputheight andTexture:im];	
}

- (IBAction)cancelPressed:(UIButton*)sender
{
	[self.navigationController popViewControllerAnimated:YES];
	[delegate handleCancel];
}


- (IBAction)mapItButtonPressed:(UIButton*)sender
{
	if(!mapView) {
		mapView=[[MKMapView alloc] initWithFrame:self.view.frame];
		mapView.delegate=self;
	}
	
	if(!hasCenteredMap) {
		CLLocationManager *locationManager=[[CLLocationManager alloc] init];
		locationManager.delegate=self;
		locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	
		[locationManager startUpdatingLocation];
	
		hasCenteredMap = YES;
	}
	
	
	UIViewController *viewController = [[[UIViewController alloc] init] autorelease];
	viewController.view = mapView;
	[self.navigationController pushViewController:viewController animated:YES];
	
	mappingLocation = YES;
	[textureAttachedLabel setHidden:NO];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	location=newLocation.coordinate;
	//One location is obtained.. just zoom to that location
	
	MKCoordinateRegion region;
	region.center=location;
	
	// Zoom in sufficiently for average project
	MKCoordinateSpan span;
	span.latitudeDelta = MAPZOOMFACTOR;
	span.longitudeDelta = MAPZOOMFACTOR;
	region.span=span;
	
	[mapView setRegion:region animated:TRUE];
	
}

- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated
{
	double mwidth = mapView.region.span.longitudeDelta;
	double mheight = mapView.region.span.latitudeDelta;
	widthField.text = [NSString stringWithFormat:@"%d", (int)(mwidth * 1000000)];
	heightField.text = [NSString stringWithFormat:@"%d", (int)(mheight * 1000000)];
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
