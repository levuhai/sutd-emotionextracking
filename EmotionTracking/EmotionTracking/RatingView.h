//
//  RatingView.h
//  EmotionTracking
//
//  Created by Hai Le on 5/11/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@class BaseView;

@interface RatingView : NSView {
    NSTrackingArea *_trackingArea;
    NSRect _trackingRect;
    NSPoint _pointer;
    BOOL _needUpdateProgess;
    NSTimer *_timer;
}

@property (strong) IBOutlet NSView *dummyView;
@property (weak) BaseView *parentVC;
@property (nonatomic) float progress;

- (void)moveMouse;

@end
