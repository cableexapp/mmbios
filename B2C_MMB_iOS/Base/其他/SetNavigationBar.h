//
//  SetNavigationBar.h
//  Finance
//
//  Created by dqf on 3/1/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    TEACHERINDEX = 0,
    PARENTINDEX
};

int semgmentIndex;

@protocol SetNavigationBarDelegate;

@interface SetNavigationBar : NSObject
{
}

//set navigation bar delegate
@property(nonatomic,retain) id<SetNavigationBarDelegate>delegate;

//before used the class, you must set the navigation first
@property(nonatomic,retain) UINavigationController *navigationController;

//set navigation bar title
@property(nonatomic,retain) NSString *navTitle;

//set navigation bar left item title
@property(nonatomic,retain) NSString *navLeftItemTitle;

//set navigation bar left item image
@property(nonatomic,retain) UIImage *navLeftItemImage;

//set navigation bar right item title
@property(nonatomic,retain) NSString *navRightItemTitle;

//set navigation bar right item image
@property(nonatomic,retain) UIImage *navRightItemImage;

- (void)setNavigationBar;
- (void)setNavigationBarWithSegment;

@end


@protocol SetNavigationBarDelegate<NSObject>

//- (void)navLeftBtnAction:(UIButton *)btn;
- (void)navRightBtnAction:(UIButton *)btn;
- (void)segmentAction:(UISegmentedControl *)Seg;

@end