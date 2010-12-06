//
//  EditorViewController.m
//  MobileDesigner
//

#import "EditorViewController.h"
#import "MobileDesignerUtilities.h"
#import "ShapeInspectorBillboardViewController.h"
#import "ShapeInspectorLevelViewController.h"
#import "ShapeInspectorWallViewController.h"

@implementation EditorViewController

@synthesize iPad;
@synthesize editorView;
@synthesize managedObjectContext;
@synthesize project;
@synthesize selectedShape;
@synthesize inspectButton;

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
		self.title = [@"2-D Edit: " stringByAppendingString:project.name];
		selectedShape = nil;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(!selectedShape){
		self.inspectButton.enabled = NO;
	}
}

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
	self.selectedShape = shape;
	[self.editorView update];
}

- (IBAction)addNewShape:(UIButton*)sender
{
	AddShapeViewController* asvc = [[AddShapeViewController alloc] initWithStyle:UITableViewStyleGrouped];
	asvc.title = @"Add A Shape";
	asvc.delegate = self;
	[self.navigationController pushViewController:asvc animated:YES];
}

- (void)addShape:(int)type
{
	double centerX = (editorView.left + editorView.right)/2;
	double centerY = (editorView.top + editorView.bottom)/2;
	double width = editorView.right - editorView.left;
	width /= 6;
	int r = 0;
	int g = 0;
	int b = 0;
	if(type == SHAPETYPELEVEL) g = 155;
	if(type == SHAPETYPEWALL) r = 155;
	if(type == SHAPETYPEBILLBOARD) b = 155;
	int color = [MobileDesignerUtilities intFromR:r G:g B:b];
	double rz = (type == SHAPETYPELEVEL) ? 0 : 10;
	[self.project addShapeWithColor:color tlx:(centerX - width) tly:(centerY - width) tlz:0 
								brx:(centerX + width) bry:(centerY + width) brz:rz 
							   type:type inManagedObjectContext:self.managedObjectContext];
	[self.editorView update];
}

- (IBAction)takeSnapshot:(UIButton*)sender
{
	int padding = [[UIScreen mainScreen] applicationFrame].size.height - [self.editorView bounds].size.height;
	if([self iPad]) padding += 44;
	else padding += 24;
	NSData *img = [MobileDesignerUtilities screencaptureData:self.editorView withPadding:padding];
	[self.project addSlideWithImage:img inManagedObjectContext:self.managedObjectContext];
}


- (IBAction)inspectShape:(UIButton*)sender
{
	if(self.selectedShape != nil) {
		if([self.selectedShape.type intValue] == SHAPETYPELEVEL) {
			ShapeInspectorLevelViewController* silvc;
			silvc = [[ShapeInspectorLevelViewController alloc] initWithShape:self.selectedShape];
			silvc.title = @"Inspector";
			silvc.delegate = self;
			[self.navigationController pushViewController:silvc animated:YES];
		} else if ([self.selectedShape.type intValue] == SHAPETYPEWALL) {
			ShapeInspectorWallViewController* siwvc;
			siwvc = [[ShapeInspectorWallViewController alloc] initWithShape:self.selectedShape];
			siwvc.title = @"Inspector";
			siwvc.delegate = self;
			[self.navigationController pushViewController:siwvc animated:YES];	
		} else if ([self.selectedShape.type intValue] == SHAPETYPEBILLBOARD) {
			ShapeInspectorBillboardViewController* sibvc;
			sibvc = [[ShapeInspectorBillboardViewController alloc] initWithShape:self.selectedShape];
			sibvc.title = @"Inspector";
			sibvc.delegate = self;
			[self.navigationController pushViewController:sibvc animated:YES];
		}
	}
}

- (void)doneEditing:(BOOL)deleteShape
{
	if(deleteShape) {
		[self.project removeShapesObject:self.selectedShape];
		Shape *toDelete = self.selectedShape;
		self.selectedShape = nil;
		[self.managedObjectContext deleteObject:toDelete];
	}
	[self.editorView update];
}

- (void)setSelectedShape:(Shape *)shp
{
	[selectedShape release];
	selectedShape = shp;
	[selectedShape retain];
	if(shp) {
		self.inspectButton.enabled = YES;
	} else {
		self.inspectButton.enabled = NO;
	}
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
