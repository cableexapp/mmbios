//
//  DCFTabBarCtrl.h
//  DCFParentEnd
//
//  Created by dqf on 14-6-10.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DCFTabBarCtrl : UITabBarController
{
    AVAudioPlayer * messageSound;
}

- (void) changeSelectItem;

@end
