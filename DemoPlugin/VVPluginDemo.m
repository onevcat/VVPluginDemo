//
//  VVPluginDemo.m
//  DemoPlugin
//
//  Created by OneV on 13-2-2.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVPluginDemo.h"
#import "NSView+Dumping.h"

@interface VVPluginDemo()
@property (nonatomic,copy) NSString *selectedText;
@end

@implementation VVPluginDemo
+ (void) pluginDidLoad: (NSBundle*) plugin {
    [self shared];
}

+(id) shared {
    static dispatch_once_t once;
    static id instance = nil;
	dispatch_once(&once, ^{
		instance = [[self alloc] init];
	});
    return instance;
}

- (id)init {
	if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListener:) name:nil object:nil];
	}
	return self;
}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectionDidChange:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];
    
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"What is selected" action:@selector(showSelected:) keyEquivalent:@""];
        
        [newMenuItem setTarget:self];
        [newMenuItem setKeyEquivalentModifierMask: NSAlternateKeyMask];
        [[editMenuItem submenu] addItem:newMenuItem];
        [newMenuItem release];
    }
}

-(void) selectionDidChange:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView* textView = (NSTextView *)[noti object];
        
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count==0) {
            return;
        }
        
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString* text = textView.textStorage.string;
        self.selectedText = [text substringWithRange:selectedRange];
    }
    //Hello, welcom to OneV's Den
}

-(void) showSelected:(NSNotification *)noti {
    //Log view hierarchy of Xcode
    //[[[NSApp mainWindow] contentView] dumpWithIndent:@""];
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert setMessageText: self.selectedText];
    [alert runModal];
}

-(void)notificationListener:(NSNotification *)noti {
    NSLog(@"  Notification: %@", [noti name]);
}

@end
