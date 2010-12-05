//
//  PreviewViewController.m
//  Preview
//
//  Thanks to the UMBC CS course CMSC 491 lecture 19 slides
//  for explaining some OpenGL stuff and for doing the frutsam
//  math.
//

#define TURNSPEEDX 0.07
#define TURNSPEEDY 0.04
#define MOVESPEED 0.03
#define ZOOMSPEED 0.5

#import <QuartzCore/QuartzCore.h>

#import "PreviewViewController.h"
#import "EAGLView.h"
#import "gluLookAt.h"

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface PreviewViewController ()
@property (nonatomic, retain) EAGLContext *context;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation PreviewViewController

@synthesize animating, context;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithProject:(Project *)proj {
 if ((self = [super initWithNibName:@"PreviewViewController" bundle:nil])) {
	 project = proj;
 }
 return self;
 }
 


- (void)viewDidLoad
{
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
    
    animating = FALSE;
    displayLinkSupported = FALSE;
    animationFrameInterval = 1;
    displayLink = nil;
    animationTimer = nil;
	
	hasRun = NO;
	
	posX = 0;
	posY = 0;
	theta = -45.f;
	phi = 0.f;
	heightAboveGround = 6.f;
	
	UIGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
	[self.view addGestureRecognizer:pangr];
	[pangr release];
	UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	tapgr.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:tapgr];
	[tapgr release];
	UIGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
	[self.view addGestureRecognizer:pinchgr];
	[pinchgr release];
	
	
	// set to be the number of shapes
	textures = malloc(2 * sizeof(GLuint));
	
	// store our shapes in a constant-order array
	// this is because we need to bind textures to the shapes
	// and want to only load the textures into graphical
	// memory once, as doing so is a costly operation
	int numShapes = [project.shapes count];
	shapes = malloc(numShapes * sizeof(Shape *));
	int cur = 0;
	for(Shape *shp in project.shapes) {
		shapes[cur] = shp;
		cur++;
	}
	shapeCount = cur;
    
    // Use of CADisplayLink requires iOS version 3.1 or greater.
	// The NSTimer object is used as fallback when it isn't available.
    NSString *reqSysVer = @"3.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        displayLinkSupported = TRUE;
}

- (void)dealloc
{
    if (program)
    {
		free(textures);
        glDeleteProgram(program);
        program = 0;
    }
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    if (program)
    {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            /*
			 CADisplayLink is API new in iOS 3.1. Compiling against earlier versions will result in a warning, but can be dismissed if the system version runtime check for CADisplayLink exists in -awakeFromNib. The runtime check ensures this code will not be called in system versions earlier than 3.1.
            */
            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawFrame)];
            [displayLink setFrameInterval:animationFrameInterval];
            
            // The run loop will retain the display link on add.
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawFrame) userInfo:nil repeats:TRUE];
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }
        
        animating = FALSE;
    }
}


float d_sin(float degrees) {
	return sin(3.1415926535f * (degrees / 180.0f));
}

float d_cos(float degrees) {
	return cos(3.1415926535f * (degrees / 180.0f));
}

float d_atan(float tanval) {
	return (atan(tanval)/3.1415926535) * 180.0f;
}


- (void)pan:(UIPanGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		double xVal = (double)[gesture translationInView:self.view].x;
		double yVal = (double)[gesture translationInView:self.view].y;
		if([gesture numberOfTouches] == 1) {
			NSLog(@"Translation by (%f, %f)", xVal, yVal);
			theta += xVal * TURNSPEEDX;
			phi += yVal * TURNSPEEDX;
			if(theta > 360) theta -= 360;
			if(theta < 0) theta += 360;
			if(phi < -60) phi = -60;
			if(phi > 60) phi = 60;
		} else if([gesture numberOfTouches] == 2) {
			posX += d_cos(theta) * d_cos(phi) * yVal * MOVESPEED * heightAboveGround;
			posY -= d_sin(theta) * d_cos(phi) * yVal * MOVESPEED * heightAboveGround;
			posX += d_cos(theta + 90.f) * d_cos(phi) * xVal * MOVESPEED * heightAboveGround;
			posY -= d_sin(theta + 90.f) * d_cos(phi) * xVal * MOVESPEED * heightAboveGround;
		}
		CGPoint p;
		p.x = 0; p.y= 0;
		[gesture setTranslation:p inView:self.view];
	}
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		NSLog(@"double tap");
	}
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		heightAboveGround /= gesture.scale;
		if(heightAboveGround < 2) heightAboveGround = 2;
		gesture.scale = 1;
	}
}

