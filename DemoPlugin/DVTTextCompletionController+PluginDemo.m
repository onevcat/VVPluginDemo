//
//  DVTTextCompletionController+PluginDemo.m
//  DemoPlugin
//
//  Created by OneV on 13-2-2.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "DVTTextCompletionController+PluginDemo.h"
#import "MethodSwizzle.h"

@implementation DVTTextCompletionController (PluginDemo)
+ (void)load
{
    MethodSwizzle(self, @selector(acceptCurrentCompletion), @selector(swizzledAcceptCurrentCompletion));
}

- (BOOL)swizzledAcceptCurrentCompletion {
    NSLog(@"acceptCurrentCompletion is called by %@", self);
    return [self swizzledAcceptCurrentCompletion];
}


@end
