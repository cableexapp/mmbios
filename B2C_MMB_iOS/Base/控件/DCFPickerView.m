//
//  DCFPickerView.m
//  DCFTeacherEnd
//
//  Created by jhq on 14-4-15.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFPickerView.h"
#import "DCFCustomExtra.h"
#import "MCDefine.h"

@implementation DCFPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame WithArray:(NSMutableArray *) array WithTag:(int) tag
{
    if(self = [super init])
    {
        self.frame = frame;
        
        pickTag = tag;
        
        
        if(pickTag < 100)
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[[array lastObject] objectForKey:@"children"]];
        }
        else
        {
            dataArray = [[NSMutableArray alloc] initWithArray:array];
        }
        [self loadView];
    }
    return self;
}

//- (id) initWithFrame:(CGRect)frame WithArray:(NSMutableArray *) array
//{
//    if(self = [super init])
//    {
//        self.frame = frame;
//
//
//        dataArray = [[NSMutableArray alloc] initWithArray:array];
//
//        [self loadView];
//    }
//    return self;
//}



- (void) loadView
{
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:<#(id)#> name:<#(NSString *)#> object:<#(id)#>];
    [self setAlpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216 - 44, self.frame.size.width, 216+44)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    toolBar.barStyle = 0;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"%f",self.frame.size.width);
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setFrame:CGRectMake(20, 0,( self.frame.size.width-40)/2, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBtn];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, doneBtn.frame.size.width/2, 0, 0)];
    [doneBtn setFrame:CGRectMake(cancelBtn.frame.origin.x+cancelBtn.frame.size.width, 0, ( self.frame.size.width-40)/2, 44)];
    doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:MYCOLOR forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:doneBtn];
    
    //    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target: nil action: nil];
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target: self action: @selector(done)];
    //    [rightButton setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal style:0 barMetrics:UIBarMetricsDefault];
    
    //    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(cancel)];
    //    [[UIBarButtonItem appearance] setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor blueColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal style:0 barMetrics:UIBarMetricsDefault];
    
    //    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    //    NSArray *array = [[NSArray alloc] initWithObjects: leftButton, rightButton, nil];
    //    [toolBar setItems:array];
    [view addSubview:toolBar];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.origin.y + toolBar.frame.size.height, self.frame.size.width, 216)];
    pickerView.delegate = self;
    [view addSubview:pickerView];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataArray.count;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(dataArray.count == 0 || [dataArray isKindOfClass:[NSNull class]])
    {
        title = @" ";
    }
    else
    {
        if(pickTag < 100)
        {
            NSString *str = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:row] objectForKey:@"name"]];
            title = str;
        }
        else
        {
            title = [dataArray objectAtIndex:row];
        }
    }
    
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = nil;
    if(pickTag < 100)
    {
        pickerTitle  = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:row] objectForKey:@"name"]];
    }
    else
    {
        pickerTitle  = [dataArray objectAtIndex:row];
    }
    return pickerTitle;
}

//- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 216/dataArray.count+20;
//}

- (void) done
{
    if([self.delegate respondsToSelector:@selector(pickerView:WithTag:)])
    {
        if(dataArray.count == 0 || [dataArray isKindOfClass:[NSNull class]])
        {
            title = @" ";
        }
        else
        {
            //默认选中第一条数据
            if(title.length == 0)
            {
                if(pickTag < 100)
                {
                    title = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:0] objectForKey:@"name"]];
                }
                else
                {
                    title = [dataArray objectAtIndex:0];
                }
            }
        }
        
        
        if([self.delegate respondsToSelector:@selector(pickerView:WithTag:)])
        {
            [self.delegate pickerView:title WithTag:pickTag];
        }
        [self inAndOut];
    }
    
}

- (void) cancel
{
    if([self.delegate respondsToSelector:@selector(pickerViewWithCancel:WithTag:)])
    {
        [self.delegate pickerViewWithCancel:@"" WithTag:pickTag];
    }
    [self inAndOut];
}

- (void) inAndOut
{
    [self setHidden:YES];
    [self.window setAlpha:1.0];
}
@end
