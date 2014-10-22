//
//  LookForBigPicViewController.h
//  B2C_MMB_iOS
//
//  Created by App01 on 14-10-22.
//  Copyright (c) 2014年 YUANDONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeletePic <NSObject>

- (void) deletePic:(int) tag;

@end

@interface LookForBigPicViewController : UIViewController<UIScrollViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (strong,nonatomic) NSMutableArray *picArray;

@property (assign,nonatomic) id<DeletePic> delegate;

- (id) initWithPicArray:(NSMutableArray *) arr;
@end

