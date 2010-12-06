//
//  ProjectMenuViewController.m
//  MobileDesigner
//

#import "ProjectMenuViewController.h"
#import "EditorViewController.h"
#import "PreviewViewController.h"
#import "EAGLView.h"
#import "EditSlidesTableViewController.h"
#import "PresentationTableViewController.h"
#import "Project.h"
#import "Slide.h"

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
	PreviewViewController *pvc = [[PreviewViewController alloc] initWithProject:self.project inManagedObjectContext:self.managedObjectContext];
	[self.navigationController pushViewController:pvc animated:YES];
	[pvc startAnimation];
}

- (IBAction)playlistView:(UIButton*)sender
{
	PresentationTableViewController *ptvc = [[PresentationTableViewController alloc] initInManagedObjectContext:self.managedObjectContext forProject:self.project];
	[self.navigationController pushViewController:ptvc animated:YES];
}

- (IBAction)editSlidesView:(UIButton*)sender
{
	EditSlidesTableViewController *estvc = [[EditSlidesTableViewController alloc] initInManagedObjectContext:self.managedObjectContext forProject:self.project];
	[self.navigationController pushViewController:estvc animated:YES];
}

- (IBAction)deleteProject:(UIButton*)sender
{
	for(Slide *slide in self.project.slides) {
		[self.managedObjectContext deleteObject:slide];
	}
	for(Shape *shape in self.project.shapes) {
		[self.managedObjectContext deleteObject:shape];
	}
	[self.managedObjectContext deleteObject:project];
	
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
