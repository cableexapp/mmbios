//
//  DCFPickerView.h
//  DCFTeacherEnd
//
//  Created by jhq on 14-4-15.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerView <NSObject>

- (void) pickerView:(NSString *) title;

@end

@interface DCFPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIToolbar *toolBar;
    UIPickerView *pickerView;
    NSMutableArray *dataArray;
    NSString *title;
}
@property (assign,nonatomic) id<PickerView> delegate;

- (id) initWithFrame:(CGRect)frame WithArray:(NSMutableArray *) array;
@end
