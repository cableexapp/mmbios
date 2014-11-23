//
//  B2CShoppingSearchTableViewController.m
//  Far_East_MMB_iOS
//
//  Created by xiaochen on 14-9-16.
//  Copyright (c) 2014年 xiaochen. All rights reserved.
//

#import "B2CShoppingSearchViewController.h"
#import "B2CShoppingListViewController.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"

@interface B2CShoppingSearchViewController ()
{
    NSMutableArray *ivArray;
    
    
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    NSMutableArray *array4;
    
    
    UIImageView *useCloseIV;  //用途右上角关闭
    UIView *lineView_1;
    
    NSString *useString;  //用途
    NSString *brandString; //品牌
    NSString *specString;   //横截面
    NSString *modelString;  //型号
    
    NSMutableArray *headBtnArray;   //第一组（显示筛选条件的按钮）数组
    
    BOOL showUseCell;
    BOOL showModelCell;
    BOOL showSpecCell;
    BOOL showBrandCell;
    
    NSMutableArray *brandsArray;
    NSMutableArray *modelsArray;
    NSMutableArray *specsArray;
    NSMutableArray *uses;
}
@end

@implementation B2CShoppingSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void) loadRequestWithUse:(NSString *) requestUse WithModel:(NSString *) model WithSpec:(NSString *) spec WithBrand:(NSString *) brand WithRequestName:(NSString *) name WithTag:(int) tag
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"加载中..."];
    [HUD setDelegate:self];
    
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",name,time];
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *pushString = [NSString stringWithFormat:@"token=%@&use=%@&model=%@&spec=%@&brand=%@",token,requestUse,model,spec,brand];
    
    NSString *urlString = nil;
    if(tag == 0)
    {
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLScreeningConditionTag delegate:self];

        urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/ScreeningCondition.html?"];
    }
    else if (tag == 1)
    {

    }
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
//    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLScreeningConditionTag delegate:self];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    if(HUD)
    {
        [HUD hide:YES];
    }
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    if(URLTag == URLScreeningConditionTag)
    {
        if(result == 1)
        {
            brandsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"brands"]]];
            modelsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"models"]]];
            specsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"specs"]]];
            
            for(UIButton *btn in array2)
            {
                NSString *str = btn.titleLabel.text;
                for(int i=0;i<brandsArray.count;i++)
                {
                    if([str isEqualToString:[brandsArray objectAtIndex:i]])
                    {
                        [btn setEnabled:YES];
                        break;
                    }
                    else
                    {
                        [btn setEnabled:NO];
                    }
                }
                if(brandsArray.count == 0)
                {
                    [btn setEnabled:NO];
                }
            }
            for(UIButton *btn in array3)
            {
                NSString *str = btn.titleLabel.text;
                for(int i=0;i<modelsArray.count;i++)
                {
                    if([str isEqualToString:[modelsArray objectAtIndex:i]])
                    {
                        [btn setEnabled:YES];
                        break;
                    }
                    else
                    {
                        [btn setEnabled:NO];
                    }
                }
                if(modelsArray.count == 0)
                {
                    [btn setEnabled:NO];
                }
            }
            for(UIButton *btn in array4)
            {
                NSString *str = btn.titleLabel.text;
                str = [self getNumFromString:str];
                for(int i=0;i<specsArray.count;i++)
                {
                    if([str isEqualToString:[specsArray objectAtIndex:i]])
                    {
                        [btn setEnabled:YES];
                        break;
                    }
                    else
                    {
                        [btn setEnabled:NO];
                    }
                }
                if(specsArray.count == 0)
                {
                    [btn setEnabled:NO];
                }
            }
        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }
        [tv reloadData];
    }
}

- (NSString *) getNumFromString:(NSString *) string
{
    NSString *price = @"";
    for(int i=0;i<string.length;i++)
    {
        char c = [string characterAtIndex:i];
        if(c == '.' || c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9')
        {
            price = [price stringByAppendingFormat:@"%c",c];
        }
    }
    return price;
}

#pragma mark - 去除重复元素
- (NSMutableArray *) dealArray:(NSMutableArray *) arr
{
    NSSet *set = [NSSet setWithArray:arr];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[[set allObjects] count];i++)
    {
        [array addObject:[[set allObjects] objectAtIndex:i]];
    }
    return array;
}

