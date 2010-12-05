//
//  EditorView.m
//  MobileDesigner
//

#import "EditorView.h"
#import "Project.h"
#import "Shape.h"
#import "MobileDesignerUtilities.h"

@implementation EditorView

@synthesize top;
@synthesize bottom;
@synthesize left;
@synthesize right;

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
		cachedFloorTexture = nil;
		selectedKnob = 0;
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
		cachedFloorTexture = nil;
		selectedKnob = 0;
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
	int knobSize = (int) 15.0 * (right - left) / self.bounds.size.width; // good estimate for about 15 pixel knob.
	CGPoint point = [gesture locationInView:self];
	double xWorldCoords = left + point.x * (right - left) / self.bounds.size.width;
	double yWorldCoords = top + point.y * (bottom - top) / self.bounds.size.height;
	if(gesture.state == UIGestureRecognizerStateBegan) {
		if([delegate selectedShape]) {
			Shape *cur = [delegate selectedShape];
			double tlx = [cur.tlx doubleValue];
			double tly = [cur.tly doubleValue];
			double brx = [cur.brx doubleValue];
			double bry = [cur.bry doubleValue];
			if([cur hitTextAtX:xWorldCoords Y:yWorldCoords]) {
				selectedKnob = 6;
			}
			switch([cur.type intValue]) {
				case SHAPETYPELEVEL:
					if((brx - knobSize < xWorldCoords && brx + knobSize > xWorldCoords) && (tly - knobSize < yWorldCoords && tly + knobSize > yWorldCoords)) {
						selectedKnob = 1;
					}
					if((tlx - knobSize < xWorldCoords && tlx + knobSize > xWorldCoords) && (bry - knobSize < yWorldCoords && bry + knobSize > yWorldCoords)) {
						selectedKnob = 2;
					}
				case SHAPETYPEWALL:
					if((tlx - knobSize < xWorldCoords && tlx + knobSize > xWorldCoords) && (tly - knobSize < yWorldCoords && tly + knobSize > yWorldCoords)) {
						selectedKnob = 3;
					}
					if((brx - knobSize < xWorldCoords && brx + knobSize > xWorldCoords) && (bry - knobSize < yWorldCoords && bry + knobSize > yWorldCoords)) {
						selectedKnob = 4;
					}
					break;
				case SHAPETYPEBILLBOARD:
					if((brx - knobSize < xWorldCoords && brx + knobSize > xWorldCoords) && ((tly + bry)/2 - knobSize < yWorldCoords && (tly + bry)/2 + knobSize > yWorldCoords)) {
						selectedKnob = 5;
					}
					break;
			}
		}
	}
	if(gesture.state == UIGestureRecognizerStateEnded) {
		selectedKnob = 0;
	}
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
		double xVal = (double)[gesture translationInView:self].x *(right-left)/self.bounds.size.width;
		double yVal = (double)[gesture translationInView:self].y *(bottom-top)/self.bounds.size.height;
		
		// Here we handle panning
		if([gesture numberOfTouches] == 2) {
		
			NSLog(@"Handle translation");
		
			BOOL modified = NO;
			double width = [[delegate project].width doubleValue];
			double height = [[delegate project].height doubleValue];
			if(left-xVal > 0 && right - xVal < width){ 
				left -= xVal;
				right -= xVal;
				modified = YES;
			}
			if(top-xVal > 0 && bottom - xVal < height){ 
				top -= yVal;
				bottom -= yVal;
				modified = YES;
			}
			if(right < width && right - xVal > width) {
				left += (width - right);
				right = width;
				modified = YES;
			}
			if(left > 0 && left-xVal < 0) {
				right -= left;
				left = 0;
				modified = YES;
			}
			if(bottom < width && bottom - xVal > width) {
				top += (width - bottom);
				bottom = width;
				modified = YES;
			}
			if(top > 0 && top-xVal < 0) {
				bottom -= top;
				top = 0;
				modified = YES;
			}
			if(modified) [self setNeedsDisplay];
			
		} else if([gesture numberOfTouches] == 1) {
			
			if([delegate selectedShape]) {
				Shape *cur = [delegate selectedShape];
				double tlx = [cur.tlx doubleValue];
				double tly = [cur.tly doubleValue];
				double brx = [cur.brx doubleValue];
				double bry = [cur.bry doubleValue];
				switch([cur.type intValue]) {
					case SHAPETYPELEVEL:
						if(selectedKnob == 1) {
							cur.brx = [NSNumber numberWithDouble:xWorldCoords];
							cur.tly = [NSNumber numberWithDouble:yWorldCoords];
						}
						if(selectedKnob == 2) {
							cur.tlx = [NSNumber numberWithDouble:xWorldCoords];
							cur.bry = [NSNumber numberWithDouble:yWorldCoords];
						}
					case SHAPETYPEWALL:
						if(selectedKnob == 3) {
							cur.tlx = [NSNumber numberWithDouble:xWorldCoords];
							cur.tly = [NSNumber numberWithDouble:yWorldCoords];
						}
						if(selectedKnob == 4) {
							cur.brx = [NSNumber numberWithDouble:xWorldCoords];
							cur.bry = [NSNumber numberWithDouble:yWorldCoords];
						}
						break;
					case SHAPETYPEBILLBOARD:
						if(selectedKnob == 5) {
							double raddiff = xWorldCoords - brx;
							cur.brx = [NSNumber numberWithDouble:(brx + raddiff)];
							cur.bry = [NSNumber numberWithDouble:(bry + raddiff)];
							cur.tlx = [NSNumber numberWithDouble:(tlx - raddiff)];
							cur.tly = [NSNumber numberWithDouble:(tly - raddiff)];
						}
						break;
				}
				if(selectedKnob == 6) {
					double xVal = (double)[gesture translationInView:self].x *(right-left)/self.bounds.size.width;
					double yVal = (double)[gesture translationInView:self].y *(bottom-top)/self.bounds.size.height;
					cur.brx = [NSNumber numberWithDouble:([cur.brx doubleValue] + xVal)];
					cur.bry = [NSNumber numberWithDouble:([cur.bry doubleValue] + yVal)];
					cur.tlx = [NSNumber numberWithDouble:([cur.tlx doubleValue] + xVal)];
					cur.tly = [NSNumber numberWithDouble:([cur.tly doubleValue] + yVal)];
				}
				[self setNeedsDisplay];
			}
		}
		CGPoint p;
		p.x = 0; p.y= 0;
		[gesture setTranslation:p inView:self];
	}
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
	if ((gesture.state == UIGestureRecognizerStateChanged) ||
		(gesture.state == UIGestureRecognizerStateEnded)) {
			CGPoint point = [gesture locationInView:self];
			Shape *selected = nil;
			double xWorldCoords = left + point.x * (right - left) / self.bounds.size.width;
			double yWorldCoords = top + point.y * (bottom - top) / self.bounds.size.height;
			NSLog(@"%f, %f", xWorldCoords, yWorldCoords);
			for(Shape *shape in [delegate project].shapes) {
				if([shape hitTextAtX:xWorldCoords Y:yWorldCoords]) {
					selected = shape;
					NSLog(@"Found Shape");
				}
			}
			NSLog(@"Tapped shape of type %@", selected);
			[delegate shapeSelected:selected];
	}
}


