//
//  Log.m
//  Raptor
//
//  Created by Martin Bjerregaard Nielsen on 1/8/11.
//  Copyright 2011 Identified Object. All rights reserved.
//

#import "Log.h"

@implementation Log
@synthesize textView, log;

- (id)init
{
    self = [super init];
    if (self) {
        self.log = [NSMutableString stringWithCapacity:1000];
    }
    
    return self;
}

-(void)logString:(NSString*)string {
	[self.log appendFormat:@"%@\n",string];
	self.textView.text = self.log;
	
	if (self.textView.contentSize.height > MAX(self.textView.contentOffset.y - self.textView.bounds.size.height,self.textView.bounds.size.height)) {
		[UIView animateWithDuration:0.3 animations:^(void) {
			self.textView.contentOffset = CGPointMake(0,self.textView.contentSize.height - self.textView.bounds.size.height - 10);
		}];
	}
//	self.textView.contentOffset =  self.textView.contentSize.height;
	[[self.textView superview] bringSubviewToFront:self.textView];
}

@end
