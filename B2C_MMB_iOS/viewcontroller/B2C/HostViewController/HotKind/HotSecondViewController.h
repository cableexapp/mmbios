//
//  HotSecondViewController.h
//  B2C_MMB_iOS
//
//  Created by cyumen on 14-11-12.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSecondViewController : UIViewController<UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *upArray;

@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextView *markView;


- (IBAction)submitNews:(id)sender;






@end