#pragma mark - 用途按钮选中点击
- (void) useBtnClick:(UIButton *) sender
{
    useString = sender.titleLabel.text;

    [self upDateHeadBtnArray:1];
    
    UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [useBtn setTitle:useString forState:UIControlStateNormal];
//    [useBtn setFrame:CGRectMake(useBtn.frame.size.width+20, 5, 50, 30)];
    [useBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [useBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    useBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    useBtn.layer.borderWidth = 1.0f;
    [useBtn setTag:1];
    [headBtnArray addObject:useBtn];
    
    showUseCell = NO;
    

    [self setHeadBtnFrame];
 

    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
 
}

#pragma mark - 品牌按钮点击
- (void) brandBtnClick:(UIButton *) sender
{
    brandString = sender.titleLabel.text;
    
    [self upDateHeadBtnArray:4];
    
    UIButton *brandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [brandBtn setTitle:brandString forState:UIControlStateNormal];
    [brandBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [brandBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    brandBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    brandBtn.layer.borderWidth = 1.0f;
    [brandBtn setTag:4];
    [headBtnArray addObject:brandBtn];
    
    showBrandCell = NO;
    
    [self setHeadBtnFrame];
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

#pragma mark - 型号按钮点击
- (void) modelBtnClick:(UIButton *) sender
{
    modelString = sender.titleLabel.text;
    
    [self upDateHeadBtnArray:2];
    
    UIButton *modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modelBtn setTitle:modelString forState:UIControlStateNormal];
    [modelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [modelBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    modelBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    modelBtn.layer.borderWidth = 1.0f;
    [modelBtn setTag:2];
    [headBtnArray addObject:modelBtn];
    
    showModelCell = NO;
    

    [self setHeadBtnFrame];
    
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

#pragma mark - 横截面按钮点击
- (void) specBtnClick:(UIButton *) sender
{
    specString = sender.titleLabel.text;
    
    [self upDateHeadBtnArray:3];
    
    UIButton *specBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [specBtn setTitle:specString forState:UIControlStateNormal];
    [specBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [specBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    specBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    specBtn.layer.borderWidth = 1.0f;
    [specBtn setTag:3];
    [headBtnArray addObject:specBtn];
    
    showSpecCell = NO;
    
    [self setHeadBtnFrame];
    
    specString = [self getNumFromString:specString];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

#pragma mark - 更新第一组里面的按钮
- (void) upDateHeadBtnArray:(int) btnTag
{
    if(headBtnArray && headBtnArray.count != 0)
    {
        for(int i=0;i<headBtnArray.count;i++)
        {
            UIButton *B  = [headBtnArray objectAtIndex:i];
            if(B.tag == btnTag)
            {
                [headBtnArray removeObject:B];
            }
        }
    }
}

#pragma mark - 第一组按钮点击事件
- (void) headBtnClick:(UIButton *) sender
{
    if(headBtnArray && headBtnArray.count != 0)
    {

        UIButton *btn = sender;
        if(btn.tag == 1)
        {
            showUseCell = YES;
            useString = @"";
        }
        if(btn.tag == 2)
        {
            modelString = @"";
            showModelCell = YES;
            
        }
        if(btn.tag == 3)
        {
            specString = @"";
            showSpecCell = YES;
        }
        if(btn.tag == 4)
        {
            brandString = @"";
            showBrandCell = YES;
        }
        if(btn.tag == sender.tag)
        {
            [headBtnArray removeObject:btn];
        }
 
        [self setHeadBtnFrame];
    }
    if(headBtnArray.count == 0)
    {
        for(UIButton *btn in array2)
        {
            [btn setEnabled:YES];
        }
        for(UIButton *btn in array3)
        {
            [btn setEnabled:YES];
        }
        for(UIButton *btn in array4)
        {
            [btn setEnabled:YES];
        }
    }
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
    
    if(headBtnArray.count != 0)
    {
        for(UIButton *btn in headBtnArray)
        {
            if(btn.tag == 1)
            {
                
            }
        }
    }
}

#pragma mark - 设置第一组按钮frame
- (void) setHeadBtnFrame
{
    if(headBtnArray && headBtnArray.count != 0)
    {
        for(int i=0;i<headBtnArray.count;i++)
        {
            float width = (myRect.size.width-20)/2;
            UIButton *B  = [headBtnArray objectAtIndex:i];
            [B setTitle:B.titleLabel.text forState:UIControlStateNormal];
            [B addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (i)
            {
                case 0:
                    [B setFrame:CGRectMake(15, 5, width-60, 30)];
                    break;
                case 1:
                    [B setFrame:CGRectMake(15+width-10, 5, width-60, 30)];
                    break;
                case 2:
                    [B setFrame:CGRectMake(15, 40, width-60, 30)];
                    break;
                case 3:
                    [B setFrame:CGRectMake(15+width-10, 40, width-60, 30)];
                    break;
                default:
                    break;
            }
            
            useCloseIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Set.png"]];
            [useCloseIV setFrame:CGRectMake(B.frame.size.width, 0, 30, 30)];
            useCloseIV.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
            useCloseIV.layer.borderWidth = 1.0f;
            [B addSubview:useCloseIV];
     
        }
    }
    [tv reloadData];
}

#pragma mark - 单独刷新第一组
- (void) reloadSection
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *arr = [NSArray arrayWithObjects:path, nil];
    [tv reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}

- (void) addHeadView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    [label setText:@"商品分类"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:label];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearBtn setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 10, 10, 40, 20)];
    [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [_clearBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_clearBtn];
    
    
       _lineView = [[UIView alloc] initWithFrame:CGRectMake(_clearBtn.frame.origin.x + _clearBtn.frame.size.width, _clearBtn.frame.origin.y, 1, 20)];
//    [_lineView setBackgroundColor:MYCOLOR];
//    [topView addSubview:_lineView];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setFrame:CGRectMake(_lineView.frame.origin.x+_lineView.frame.size.width + 10, _lineView.frame.origin.y, 40, 20)];
    [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_sureBtn];
    
    //    sectionArray = [[NSArray alloc] initWithObjects:@"品牌",@"用途",@"型号",@"横截面",@"颜色",@"芯数",@"单位", nil];
    
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, myRect.size.width, myRect.size.height-90) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    
    float btnWidth = (myRect.size.width-20)/3;
#pragma mark - 用途数组
    array1 = [[NSMutableArray alloc] init];
    for(int i=0;i<13;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"照明" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"插座" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"热水器" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"立式空调" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"挂壁空调" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"中央空调" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"装潢明线" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"进户总线" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"网络" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"电话" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"电源连接线" forState:UIControlStateNormal];
        }
        if(i == 11)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"视频" forState:UIControlStateNormal];
        }
        if(i == 12)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*5 + 30*4, btnWidth-20, 30)];
            [btn setTitle:@"音频" forState:UIControlStateNormal];
            
                    }
        
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [btn setEnabled:YES];
        [array1 addObject:btn];
    }
    
#pragma mark - 品牌数组
    array2 = [[NSMutableArray alloc] init];
    for(int i=0;i<9;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"远东" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"华东电缆" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"鑫园电缆" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"玖开电缆" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"澳航" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"陆通舜山" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"上进" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"安徽电缆" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"荣宜天康" forState:UIControlStateNormal];
            
        }
        
        
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setEnabled:YES];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array2 addObject:btn];
    }
    
