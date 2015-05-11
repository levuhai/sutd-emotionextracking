//
//  RatingView.m
//  EmotionTracking
//
//  Created by Hai Le on 5/11/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "RatingView.h"
#import "BaseView.h"

@interface RatingView ()

@end

@implementation RatingView

- (void) viewWillMoveToWindow:(NSWindow *)newWindow {
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:self.bounds
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
    
    // NSTimer
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                              target:self
                                            selector:@selector(updateProgess)
                                            userInfo:nil
                                             repeats:YES];
    
    self.wantsLayer = NO;
}

- (void)viewDidMoveToSuperview {
    [self moveMouse];
}

- (void)updateProgess {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSLog(@"draw");
    // Fill in background Color
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 1,1,1,1);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
    // Get the graphics context that we are currently executing under
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    // Save the current graphics context settings
    [gc saveGraphicsState];
    
    // Set the color in the current graphics context for future draw operations
    [[NSColor blackColor] setStroke];
    
    CGFloat height = dirtyRect.size.height;
    CGFloat width = dirtyRect.size.width;
    NSLog(@"%f %f",height,width);
    
    //Draw Circle
    //    CGFloat radius = height < width ? height-40 : width-40;
    //    NSRect rect = NSMakeRect((width-radius)/2, (height-radius)/2, radius, radius);
    //    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    //    [circlePath appendBezierPathWithOvalInRect: rect];
    //
    //    // Outline and fill the path
    //    [circlePath stroke];
    int rectH = _dummyView.frame.size.height;
    _trackingRect = _dummyView.frame;
    // Draw Axises
    // X-Axis
    [[NSColor colorWithRed:41/255.0 green:128/255.0 blue:185/255.0 alpha:1] setStroke];
    NSBezierPath* xAxis = [NSBezierPath bezierPath];
    xAxis.lineWidth = 3;
    NSPoint p1 = NSMakePoint(width/2,_trackingRect.origin.y);
    NSPoint p2 = NSMakePoint(width/2,_trackingRect.origin.y+rectH);
    [xAxis moveToPoint: p1];
    [xAxis lineToPoint:p2];
    [xAxis stroke];
    
    // Y-Axis
    NSBezierPath* yAxis = [NSBezierPath bezierPath];
    yAxis.lineWidth = 3;
    NSPoint yp1 = NSMakePoint(_trackingRect.origin.x, height/2);
    NSPoint yp2 = NSMakePoint(_trackingRect.origin.x+rectH, height/2);
    [yAxis moveToPoint: yp1];
    [yAxis lineToPoint:yp2];
    [yAxis stroke];
    
    
    
    // Draw Progess
