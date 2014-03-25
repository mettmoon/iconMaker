//
//  Controller.h
//  iconMaker
//
//  Created by gideon on 12. 9. 21..
//  Copyright (c) 2012년 blesseddeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controller : NSObject
@property (weak) IBOutlet NSImageView *ivPreview;
@property (weak) IBOutlet NSTextField *tfOutput;
@property (weak) IBOutlet NSButton *btnOutput;
@property (weak) IBOutlet NSButton *btnConvert;
- (IBAction)findOutputButtonPressed:(id)sender;
- (IBAction)convertButtonPressed:(id)sender;
@end
