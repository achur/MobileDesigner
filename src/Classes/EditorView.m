//
//  EditorView.m
//  MobileDesigner
//

#import "EditorView.h"
#import "Project.h"


@implementation EditorView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
		UIGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
		[self addGestureRecognizer:pinchgr];
		[pinchgr release];
		UIGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
		[self addGestureRecognizer:pangr];
		[pangr release];
		UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		tapgr.numberOfTapsRequired = 1;
		[self addGestureRecognizer:tapgr];
		[tapgr release];
		hasDrawn = NO;
    }
    return self;
}
	

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		UIGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
		[self addGestureRecognizer:pinchgr];
		[pinchgr release];
		UIGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
		[self addGestureRecognizer:pangr];
		[pangr release];
		UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		tapgr.numberOfTapsRequired = 1;
		[self addGestureRecognizer:tapgr];
		[tapgr release];
		hasDrawn = NO;
    }
    return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		if(gesture.scale > 0) {
			NSLog(@"Handle pinch by scale %f", gesture.scale);
			double diffwidth = (1 - gesture.scale) * (right - left) / 2;
			double diffheight = (1 - gesture.scale) * (bottom - top) / 2;
			left -= diffwidth;
			right += diffwidth;
			top -= diffheight;
			bottom += diffheight;
			if((gesture.scale < 1 && ((right - left) > [[delegate project].width doubleValue]) && ((bottom - top) > [[delegate project].height doubleValue]))
			   || (right - left) < 50 || (bottom - top) < 50) {
				left += diffwidth;
				right -= diffwidth;
				top += diffheight;
				bottom -= diffheight;
			} else {
				if(right > [[delegate project].width doubleValue]) {
					double offset = right - [[delegate project].width doubleValue];
					right -= offset;
					left -= offset;
				}
				if(left < 0) {
					right -= left;
					left = 0;
				}
				if(bottom > [[delegate project].height doubleValue]) {
					double offset = bottom - [[delegate project].height doubleValue];
					bottom -= offset;
					top -= offset;
				}
				if(top < 0) {
					bottom -= top;
					top = 0;
				}
				[self setNeedsDisplay];
			}
			NSLog(@"left is now %f, right is now %f, top is now %f, bottom is now %f", left, right, top, bottom);
		}
		gesture.scale = 1;
	}
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		if([gesture numberOfTouches] == 2) {
			double xVal = (double)[gesture translationInView:self].x *(right-left)/self.bounds.size.width;
			double yVal = (double)[gesture translationInView:self].y *(bottom-top)/self.bounds.size.height;
		
			NSLog(@"Handle translation");
		
			BOOL modified = NO;
			if(left-xVal > 0 && right - xVal < [[delegate project].width doubleValue]){ 
				left -= xVal;
				right -= xVal;
				modified = YES;
			}
			if(top-xVal > 0 && bottom - xVal < [[delegate project].height doubleValue]){ 
				top -= yVal;
				bottom -= yVal;
				modified = YES;
			}
		
			CGPoint p;
			p.x = 0; p.y= 0;
			[gesture setTranslation:p inView:self];
			if(modified) [self setNeedsDisplay];
		}
	}
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		NSLog(@"Handle tap");
		[self setNeedsDisplay];
	}
}


- (void)update
{
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// if we haven't yet drawn we set the size of the viewport
	if(!hasDrawn) {
		if([[delegate project].width doubleValue]/self.frame.size.width < [[delegate project].height doubleValue]/self.frame.size.height) {
			left = 0;
			right = [[delegate project].width doubleValue];
			top = 0;
			double factor = self.frame.size.height/self.frame.size.width;
			bottom = right * factor;
		} else {
			top = 0;
			bottom = [[delegate project].height doubleValue];
			left = 0;
			double factor = self.frame.size.width/self.frame.size.height;
			right = factor * bottom;
		}		
		NSLog(@"left is now %f, right is now %f, top is now %f, bottom is now %f", left, right, top, bottom);

		hasDrawn = YES;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	if([[[delegate project] hasTexture] boolValue]) {
		Project *proj = [delegate project];
		
		// draw the floor texture very light
		CGContextSetAlpha(context, 0.3f);
		UIImage * img = [UIImage imageWithData:proj.floorTexture];

		CGRect r = CGRectMake(0, 0, [proj.width doubleValue], [proj.height doubleValue]);
		CGContextScaleCTM(context, rect.size.width/(right - left), -rect.size.height/(bottom - top));
		CGContextTranslateCTM(context, 0, -r.size.height);
		
		CGContextTranslateCTM(context, -left, top);
		
		CGContextDrawImage(context, r, [img CGImage]);
//		NSLog(@"%f, %f", wfactor, hfactor);
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
