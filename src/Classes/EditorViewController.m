//
//  EditorViewController.m
//  MobileDesigner
//

#import "EditorViewController.h"


@implementation EditorViewController

@synthesize iPad;
@synthesize editorView;
@synthesize managedObjectContext;
@synthesize project;

- (BOOL)iPad
{
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (id)initWithProject:(Project*)proj inManagedObjectContext:(NSManagedObjectContext*)ctx {
	NSString* nibname = @"";
	if(self.iPad) nibname = @"EditorViewController-iPad";
	else nibname = @"EditorViewController";
	if ((self == [super initWithNibName:nibname bundle:nil])) {
		self.managedObjectContext = ctx;
		self.project = proj;	
		self.title = [@"Edit " stringByAppendingString:project.name];

	}
	return self;
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


- (void)modelChanged
{
	NSLog(@"Model changed!");
}

- (void)shapeSelected:(Shape *)shape
{
	NSLog(@"Shape selected!");
}

- (IBAction)addNewShape:(UIButton*)sender
{
	NSLog(@"Add new shape");
}

- (IBAction)takeSnapshot:(UIButton*)sender
{
	NSLog(@"Take snapshot");
}
- (IBAction)inspectShape:(UIButton*)sender
{
	NSLog(@"Inspect shape");
}

- (int)offsetHeight
{
	return self.navigationController.navigationBar.bounds.size.height;
}

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
