//
//  ButtonContainer.m
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/30/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#import "ButtonContainer.h"


@implementation ButtonContainer



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began");
	if ( [self isAnyTouches:touches insideButton:left] ) {
		left.highlighted			= YES;
		[left sendAction:@selector(leftPressed:) to:controller forEvent:event];
	} else if ( [self isAnyTouches:touches insideButton:right] ) {
		right.highlighted			= YES;
		[right sendAction:@selector(rightPressed:) to:controller forEvent:event];
	} 
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	
	// Figure out if any of the keys are released first
	if (![self isAnyTouches:touches insideButton:left] && 
		[self wasAnyTouches:touches insideButton:left] )  {
		left.highlighted			= NO;
		[left sendAction:@selector(leftReleased:) to:controller forEvent:event];
	}
	if (![self isAnyTouches:touches insideButton:right] && 
		[self wasAnyTouches:touches insideButton:right] )  {
		right.highlighted			= NO;
		[right sendAction:@selector(rightReleased:) to:controller forEvent:event];
	}
	
	
	// Now, figure out if any of the keys are pressed
	if ( [self isAnyTouches:touches insideButton:left]  && 
		![self wasAnyTouches:touches insideButton:left] ) {
		left.highlighted			= YES;
		[left sendAction:@selector(leftPressed:) to:controller forEvent:event];
	} 
	if ( [self isAnyTouches:touches insideButton:right] && 
		![self wasAnyTouches:touches insideButton:right] ) {
		right.highlighted			= YES;
		[right sendAction:@selector(rightPressed:) to:controller forEvent:event];
	} 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	if ( [self isAnyTouches:touches insideButton:left] ) {
		left.highlighted  = NO;
		[left sendAction:@selector(leftReleased:) to:controller forEvent:event];
	} else if ( [self isAnyTouches:touches insideButton:right] ) {
		right.highlighted = NO;
		[right sendAction:@selector(rightReleased:) to:controller forEvent:event];
	}
}

- (BOOL)isAnyTouches:(NSSet *)touches insideButton:(UIButton *)button {
	
	BOOL inside = NO;
	for (UITouch *touch in touches) {
		
		float x			= [touch locationInView:button].x;
		float y			= [touch locationInView:button].y;
		
		if (!(x > button.bounds.origin.x + button.bounds.size.width) &&
			!(x < button.bounds.origin.x) && 
			!(y > button.bounds.origin.y + button.bounds.size.height) &&
			!(y < self.bounds.origin.y)) {
			inside = YES;
		}
	}
	return inside;
}

- (BOOL)wasAnyTouches:(NSSet *)touches insideButton:(UIButton *)button {
	
	BOOL inside = NO;
	for (UITouch *touch in touches) {
		
		float x			= [touch previousLocationInView:button].x;
		float y			= [touch previousLocationInView:button].y;
		
		if (!(x > button.bounds.origin.x + button.bounds.size.width) &&
			!(x < button.bounds.origin.x) && 
			!(y > button.bounds.origin.y + button.bounds.size.height) &&
			!(y < self.bounds.origin.y)) {
			inside = YES;
		}
	}
	return inside;
}



@end