#pragma mark - 型号数组
    array3 = [[NSMutableArray alloc] init];
    for(int i=0;i<13;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"BV" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"BVR" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"BVV" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"BRVV" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"ZR-BV" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"NH-BV" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"ZR-RVS" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"NH-RVS" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"ZR-BVR" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"NH-BVR" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"ZR-RVV" forState:UIControlStateNormal];
        }
        if(i == 11)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"NH-RVV" forState:UIControlStateNormal];
        }
        if(i == 12)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*5 + 30*4, btnWidth-20, 30)];
            [btn setTitle:@"HSYV-5" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setEnabled:YES];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(modelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array3 addObject:btn];
    }
    
#pragma mark - 横截面数组
    array4 = [[NSMutableArray alloc] init];
    for(int i=0;i<11;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"0.5平方" forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"0.75平方" forState:UIControlStateNormal];
        }
        if(i == 2)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*1 + 30*0, btnWidth-20, 30)];
            [btn setTitle:@"1平方" forState:UIControlStateNormal];
        }
        if(i == 3)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"1.5平方" forState:UIControlStateNormal];
        }
        if(i == 4)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"2.5平方" forState:UIControlStateNormal];
        }
        if(i == 5)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*2 + 30*1, btnWidth-20, 30)];
            [btn setTitle:@"4平方" forState:UIControlStateNormal];
        }
        if(i == 6)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"6平方" forState:UIControlStateNormal];
        }
        if(i == 7)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"10平方" forState:UIControlStateNormal];
        }
        if(i == 8)
        {
            [btn setFrame:CGRectMake(5*3 + btnWidth*2-15, 5*3 + 30*2, btnWidth-20, 30)];
            [btn setTitle:@"16平方" forState:UIControlStateNormal];
        }
        if(i == 9)
        {
            [btn setFrame:CGRectMake(5*1 + btnWidth*0+5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"25平方" forState:UIControlStateNormal];
        }
        if(i == 10)
        {
            [btn setFrame:CGRectMake(5*2 + btnWidth*1-5, 5*4 + 30*3, btnWidth-20, 30)];
            [btn setTitle:@"35平方" forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0]forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn setEnabled:YES];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
//        [btn setBackgroundImage:[DCFCustomExtra imageWithColor:[UIColor colorWithRed:167.0/255.0 green:167.0/255.0 blue:167.0/255.0 alpha:1.0 ] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(specBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array4 addObject:btn];
    }
    _myDic = [[NSDictionary alloc] initWithObjectsAndKeys:array1,@"按用途筛选",
              array2,@"按品牌筛选",
              array3,@"按型号筛选",
              array4,@"按横截面筛选",nil];
    
    ivArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[[_myDic allKeys] count];i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 23, 27)];
        [iv setImage:[UIImage imageNamed:@"next.png"]];
        [ivArray addObject:iv];
    }
    
    flag = (BOOL*)malloc([[_myDic allKeys] count]*sizeof(BOOL*));
    memset(flag, YES, sizeof(flag));
    
}

