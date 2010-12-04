//
//  MainMenuViewController.m
//  MobileDesigner
//

#import "MainMenuViewController.h"
#import "NewProjectViewController.h"
#import "ProjectsTableViewController.h"

@implementation MainMenuViewController

@synthesize managedObjectContext;


- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (IBAction)createNewProject:(UIButton*)sender {
	NewProjectViewController *newproj;
	if(self.iPad) {
		newproj = [[NewProjectViewController alloc] initWithNibName:@"NewProjectViewController-iPad" bundle:nil];
	} else {
		newproj = [[NewProjectViewController alloc] initWithNibName:@"NewProjectViewController" bundle:nil];
	}
	newproj.delegate = self;
	newproj.title = @"Create a new project";
	[newproj autorelease];
	[self.navigationController pushViewController:newproj animated:YES];
}

- (IBAction)loadExistingProject:(UIButton*)sender {
	ProjectsTableViewController* ptvc = [[[ProjectsTableViewController alloc] initInManagedObjectContext:self.managedObjectContext] autorelease];
	ptvc.delegate = self;
	ptvc.title = @"Load an existing project";
	[self.navigationController pushViewController:ptvc animated:YES];
	
}

- (void)openProject:(Project*) project
{
	NSLog(@"Opening a project...");
}

- (void)shouldCreateProject:(NSString*)name withWidth:(int)width height:(int)height andTexture:(NSData*)tex
{
	Project* proj = [Project projectWithName:name width:width height:height texture:tex inManagedObjectContext:[self managedObjectContext]];
	[self openProject:proj];
}

- (void)handleCancel
{
	NSLog(@"just pop the view off here");
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
