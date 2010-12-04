//
//  EditorView.m
//  MobileDesigner
//

#import "EditorView.h"
#import "Project.h"


@implementation EditorView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		left = 100;
		right = 700;
		top = 100;
		bottom = 400;
        // Initialization code
    }
    return self;
}
	

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		left = 100;
		right = 700;
		top = 100;
		bottom = 400;
        // Initialization code
    }
    return self;
}


- (void)update
{
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	if([[[delegate project] hasTexture] boolValue]) {
		Project *proj = [delegate project];
		
		// draw the floor texture very light
		CGContextSetAlpha(context, 0.3f);
		UIImage * img = [UIImage imageWithData:proj.floorTexture];
		CGContextTranslateCTM(context, 0, rect.size.height + [delegate offsetHeight]);
		double wfactor = [proj.width doubleValue]/(right - left);
		double hfactor = [proj.height doubleValue]/(bottom - top);
		CGContextScaleCTM(context, wfactor, -hfactor);
		CGContextTranslateCTM(context, -left, -top);
		CGContextDrawImage(context, rect, [img CGImage]);
		
		// draw shape textures a bit heavier
		CGContextSetAlpha(context, 0.5f);
		// TODO: SHAPES
	}
	
	
//	CGContextStrokePath(context);
	
	UIGraphicsPopContext();

}


- (void)dealloc {
    [super dealloc];
}


@end
