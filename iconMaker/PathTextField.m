//
//  PathTextField.m
//  iconMaker
//
//  Created by Moon Hayden on 2014. 3. 25..
//  Copyright (c) 2014년 blesseddeveloper. All rights reserved.
//

#import "PathTextField.h"

@implementation PathTextField
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filePathChanged:) name:@"FilePathChanged" object:nil];

    }
    return self;
}
- (void)filePathChanged:(NSNotification *)notification;
{
    NSString *path = notification.object;
    path = [path substringToIndex:[path rangeOfString:@"/" options:NSBackwardsSearch].location];
    [self setStringValue:path];
    
    
}

@end