- (id) initWithFrame:(CGRect) rect
{
    if(self = [super init])
    {
        
        myRect = rect;
        self.view.frame = rect;
        
        headBtnArray = [[NSMutableArray alloc] init];
        
        useString = @"";
        brandString = @"";
        specString = @"";
        modelString = @"";
        
        showUseCell = YES;
        showModelCell = YES;
        showSpecCell = YES;
        showBrandCell = YES;
    }
    return self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(HUD)
    {
        [HUD hide:YES];
        HUD = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   


}

- (void) clear:(UIButton *) sender
{

//     backView.hidden = YES;
    if(headBtnArray && headBtnArray.count != 0)
    {
        [headBtnArray removeAllObjects];
        
        showUseCell = YES;
        showModelCell = YES;
        showSpecCell = YES;
        showBrandCell = YES;
        
        useString = @"";
        modelString = @"";
        specString = @"";
        brandString = @"";
        
        [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
    }
    
    
    [self.view.superview removeFromSuperview];
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromParentViewController];
}

- (void) sure:(UIButton *) sender
{
    
    if([self.delegate respondsToSelector:@selector(requestStringWithUse:WithBrand:WithSpec:WithModel:WithSeq:)])
    {
        [self.delegate requestStringWithUse:useString WithBrand:brandString WithSpec:specString WithModel:modelString WithSeq:@""];
    }
    
    
    [self.view.superview removeFromSuperview];
    [self.view removeFromSuperview];
    self.view = nil;
    [self removeFromParentViewController];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_myDic allKeys] count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        if(!headBtnArray || headBtnArray.count == 0)
        {
            return 0;
        }
        return 1;
    }
	return [self numberOfRowsInSection:section-1];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(!headBtnArray || headBtnArray.count == 0)
        {
            return 0;
        }
        else
        {
            return [[headBtnArray lastObject] frame].origin.y + [[headBtnArray lastObject] frame].size.height + 5;
        }
    }
    else
    {
        [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section-1]] count];
        
        UIButton *btn = (UIButton *)[[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section-1]] lastObject];
