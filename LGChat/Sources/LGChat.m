//
//  LGChat.m
//  LGChat
//
//  Created by David Sahakyan on 9/27/14.
//    Copyright (c) 2014 l0gg3r. All rights reserved.
//

#import "LGChat.h"

#import "IDEConsoleArea.h"
#import "IDEConsoleTextView.h"
#import "IDEDebugArea.h"
#import "IDEDefaultDebugArea.h"
#import "IDEEditorArea.h"
#import "IDEWorkspaceWindowController.h"
#import <objc/runtime.h>

static LGChat *sharedPlugin;

@interface LGChat()

@property (strong, nonatomic) NSBundle *bundle;

@property (weak, nonatomic) IDEConsoleArea *consoleArea;

@property (strong, nonatomic) IDEConsoleTextView *consoleTextView;

@end

@implementation LGChat

- (void)startPlugin
{
    self.consoleArea = ((IDEDefaultDebugArea *)[[[objc_getClass("IDEWorkspaceWindowController")
                                                  workspaceWindowControllers][0] editorArea] activeDebuggerArea]).consoleArea;
    SEL originalSelector = @selector(_appendItem:);
    SEL swizzledSelector = @selector(_appendItem:);
    
    Method originalMethod = class_getClassMethod(objc_getClass("IDEConsoleArea"), originalSelector);
    Method swizzledMethod = class_getClassMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    self.consoleTextView = [self.consoleArea valueForKey:@"_consoleView"];
    
    [self tick];
}

- (void)tick
{
    NSLog(@"Tick ;)");
    
    NSString *message = @"";
    switch (arc4random() % 5) {
        case 0:
            message = @"Hello!";
            break;
        case 1:
            message = @"Hi!";
            break;
        case 2:
            message = @"How are you?";
            break;
        case 3:
            message = @"Is this a chat?";
            break;
        case 4:
            message = @"Maybe...";
            break;
        default:
            break;
    }
    NSString *text = [NSString stringWithFormat:@"[%@]: %@", arc4random() % 2 ? @"g3r" : @"l0g", message];
    [self.consoleTextView insertText:text];
    [self.consoleTextView setNeedsDisplay:YES];
    [self.consoleTextView setNeedsLayout:YES];
    [self.consoleTextView insertNewline:nil];
    [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
}

- (void)_appendItem:(id)arg1
{
    [self _appendItem:arg1];
}





+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [self performSelector:@selector(startPlugin)
                   withObject:nil
                   afterDelay:10.0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