- (void)drawQuad:(GLfloat*)vertices red:(float)r green:(float)g blue:(float)b
{
	glColor4f(r, g, b, 1.0);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

- (void)drawQuad:(GLfloat*)vertices red:(float)r green:(float)g blue:(float)b withTexture:(UIImage*)tex
{
	
}

- (void)loadFloorTexture {
	if([project.hasTexture boolValue]) {
		CGImageRef textureImage = [UIImage imageWithData:project.floorTexture].CGImage;
		if (textureImage == nil) {
			NSLog(@"Failed to load texture image");
			return;
		}
		GLubyte *textureData = (GLubyte *)malloc(256 * 256 * 4);
		CGContextRef textureContext = CGBitmapContextCreate(
										   textureData,
										   256,
										   256,
										   8, 256 * 4,
										   CGImageGetColorSpace(textureImage),
										   kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(textureContext,
                       CGRectMake(0.0, 0.0, (float)256, (float)256),
                       textureImage);
		CGContextRelease(textureContext);
		glGenTextures(1, &floorTexture[0]);
		glBindTexture(GL_TEXTURE_2D, floorTexture[0]);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
		free(textureData);
	}
}

- (void)loadShapeTexture:(int)index
{
	if([shapes[index].hasTexture boolValue]) {
		CGImageRef textureImage = [UIImage imageWithData:shapes[index].texture].CGImage;
//	[UIImage imageNamed:@"checkerplate.png"].CGImage;
		if (textureImage == nil) {
			NSLog(@"Failed to load texture image");
			return;
		}
		GLubyte *textureData = (GLubyte *)malloc(256 * 256 * 4);
		CGContextRef textureContext = CGBitmapContextCreate(
                                                        textureData,
                                                        256,
                                                        256,
                                                        8, 256 * 4,
                                                        CGImageGetColorSpace(textureImage),
                                                        kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(textureContext,
                       CGRectMake(0.0, 0.0, (float)256, (float)256),
                       textureImage);
		CGContextRelease(textureContext);
		glGenTextures(1, &textures[index]);
		glBindTexture(GL_TEXTURE_2D, textures[index]);
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
		free(textureData);
	}
}

- (void)loadTextures {
	[self loadFloorTexture];
	
	for(int i = 0; i < shapeCount; ++i) {
		[self loadShapeTexture:i];
	}
}

- (void)drawFloor {
	if([project.hasTexture boolValue]) {
		GLfloat floorVertices[12];
		
		floorVertices[0] = 0.0; floorVertices[1] = 0.0; floorVertices[2] = 0.0;
		floorVertices[3] = 0.0; floorVertices[4] = 0.0; floorVertices[5] = [project.height doubleValue];
		floorVertices[6] = [project.width doubleValue]; floorVertices[7] = 0.0; floorVertices[8] = [project.height doubleValue];
		floorVertices[9] = [project.width doubleValue]; floorVertices[10] = 0.0; floorVertices[11] = 0.0;
		
		
		glBindTexture(GL_TEXTURE_2D, floorTexture[0]);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glEnable(GL_TEXTURE_2D);
		glTexCoordPointer(2, GL_SHORT, 0, squareTextureCoords);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		[self drawQuad:floorVertices red:1.0 green:1.0 blue:1.0];
	
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	}
}

- (void)createVertices:(GLfloat *)vertices forShape:(Shape*)shape {
	float tlx = [shape.tlx doubleValue];
	float tly = [shape.tly doubleValue];
	float tlz = [shape.tlz doubleValue];
	float brx = [shape.brx doubleValue];
	float bry = [shape.bry doubleValue];
	float brz = [shape.brz doubleValue];
	
	if([shape.type intValue] == SHAPETYPELEVEL) {
		vertices[0] = tlx; vertices[1] = tlz; vertices[2] = tly;
		vertices[3] = tlx; vertices[4] = tlz; vertices[5] = bry;
		vertices[6] = brx; vertices[7] = tlz; vertices[8] = bry;
		vertices[9] = brx; vertices[10] = tlz; vertices[11] = tly;
	} else if ([shape.type intValue] == SHAPETYPEWALL) {
		vertices[0] = tlx; vertices[1] = tlz; vertices[2] = tly;
		vertices[3] = tlx; vertices[4] = brz; vertices[5] = tly;
		vertices[6] = brx; vertices[7] = brz; vertices[8] = bry;
		vertices[9] = brx; vertices[10] = tlz; vertices[11] = bry;
	} else if ([shape.type intValue] == SHAPETYPEBILLBOARD) {
		float radius = sqrt((tlx - brx) * (tlx - brx) + (tly - bry) * (tly - bry))/2;
		float centerX = (tlx + brx)/2;
		float centerY = (tly + bry)/2;
		float psi = 0;
		if(centerX - 1 < posX && centerX + 1 > posX) psi = centerY > posY ? 90 : -90;
		else psi = d_atan((posY - centerY)/(centerX - posX));
		float leftX = centerX + radius * d_cos(psi + 90);
		float leftY = centerY - radius * d_sin(psi + 90);
		float rightX = centerX - radius * d_cos(psi + 90);
		float rightY = centerY + radius * d_sin(psi + 90);
		vertices[0] = leftX; vertices[1] = tlz; vertices[2] = leftY;
		vertices[3] = leftX; vertices[4] = brz; vertices[5] = leftY;
		vertices[6] = rightX; vertices[7] = brz; vertices[8] = rightY;
		vertices[9] = rightX; vertices[10] = tlz; vertices[11] = rightY;
	}
	
}

- (void)drawShape:(int)index {
	GLfloat vertices[12];
	[self createVertices:&vertices[0] forShape:shapes[index]];
	
	if([shapes[index].hasTexture boolValue]) {
		glBindTexture(GL_TEXTURE_2D, textures[index]);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glEnable(GL_TEXTURE_2D);
		glTexCoordPointer(2, GL_SHORT, 0, squareTextureCoords);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		[self drawQuad:vertices red:1.0 green:1.0 blue:1.0];
		
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	} else {
		
		int colornum = [shapes[index].color intValue];
		int red = (colornum & 0xFF000000) >> 24;
		int green = (colornum & 0x00FF0000) >> 16;
		int blue = (colornum & 0x0000FF00) >> 8;
		float r = 1.f/255 * red;
		float g = 1.f/255 * green;
		float b = 1.f/255 * blue;
		
		[self drawQuad:vertices red:r green:g blue:b];
	}
}

- (void)drawFrame
{
    [(EAGLView *)self.view setFramebuffer];
	
	glEnable(GL_DEPTH_TEST);
	
	// perform initialization
	if(!hasRun) {
		float wid = [project.width doubleValue];
		float ht = [project.height doubleValue];
		const GLfloat zNear = 0.1, zFar = wid < ht ? ht : wid, fieldOfView = 45.0;
		GLfloat size = zNear * tanf(3.1415926535 * fieldOfView / 360.0);
		
		glEnable(GL_DEPTH_TEST);
		glMatrixMode(GL_PROJECTION);
		
		CGRect rect = self.view.bounds;
		glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
		glViewport(0, 0, rect.size.width, rect.size.height);
		hasRun = YES;
		glMatrixMode(GL_MODELVIEW);
		
		[self loadTextures];
	}
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glLoadIdentity();
	
//	NSLog(@"gluLookAt(%f, %f, %f, %f, %f, %f, %f, %f, %f", posX, 6.0f, posY, posX + 100 * d_cos(theta) * d_cos(phi), 6.f + 100.0 * d_sin(phi), posY - 100 * sin(phi) * cos(phi), 0.f, 1.f, 0.f);
	
	gluLookAt(posX, heightAboveGround, posY, posX + 100 * d_cos(theta) * d_cos(phi), heightAboveGround + 100.0 * d_sin(phi), posY - 100 * d_sin(theta) * d_cos(phi), 0.f, 1.f, 0.f);

	[self drawFloor];
	
	for(int i = 0; i < shapeCount; ++i) {
		[self drawShape:i];
	}

	glDisableClientState(GL_VERTEX_ARRAY);
    
    [(EAGLView *)self.view presentFramebuffer];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

@end
