//
//  HelloWorldLayer.h
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright Robocat 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <GameKit/GameKit.h>


// HelloWorld Layer
@interface HelloWorld : CCLayer <GKSessionDelegate>
{
	
	CCSprite		*_raptor1;
	CCSprite		*_raptor2;
}

@property (nonatomic, retain) CCSprite *raptor1;
@property (nonatomic, retain) CCSprite *raptor2;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