//    [[NSColor colorWithRed:39.0/255.0 green:174/255.0 blue:96/255.0 alpha:1] setStroke];
//    NSBezierPath* progressPath = [NSBezierPath bezierPath];
//    progressPath.lineWidth = 5;
//    [progressPath moveToPoint:NSMakePoint(0,height)];
//    [progressPath lineToPoint:NSMakePoint(self.progress*width,height)];
//    [progressPath stroke];
    
    //Draw pointer
    NSBezierPath* pointerPath = [NSBezierPath bezierPath];
    [pointerPath appendBezierPathWithOvalInRect: CGRectMake(_pointer.x-5, _pointer.y-5, 10, 10)];
    [[NSColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1] setFill];
    [pointerPath fill];
    
    NSGradient* aGradient = [[NSGradient alloc]
                             initWithStartingColor:[NSColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:0.5]
                             endingColor:[NSColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1]];
    
    NSPoint centerPoint = NSMakePoint(_pointer.x, _pointer.y);
    NSPoint otherPoint = NSMakePoint(centerPoint.x, centerPoint.y);
    CGFloat firstRadius = 12;
    [aGradient drawFromCenter:centerPoint
                       radius:firstRadius
                     toCenter:otherPoint
                       radius:0.0
                      options:0];
    
    // Draw text
    NSMutableDictionary *drawStringAttributes = [[NSMutableDictionary alloc] init];
    [drawStringAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    [drawStringAttributes setValue:[NSFont fontWithName:@"American Typewriter" size:18] forKey:NSFontAttributeName];
    //	NSShadow *stringShadow = [[NSShadow alloc] init];
    //	[stringShadow setShadowColor:[NSColor blackColor]];
    //	NSSize shadowSize;
    //	shadowSize.width = 1;
    //	shadowSize.height = -1;
    //	[stringShadow setShadowOffset:shadowSize];
    //	[stringShadow setShadowBlurRadius:3];
    //	[drawStringAttributes setValue:stringShadow forKey:NSShadowAttributeName];
    
    NSString *text = @"Calm";
    NSSize stringSize = [text sizeWithAttributes:drawStringAttributes];
    NSPoint textCP;
    textCP.x = (width - stringSize.width)/2;
    textCP.y = _trackingRect.origin.y-stringSize.height;
    [text drawAtPoint:textCP withAttributes:drawStringAttributes];
    
    text = @"Excited";
    stringSize = [text sizeWithAttributes:drawStringAttributes];
    textCP.x = (width-stringSize.width)/2;
    textCP.y = _trackingRect.origin.y+_trackingRect.size.height;
    [text drawAtPoint:textCP withAttributes:drawStringAttributes];
    
    text = @"Negative";
    stringSize = [text sizeWithAttributes:drawStringAttributes];
    textCP.x = _trackingRect.origin.x - (stringSize.width/2) - 20;
    textCP.y = (height/2) - (stringSize.height/2) - 10;
    [text drawAtPoint:textCP withAttributes:drawStringAttributes];
    
    text = @"Positive";
    stringSize = [text sizeWithAttributes:drawStringAttributes];
    textCP.x = _trackingRect.origin.x + _trackingRect.size.width - (stringSize.width/2) + 20;
    textCP.y = (height/2) - (stringSize.height/2) - 10;
    [text drawAtPoint:textCP withAttributes:drawStringAttributes];
    
    //[aGradient drawInBezierPath:pointerPath angle:0.0];
    
    // Restore the context to what it was before we messed with it
    [gc restoreGraphicsState];
}

#pragma mark - Mouse event

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint tvarMousePointInWindow = [theEvent locationInWindow];
    
    _pointer   = [self convertPoint:tvarMousePointInWindow toView:nil];
    
    if (_pointer.x < _dummyView.frame.origin.x) {
        _pointer.x = _dummyView.frame.origin.x;
    }
    if (_pointer.x > _dummyView.frame.origin.x+_dummyView.frame.size.width) {
        _pointer.x = _dummyView.frame.origin.x+_dummyView.frame.size.width;
    }
    if (_pointer.y < _dummyView.frame.origin.y) {
        _pointer.y = _dummyView.frame.origin.y;
    }
    if (_pointer.y > _dummyView.frame.origin.y+_dummyView.frame.size.height) {
        _pointer.y = _dummyView.frame.origin.y+_dummyView.frame.size.height;
    }
    
    NSPoint tempPoint = [self convertPoint:tvarMousePointInWindow toView:self.dummyView];
    [self setNeedsDisplay:YES];
    float dummyH = (self.dummyView.frame.size.height)/2;
    float xP = (tempPoint.x-dummyH)/dummyH;
    xP = fminf(1.0, xP);
    xP = fmaxf(-1.0, xP);
    float yP = (tempPoint.y-dummyH)/dummyH;
    yP = fminf(1.0, yP);
    yP = fmaxf(-1.0, yP);
    NSLog(@"%f %f",xP,yP);
    
    //[[DataManager sharedInstance] appendDataX:xP Y:yP description:@""];
    [_parentVC appendDataX:xP Y:yP];
}

- (void)moveMouse {
    // Move to 250x250
    CGEventRef move2 = CGEventCreateMouseEvent(
                                               NULL, kCGEventMouseMoved,
                                               CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2),
                                               kCGMouseButtonLeft // ignored
                                               );
    _pointer.x = self.bounds.size.width/2;
    _pointer.y = self.bounds.size.height/2;
    CGEventPost(kCGHIDEventTap, move2);
}

#pragma mark - Private

- (void)updateTrackingAreas {
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow | NSTrackingMouseMoved);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:self.bounds
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

@end
