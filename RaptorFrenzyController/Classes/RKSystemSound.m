//
//  ILSystemSound.m
//  Outside
//
//  Created by Willi Wu on 24/08/09.
//  Copyright 2009 icelantern. All rights reserved.
//

#import "RKSystemSound.h"


@implementation RKSystemSound

@synthesize soundFile;

- (void)dealloc {
	[soundFile release];
	
	[super dealloc];
}

+ (RKSystemSound *)soundFile:(NSString *)newSoundFile {
    return [[[RKSystemSound alloc] initWithSoundFile:newSoundFile] autorelease];
}

- (id)initWithSoundFile:(NSString *)newSoundFile {
	self = [super init];
	if (self != nil)
	{
		soundFile = [newSoundFile retain];
		
		//Get the filename of the sound file:
		NSString *path = [[NSBundle mainBundle] pathForResource:soundFile ofType:@"caf"];
		
		if (path != nil) {
			//Get a URL for the sound file
			NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
			
			//Use audio sevices to create the sound
			AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);			
		}
	}
	return self;
}

- (void)playSound {
	AudioServicesPlaySystemSound(soundID);
}

@end
