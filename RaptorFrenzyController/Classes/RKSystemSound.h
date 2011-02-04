//
//  ILSystemSound.h
//  Outside
//
//  Created by Willi Wu on 24/08/09.
//  Copyright 2009 icelantern. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>


@interface RKSystemSound : NSObject {
	NSString *soundFile;
	
	//declare a system sound id
	SystemSoundID soundID;
}

@property (nonatomic, retain) NSString *soundFile;

+ (RKSystemSound *)soundFile:(NSString *)newSoundFile;

- (id)initWithSoundFile:(NSString *)newSoundFile;

- (void)playSound;

@end
