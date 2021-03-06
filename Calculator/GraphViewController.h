//
//  GraphViewController.h
//  Calculator
//
//  Created by alykhan.kanji on 16/04/13.
//  Copyright (c) 2013 Alykhan Kanji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) id program;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISwitch *drawingStyleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *programLabel;

@end