- (void)update
{
	[self setNeedsDisplay];
}

- (void)drawShape:(Shape*)shape inRect:(CGRect)rect inCGContext:(CGContextRef)context
{
	double tlx = ([shape.tlx doubleValue] - left)/(right - left) * rect.size.width;
	double tly = ([shape.tly doubleValue] - top)/(bottom - top) * rect.size.height;
	double brx = ([shape.brx doubleValue] - left)/(right - left) * rect.size.width;
	double bry = ([shape.bry doubleValue] - top)/(bottom - top) * rect.size.height;
	int type = [shape.type intValue];
	UIColor* color = [MobileDesignerUtilities colorFromInt:[shape.color intValue]];
	
	switch(type) {
		case SHAPETYPEWALL:
			CGContextBeginPath(context);
			CGContextSetLineWidth(context, 4);
			CGContextSetStrokeColorWithColor(context, color.CGColor);
			CGContextMoveToPoint(context, tlx, tly);
			CGContextAddLineToPoint(context, brx, bry);
			CGContextStrokePath(context);
			break;
			
		case SHAPETYPELEVEL:
			CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillRect(context, CGRectMake(tlx, tly, brx-tlx, bry-tly));
			break;
			
		case SHAPETYPEBILLBOARD:
			CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
			CGContextSetFillColorWithColor(context, color.CGColor);
			CGContextFillEllipseInRect(context, CGRectMake(tlx, tly, brx-tlx, bry-tly));
			break;
	}
}

