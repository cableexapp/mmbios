//
//  UIViewController+exp.m
//  TestConnection
//
//  Created by dqf on 6/2/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import <objc/runtime.h>

@implementation UIViewController (Extension)

-(void)setExView:(UIScrollView *)newExView
{
    objc_setAssociatedObject(self, @"exView", newExView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)exView
{
    if (!objc_getAssociatedObject(self, @"exView")) {
        
        [self setExView:(UIScrollView *)self.view];
    }
    return objc_getAssociatedObject(self, @"exView");
}

@end
