//
//  ProjectMenuViewController.m
//  MobileDesigner
//

#import "ProjectMenuViewController.h"
#import "EditorViewController.h"


@implementation ProjectMenuViewController

@synthesize managedObjectContext;
@synthesize project;

- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (IBAction)editorView:(UIButton*)sender
{
	EditorViewController *evc = [[EditorViewController alloc] initWithProject:self.project inManagedObjectContext:self.managedObjectContext];
	[self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)previewView:(UIButton*)sender
{
	NSLog(@"Show a 3D preview");
}

- (IBAction)playlistView:(UIButton*)sender
{
	NSLog(@"Show the slideshow/playlist");
}

- (IBAction)deleteProject:(UIButton*)sender
{
	NSLog(@"Delete the project and pop off this view");
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

- (id)initWithProject:(Project*)proj inManagedObjectContext:(NSManagedObjectContext*)ctx {
	NSString* nibname = @"";
	if(self.iPad) nibname = @"ProjectMenu-iPad";
	else nibname = @"ProjectMenu";
	if ((self == [super initWithNibName:nibname bundle:nil])) {
		self.managedObjectContext = ctx;
		self.project = proj;
		self.title = proj.name;
	}
	return self;
}

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
