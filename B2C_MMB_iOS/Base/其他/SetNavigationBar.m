//
//  SetNavigationBar.m
//  Finance
//
//  Created by dqf on 3/1/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "SetNavigationBar.h"

@implementation SetNavigationBar

@synthesize delegate;
@synthesize navigationController;
@synthesize navTitle;
@synthesize navLeftItemTitle;
@synthesize navLeftItemImage;
@synthesize navRightItemTitle;
@synthesize navRightItemImage;

//set navigation bar left btn action

- (void)setNavLeftBtnNull
{
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = nil;
}
- (void)setNavLeftBtnWithTitle:(NSString *)aTitle
{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0.0, 7.0, 54.0, 30.0);
    [btn setTitle:aTitle forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    if (navLeftItemImage) {
        [btn setBackgroundImage:self.navLeftItemImage forState:UIControlStateNormal];
        [btn setBackgroundImage:self.navLeftItemImage forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(navLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationController.navigationItem.rightBarButtonItem = item;
    
}
- (void)navLeftBtnClicked:(UIButton *)aBtn
{
//    if ([delegate respondsToSelector:@selector(navLeftBtnAction:)]) {
//        [self.delegate navLeftBtnAction:aBtn];
//    }
}

//set navigation bar title

-(void)setNavTitleNull
{
    self.navigationController.topViewController.navigationItem.titleView = nil;
}
-(void)setNavWithTitle:(NSString *)aTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = aTitle;
    [label sizeToFit];
    self.navigationController.topViewController.navigationItem.titleView = label;
}
-(void)setNavWithSegment
{
    if (![self.navigationController.topViewController.navigationItem.titleView isKindOfClass:[UISegmentedControl class]]) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 7.5, 149.0, 30.0)];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.cornerRadius = 4.0;
        
//        UIView *view = [[UIView alloc] init];
//        [view setFrame:CGRectMake(2.0, 2.0, 146, 26)];
//        [view setBackgroundColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0]];
//        view.layer.cornerRadius = 3.5;
//        [bgView addSubview:view];
        
        //初始化UISegmentedControl
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"老师",@"家长",nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(0.0, 0.0, 150.0, 30.0);
        if (semgmentIndex != TEACHERINDEX && semgmentIndex != PARENTINDEX) {
            semgmentIndex = TEACHERINDEX;
        }
        segmentedControl.layer.cornerRadius = 4.0;
        segmentedControl.tintColor = [UIColor colorWithRed:49/255.0 green:104/255.0 blue:2/255.0 alpha:1.0];
//        segmentedControl.tintColor = [UIColor colorWithRed:69/255.0 green:124/255.0 blue:22/255.0 alpha:1.0];
//        [segmentedControl setBackgroundColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0]];
        [segmentedControl setBackgroundColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0]];
        [segmentedControl addTarget:self action:@selector(mySegmentAction:)forControlEvents:UIControlEventValueChanged];
        [bgView addSubview:segmentedControl];
        if (semgmentIndex == TEACHERINDEX) {
            segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        }else if (semgmentIndex == PARENTINDEX){
            segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
        }
        [self mySegmentAction:segmentedControl];
        
        self.navigationController.topViewController.navigationItem.titleView = bgView;
        
    }

}
-(void)mySegmentAction:(UISegmentedControl *)Seg
{

    if ([self.delegate respondsToSelector:@selector(segmentAction:)]) {
        [self.delegate segmentAction:Seg];
    }

}
//set navigation bar right btn action

- (void)setNavRightBtnNull
{
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
}
- (void)setNavRightBtnWithTitle:(NSString *)aTitle
{
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0.0, 7.0, 60.0, 30.0);
    [btn setTitle:aTitle forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    if (navRightItemImage) {
        [btn setBackgroundImage:self.navRightItemImage forState:UIControlStateNormal];
        [btn setBackgroundImage:self.navRightItemImage forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(navRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = item;
    
}
- (void)navRightBtnClicked:(UIButton *)aBtn
{
    if ([delegate respondsToSelector:@selector(navRightBtnAction:)]) {
        [self.delegate navRightBtnAction:aBtn];
    }
}

//set navigation bar

- (void)setNavigationBar
{
    //set nav bar left btn
    if (navLeftItemTitle) {
        [self setNavLeftBtnWithTitle:self.navLeftItemTitle];
    }else{
        [self setNavLeftBtnNull];
    }
    //set nav bar title
    if (navTitle) {
        [self setNavWithTitle:self.navTitle];
    }else{
        [self setNavTitleNull];
    }
    //set nav bar right btn
    if (navRightItemTitle) {
        [self setNavRightBtnWithTitle:self.navRightItemTitle];
    }else{
        [self setNavRightBtnNull];
    }
    
    //set backItem style
    [self setBackItem];
    
}
- (void)setNavigationBarWithSegment
{
    //set nav bar left btn
    if (navLeftItemTitle) {
        [self setNavLeftBtnWithTitle:self.navLeftItemTitle];
    }else{
        [self setNavLeftBtnNull];
    }
    //set nav bar title
    [self setNavWithSegment];
    //set nav bar right btn
    if (navRightItemTitle) {
        [self setNavRightBtnWithTitle:self.navRightItemTitle];
    }else{
        [self setNavRightBtnNull];
    }
    
    //set backItem style
    [self setBackItem];
}
- (void)setBackItem
{
    //back button item
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationController.topViewController.navigationItem.backBarButtonItem = backItem;
    //set tint color
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}



@end