//        if(indexPath.section == 0)
//        {
//            float btnWidth = (myRect.size.width-20)/3;
//            UIButton *btn = [array1 objectAtIndex:0];
//            
//        }
        if(indexPath.section == 1)
        {
            
            if(showUseCell == YES)
            {
                for(UIButton *btn in array1)
                {
                    [btn setHidden:NO];
                }
            }
            else
            {
                for(UIButton *btn in array1)
                {
                    [btn setHidden:YES];
                }
                return 0;
            }
        }
        if(indexPath.section == 2)
        {
            if(showModelCell == YES)
            {
                for(UIButton *btn in array3)
                {
                    [btn setHidden:NO];
                }
            }
            else
            {
                for(UIButton *btn in array3)
                {
                    [btn setHidden:YES];
                }
                return 0;
            }
        }
        if(indexPath.section == 3)
        {
            if(showSpecCell == YES)
            {
                for(UIButton *btn in array4)
                {
                    [btn setHidden:NO];
                }
            }
            else
            {
                for(UIButton *btn in array4)
                {
                    [btn setHidden:YES];
                }
                return 0;
            }
        }
        if(indexPath.section == 4)
        {
            if(showBrandCell == YES)
            {
                for(UIButton *btn in array2)
                {
                    [btn setHidden:NO];
                }
            }
            else
            {
                for(UIButton *btn in array2)
                {
                    [btn setHidden:YES];
                }
                return 0;
            }
        }
        return btn.frame.origin.y + btn.frame.size.height +5;
    }

    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    if(section == 1)
    {
        if(showUseCell == YES)
        {
            
        }
        else
        {
            return 0;
        }
    }
    if(section == 2)
    {
        if(showModelCell == YES)
        {
            
        }
        else
        {
            return 0;
        }
    }
    if(section == 3)
    {
        if(showSpecCell == YES)
        {
            
        }
        else
        {
            return 0;
        }
    }
    if(section == 4)
    {
        if(showBrandCell == YES)
        {
            
        }
        else
        {
            return 0;
        }
    }
    return 32;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    view1 = nil;
	view2 = nil;
	view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 32)];
	view1.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
//       view1.backgroundColor = [UIColor redColor];
	
	view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 32)];
	view2.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 31, myRect.size.width, 3.0);
    lineView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    [view2 addSubview:lineView];
	[view1 addSubview:view2];
	
   
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
    abtn.backgroundColor = [UIColor clearColor];
    abtn.frame = CGRectMake(0, 0,myRect.size.width, 32);
    
//    UIImageView *iv =[ivArray objectAtIndex:section-1];
//    [abtn addSubview:iv];
    
	abtn.tag = section-1;
	[abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:abtn];
    
    
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, myRect.size.width, 30)];
	label1.backgroundColor = [UIColor clearColor];
    [label1 setFont:[UIFont systemFontOfSize:13]];
	label1.text = [[_myDic allKeys] objectAtIndex:section-1];
    [abtn addSubview:label1];
	
    
	return view1;
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
//        [cell.contentView setBackgroundColor:[UIColor redColor]];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
        
    }

    
    //	NSString *str = [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:indexPath.row];
    //	cell.imageView.image = [UIImage imageNamed:@"102.png"];
    //	cell.textLabel.text = str;
    //	cell.detailTextLabel.text = @"cocoaChina 会员";
    
    if(indexPath.section == 0)
    {
        if(!headBtnArray || headBtnArray.count == 0)
        {
            
        }
        else
        {
//            选中的btn
            for(UIButton *btn in headBtnArray)
            {
                [cell.contentView addSubview:btn];
            }
        }
    }
    else
    {
//        列表的所有Btn
        NSMutableArray *array = [_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section-1]];
        for(UIButton *btn in array)
        {
            [cell.contentView addSubview:btn];
        }
    }

    return cell;
}


-(void)headerClicked:(id)sender
{
	int sectionIndex = ((UIButton*)sender).tag;
    
	UIButton *btn = (UIButton *)sender;
	flag[sectionIndex] = !flag[sectionIndex];
    
//    UIImageView *iv = [ivArray objectAtIndex:sectionIndex];
    
	if(flag[sectionIndex])
	{
        
        
		btn.selected = YES;
//       [iv setImage:[UIImage imageNamed:@"click1.png"]];
        
        
	}
	else
    {
		btn.selected = NO;
//        [iv setImage:[UIImage imageNamed:@"next.png"]];

	}
    
	[tv reloadData];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
	if (flag[section]) {
        //		return [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:section]] count];
        return 1;
	}
	else {
		return 0;
	}
}


- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


@end
