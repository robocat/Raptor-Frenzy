/*
 *  logging.h
 *
 *  Created by Martin on 24/2/11.
 *  Copyright 2011 Identified Object. All rights reserved.
 *
 *  http://stackoverflow.com/questions/969130/nslog-tips-and-tricks
 */

// Logging
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#   define DLog(...)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
