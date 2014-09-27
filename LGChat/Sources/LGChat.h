//
//  LGChat.h
//  LGChat
//
//  Created by David Sahakyan on 9/27/14.
//  Copyright (c) 2014 l0gg3r. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LGChat : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle *bundle;

@end