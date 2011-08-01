//
//  Log.h
//  Raptor
//
//  Created by Martin Bjerregaard Nielsen on 1/8/11.
//  Copyright 2011 Identified Object. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogDelegate <NSObject>
-(void)logString:(NSString*)string;
@end

@interface Log : NSObject <LogDelegate>
@property (retain) IBOutlet UITextView *textView;
@property (retain) NSMutableString *log;
@end
