//
//  MyTextField.m
//  com.up360
//
//  Created by jhq on 14-3-20.
//  Copyright (c) 2014年 jhq. All rights reserved.
//

#import "DCFMyTextField.h"

@implementation DCFMyTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0f;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.masksToBounds = YES;
        
        UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [topView setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *helloBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
        UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray *array = [NSArray arrayWithObjects:helloBtn,btnSpace,doneBtn, nil];
        [topView setItems:array];
        [self setInputAccessoryView:topView];
    }
    
    return self;
}

- (void) dismissKeyBoard
{
    [self resignFirstResponder];
}

- (void) awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0f;
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.masksToBounds = YES;
    
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *helloBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray *array = [NSArray arrayWithObjects:helloBtn,btnSpace,doneBtn, nil];
    [topView setItems:array];
    [self setInputAccessoryView:topView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