- (void)drawSelectedShape:(Shape*)shape inRect:(CGRect)rect inCGContext:(CGContextRef)context
{
	[self drawShape:shape inRect:rect inCGContext:context];
	double tlx = ([shape.tlx doubleValue] - left)/(right - left) * rect.size.width;
	double tly = ([shape.tly doubleValue] - top)/(bottom - top) * rect.size.height;
	double brx = ([shape.brx doubleValue] - left)/(right - left) * rect.size.width;
	double bry = ([shape.bry doubleValue] - top)/(bottom - top) * rect.size.height;
	int type = [shape.type intValue];
	
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	switch(type) {
		case SHAPETYPEWALL:
			CGContextFillRect(context, CGRectMake(tlx - 7, tly - 7, 14, 14));
			CGContextFillRect(context, CGRectMake(brx - 7, bry - 7, 14, 14));
			break;
			
		case SHAPETYPELEVEL:
			CGContextFillRect(context, CGRectMake(tlx - 7, tly - 7, 14, 14));
			CGContextFillRect(context, CGRectMake(brx - 7, bry - 7, 14, 14));
			CGContextFillRect(context, CGRectMake(tlx - 7, bry - 7, 14, 14));
			CGContextFillRect(context, CGRectMake(brx - 7, tly - 7, 14, 14));
			break;
			
		case SHAPETYPEBILLBOARD:			
			CGContextFillRect(context, CGRectMake(brx, (tly + bry)/2 - 7, 14, 14));
			break;
	}
}

// First draws the floor texture, then draws the shapes
// in the project at a slightly higher opacity level
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
		hasDrawn = YES;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	// draw shape textures a bit heavier
	CGContextSetAlpha(context, 0.5f);
	for(Shape *curshape in [delegate project].shapes) {
		[self drawShape:curshape inRect:rect inCGContext:context];
	}
	
	// draw selected shape on top and with 1 alpha
	CGContextSetAlpha(context, 0.8f);
	if([delegate selectedShape]) {
		[self drawSelectedShape:[delegate selectedShape] inRect:rect inCGContext:context];
	}
	
	
	if([[[delegate project] hasTexture] boolValue]) {
		Project *proj = [delegate project];
		
		// draw the floor texture very light
		CGContextSetAlpha(context, 0.3f);
		if(!cachedFloorTexture) {
			cachedFloorTexture = [[UIImage imageWithData:proj.floorTexture] retain];
		}
		CGRect r = CGRectMake(0, 0, [proj.width doubleValue], [proj.height doubleValue]);
		CGContextScaleCTM(context, rect.size.width/(right - left), -rect.size.height/(bottom - top));
		CGContextTranslateCTM(context, 0, -r.size.height);
		CGContextTranslateCTM(context, -left, top);
		CGContextDrawImage(context, r, [cachedFloorTexture CGImage] );
	}
	
	UIGraphicsPopContext();
}


- (void)dealloc {
	[cachedFloorTexture release];
    [super dealloc];
}


@end
