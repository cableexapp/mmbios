//
//  DCFMyTextView.m
//  DCFTeacherEnd
//
//  Created by jhq on 14-4-10.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFMyTextView.h"

@implementation DCFMyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setFrame:frame];
        
        [self setToolBar];
    }
    return self;
}

- (void) dismissKeyBoard
{
    [self resignFirstResponder];
}

- (void) setToolBar
{
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0f;
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

- (void) awakeFromNib
{
    [self setToolBar];
    
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
