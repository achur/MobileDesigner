    //
//  ShapeInspectorViewController.m
//  MobileDesigner
//

#import "ShapeInspectorViewController.h"
#import "MobileDesignerUtilities.h"
#import "OnlineTextureSelectorViewController.h"


@implementation ShapeInspectorViewController

@synthesize redSlider;
@synthesize greenSlider;
@synthesize blueSlider;
@synthesize textureSelectedLabel;
@synthesize removeTextureButton;
@synthesize shape;
@synthesize delegate;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil shape:(Shape*)shp{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.shape = shp;
    }
    return self;
}


- (IBAction)selectTexturePressed:(UIButton*)sender
{
	OnlineTextureSelectorViewController *otsvc = [[OnlineTextureSelectorViewController alloc] initWithDelegate:self];
	[self.navigationController pushViewController:otsvc animated:YES];
}

- (void)imageSelected:(UIImage *)img
{
	self.shape.hasTexture = [NSNumber numberWithBool:YES];
	self.shape.texture = UIImagePNGRepresentation(img);
	[self.textureSelectedLabel setHidden:NO];
	[self.removeTextureButton setHidden:NO];
}

- (IBAction)removeTexturePressed:(UIButton*)sender
{
	self.shape.hasTexture = [NSNumber numberWithBool:NO];
	self.shape.texture = nil;
	[self.textureSelectedLabel setHidden:YES];
	[self.removeTextureButton setHidden:YES];
}

- (IBAction)deleteShapePressed:(UIButton*)sender
{
	[self.delegate doneEditing:YES];
	[self.navigationController popViewControllerAnimated:YES];
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	int colornum = [shape.color intValue];
	int red = (colornum & 0xFF000000) >> 24;
	int green = (colornum & 0x00FF0000) >> 16;
	int blue = (colornum & 0x0000FF00) >> 8;
	float r = 1.f/255 * red;
	float g = 1.f/255 * green;
	float b = 1.f/255 * blue;
	self.redSlider.value = r;
	self.greenSlider.value = g;
	self.blueSlider.value = b;
	if([self.shape.hasTexture boolValue]) {
		[self.textureSelectedLabel setHidden:NO];
		[self.removeTextureButton setHidden:NO];
	} else {
		[self.textureSelectedLabel setHidden:YES];
		[self.removeTextureButton setHidden:YES];
	}
}


- (void)viewWillDisappear:(BOOL)animated
{
	int red = (int)(redSlider.value * 255);
	int green = (int)(greenSlider.value * 255);
	int blue = (int)(blueSlider.value * 255);
	if(red < 0) red = 0;
	if(green < 0) green = 0;
	if(blue < 0) blue = 0;
	if(red > 255) red = 255;
	if(green > 255) green = 255;
	if(blue > 255) blue = 255;
	int color = [MobileDesignerUtilities intFromR:red G:green B:blue];
	self.shape.color = [NSNumber numberWithInt:color];
	[delegate doneEditing:NO];
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
