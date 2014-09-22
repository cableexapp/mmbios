//
//  DCFPickerView.m
//  DCFTeacherEnd
//
//  Created by jhq on 14-4-15.
//  Copyright (c) 2014年 dqf. All rights reserved.
//

#import "DCFPickerView.h"

@implementation DCFPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame WithArray:(NSMutableArray *) array
{
    if(self = [super init])
    {
        self.frame = frame;

        
        dataArray = [[NSMutableArray alloc] initWithArray:array];

        [self loadView];
    }
    return self;
}



- (void) loadView
{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:<#(id)#> name:<#(NSString *)#> object:<#(id)#>];
    [self setAlpha:1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216 - 44, 320, 216+44)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = 0;
    
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target: nil action: nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target: self action: @selector(done)];
    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(cancel)];
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton, rightButton, nil];
    [toolBar setItems:array];
    [view addSubview:toolBar];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.origin.y + toolBar.frame.size.height, 320, 216)];
    pickerView.delegate = self;
    [view addSubview:pickerView];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArray count];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    title = [dataArray objectAtIndex:row];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pickerTitle = [dataArray objectAtIndex:row];
    return pickerTitle;
}

//- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 216/dataArray.count+20;
//}

- (void) done
{
    if([self.delegate respondsToSelector:@selector(pickerView:)])
    {
        if(title.length == 0)
        {
            title = [dataArray objectAtIndex:0];
        }

            [self.delegate pickerView:title];
        [self inAndOut];
    }

}

- (void) cancel
{
    [self inAndOut];
}

- (void) inAndOut
{
    [self setHidden:YES];
    [self.window setAlpha:1.0];
}
@end
