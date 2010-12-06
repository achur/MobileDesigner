//
//  PreviewViewController.h
//  Preview
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "Project.h"
#import "Shape.h"

@interface PreviewViewController : UIViewController
{
	
	float posX;
	float posY;
	float theta;
	float phi;
	float heightAboveGround;
	
    EAGLContext *context;
    GLuint program;
    
    BOOL animating;
    BOOL displayLinkSupported;
    NSInteger animationFrameInterval;
    /*
	 Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	 CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	 The NSTimer object is used only as fallback when running on a pre-3.1 device where CADisplayLink isn't available.
	 */
    id displayLink;
    NSTimer *animationTimer;
	
	BOOL hasRun;
	
	Project *project;
	
	GLuint floorTexture[1];
	GLuint *textures;
	Shape **shapes;
	int shapeCount;
	
	NSManagedObjectContext* managedObjectContext;
//	GLuint textures[2];
}

// top left
// bottom left
// bottom right
// top right
static const GLshort squareTextureCoords[] = {
	0, 0,		
	0, 1,		
	1, 1,		
	1, 0,		
};

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (id)initWithProject:(Project *)proj inManagedObjectContext:(NSManagedObjectContext*)contex;

- (void)startAnimation;
- (void)stopAnimation;

@end
