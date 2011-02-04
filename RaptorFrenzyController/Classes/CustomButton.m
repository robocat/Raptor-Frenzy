//
//  CustomButton.m
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/30/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#import "CustomButton.h"


@implementation CustomButton


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began");
	[self setHighlighted:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	UITouch *touch	= [[touches objectEnumerator] nextObject];
	float x			= [touch locationInView:self].x;
	float y			= [touch locationInView:self].y;
		
	if ( x > self.bounds.origin.x + self.bounds.size.width ) {
		// Touch is right of button
		NSLog(@"Right of view");
		[self setHighlighted:NO];
	} else if ( x < self.bounds.origin.x ) {
		// Touch is left of button
		NSLog(@"Left of view");
		[self setHighlighted:NO];
	} else if ( y > self.bounds.origin.y + self.bounds.size.height) {
		// Touch is below button
		NSLog(@"Below view");
		[self setHighlighted:NO];
	} else if ( y < self.bounds.origin.y ) {
		// Touch is over the button
		NSLog(@"Over view");
		[self setHighlighted:NO];
	} else {
		// Touch is not over, under, to the left or right so it must be on it.
		[self setHighlighted:YES];
	}

	
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Ended");
	[self setHighlighted:NO];
}

@end
