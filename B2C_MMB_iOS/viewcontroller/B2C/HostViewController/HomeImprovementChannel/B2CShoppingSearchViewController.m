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
    
    UIImage *useCloseIV;  //用途右上角关闭
    UIImage *useCloseIV_1;
    UIImage *useCloseIV_2;
    UIImage *useCloseIV_3;
    
    UIImageView *triangle;  //展开的小三角
    UIImageView *triangle_1;  //展开的小三角
    UIImageView *triangle_2;  //展开的小三角
    UIImageView *triangle_3;  //展开的小三角

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
    NSMutableArray *usesArray;
    NSMutableArray * triangleAaary;
    
    
    UIButton *brandBtn;
    UIButton *modelBtn;
    UIButton *useBtn;
    UIButton *specBtn;
    UIButton *abtn;
    
    UIButton *brandBtn_0;
    UIButton *modelBtn_1;
    UIButton *useBtn_2;
    UIButton *specBtn_3;

    
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
            NSLog(@"筛选dicRespon = %@",dicRespon);
            
            brandsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"brands"]]];
            modelsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"models"]]];
            specsArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"specs"]]];
            usesArray = [[NSMutableArray alloc] initWithArray:[self dealArray:[dicRespon objectForKey:@"uses"]]];
#pragma mark     -  选中的列表选项处理
            
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
  
            for(UIButton *btn in array1)
            {
                NSString *str = btn.titleLabel.text;
                for(int i=0;i<usesArray.count;i++)
                {
                    if([str isEqualToString:[usesArray objectAtIndex:i]])
                    {
                        [btn setEnabled:YES];
                        break;
                    }
                    else
                    {
                        [btn setEnabled:NO];
                    }
                }
                if(usesArray.count == 0)
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
//                str = [self getNumFromString:str];

                for(int i=0;i<specsArray.count;i++)
                {
                    if([str isEqualToString:[NSString stringWithFormat:@"%@平方",[specsArray objectAtIndex:i]]])
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSString *tempBtand = [[NSUserDefaults standardUserDefaults] objectForKey:@"brand_save"];
    NSString *tempModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"model_save"];
    NSString *tempUse = [[NSUserDefaults standardUserDefaults] objectForKey:@"use_save"];
    NSString *tempSpec = [[NSUserDefaults standardUserDefaults] objectForKey:@"spec_save"];
 
    if (tempBtand.length > 0)
    {
        brandString = tempBtand;
        [brandBtn setHidden:NO];
        [brandBtn_0 setHidden:NO];
        [triangle setHidden:YES];
        [brandBtn setTitle:brandString forState:UIControlStateNormal];
    }
    if (tempModel.length > 0)
    {
        modelString = tempModel;
        [modelBtn setHidden:NO];
        [modelBtn_1 setHidden:NO];
        [triangle_1 setHidden:YES];
        [modelBtn setTitle:modelString forState:UIControlStateNormal];
    }
    if (tempUse.length > 0)
    {
        useString = tempUse;
        [useBtn setHidden:NO];
        [useBtn_2 setHidden:NO];
        [triangle_2 setHidden:YES];
        [useBtn setTitle:useString forState:UIControlStateNormal];
    }
    if (tempSpec.length > 0)
    {
        specString = tempSpec;
        [specBtn setHidden:NO];
        [specBtn_3 setHidden:NO];
        [triangle_3 setHidden:YES];
        [specBtn setTitle:specString forState:UIControlStateNormal];
    }
}

#pragma mark - 品牌按钮点击
- (void) brandBtnClick:(UIButton *) sender
{
    int sectionIndex = ((UIButton*)sender).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    brandString = sender.titleLabel.text;
    [brandBtn setHidden:NO];
    [brandBtn_0 setHidden:NO];
    [triangle setHidden:YES];
    [brandBtn setTitle:brandString forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:brandString forKey:@"brand_save"];
    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sectionIndex] forKey:@"brandBtn_save"];
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

#pragma mark - 型号按钮点击
- (void) modelBtnClick:(UIButton *) sender
{
    int sectionIndex = ((UIButton*)sender).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    modelString = sender.titleLabel.text;
    [modelBtn setHidden:NO];
    [modelBtn_1 setHidden:NO];
    [triangle_1 setHidden:YES];

    [[NSUserDefaults standardUserDefaults] setObject:modelString forKey:@"model_save"];
    
    [modelBtn setTitle:modelString forState:UIControlStateNormal];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

#pragma mark - 用途按钮选中点击
- (void) useBtnClick:(UIButton *) sender
{
    int sectionIndex = ((UIButton*)sender).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    useString = sender.titleLabel.text;
    [useBtn setHidden:NO];
    [useBtn_2 setHidden:NO];
    [triangle_2 setHidden:YES];
    [useBtn setTitle:useString forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:useString forKey:@"use_save"];
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
    
}

#pragma mark - 横截面按钮点击
- (void) specBtnClick:(UIButton *) sender
{
    int sectionIndex = ((UIButton*)sender).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    specString = sender.titleLabel.text;
    [specBtn setHidden:NO];
    [specBtn_3 setHidden:NO];
    [triangle_3 setHidden:YES];
    [specBtn setTitle:specString forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:specString forKey:@"spec_save"];
    
//    specString = [self getNumFromString:specString];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}



- (void) addHeadView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 40)];
    [topView setBackgroundColor:[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 40)];
    [label setText:@"商品分类"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
//    [label setBackgroundColor:[UIColor redColor]];
    [topView addSubview:label];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearBtn setFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, 0,(ScreenWidth-130)/2+10, 40)];
    [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [_clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_clearBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_clearBtn];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_sureBtn setFrame:CGRectMake(_clearBtn.frame.origin.x+_clearBtn.frame.size.width, 0,ScreenWidth-(_clearBtn.frame.origin.x+_clearBtn.frame.size.width+40),40)];
    [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_sureBtn];
    
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, myRect.size.width, myRect.size.height-90) style:0];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tv];
    
    float btnWidth = (myRect.size.width-20)/3;
#pragma mark - 用途数组
    array1 = [[NSMutableArray alloc] init];
    for(int i=0;i<[[_ScreeningCondition lastObject] count];i++)
    {
        NSString *useStr = [NSString stringWithFormat:@"%@",[[_ScreeningCondition lastObject] objectAtIndex:i]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setNumberOfLines:0];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn setTitle:useStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn setTag:2];
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [btn setEnabled:YES];
        [array1 addObject:btn];

        int yu = i%3;
        CGFloat originX = 0.0;
   
        
        if(yu == 0)
        {
            originX = 5*1 + btnWidth*0 + 5;
        }
        if(yu == 1)
        {
            originX = 5*2 + btnWidth*1 - 5;
        }
        if(yu == 2)
        {
            originX = 5*3 + btnWidth*2 - 15;
        }
        
        
        int chu = i/3;
        CGFloat originY = 5*(chu+1) + 30*chu;
        [btn setFrame:CGRectMake(originX,originY, btnWidth-20, 30)];

    }
    
#pragma mark - 品牌数组
    array2 = [[NSMutableArray alloc] init];
    for(int i=0;i<[[_ScreeningCondition objectAtIndex:0] count];i++)
    {
        NSString *brandStr = [NSString stringWithFormat:@"%@",[[_ScreeningCondition objectAtIndex:0] objectAtIndex:i]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setNumberOfLines:0];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];

        [btn setTitle:brandStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn setTag:0];
        [btn setEnabled:YES];
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array2 addObject:btn];
        
        
        int yu = i%3;
        CGFloat originX = 0.0;
        
        
        if(yu == 0)
        {
            originX = 5*1 + btnWidth*0 + 5;
        }
        if(yu == 1)
        {
            originX = 5*2 + btnWidth*1 - 5;
        }
        if(yu == 2)
        {
            originX = 5*3 + btnWidth*2 - 15;
        }
        
        
        int chu = i/3;
        CGFloat originY = 5*(chu+1) + 30*chu;
        [btn setFrame:CGRectMake(originX,originY, btnWidth-20, 30)];



        
//        for(UIButton *btn in array2)
//        {
//            NSString *str = btn.titleLabel.text;
//            for(int i=0;i<brandsArray.count;i++)
//            {
//                if([str isEqualToString:[brandsArray objectAtIndex:i]])
//                {
//                    [btn setEnabled:YES];
//                    break;
//                }
//                else
//                {
//                    [btn setEnabled:NO];
//                }
//            }
//            if(brandsArray.count == 0)
//            {
//                [btn setEnabled:NO];
//            }
//        }

        
    }
    
#pragma mark - 型号数组
    array3 = [[NSMutableArray alloc] init];
    for(int i=0;i<[[_ScreeningCondition objectAtIndex:1] count];i++)
    {
        NSString *modelStr = [NSString stringWithFormat:@"%@",[[_ScreeningCondition objectAtIndex:1] objectAtIndex:i]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setNumberOfLines:0];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn setTitle:modelStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(modelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn setTag:1];
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array3 addObject:btn];
        
        int yu = i%3;
        CGFloat originX = 0.0;
        
        
        if(yu == 0)
        {
            originX = 5*1 + btnWidth*0 + 5;
        }
        if(yu == 1)
        {
            originX = 5*2 + btnWidth*1 - 5;
        }
        if(yu == 2)
        {
            originX = 5*3 + btnWidth*2 - 15;
        }
        
        
        int chu = i/3;
        CGFloat originY = 5*(chu+1) + 30*chu;
        [btn setFrame:CGRectMake(originX,originY, btnWidth-20, 30)];

   
    }
    
#pragma mark - 横截面数组
    array4 = [[NSMutableArray alloc] init];
    for(int i=0;i<[[_ScreeningCondition objectAtIndex:2] count];i++)
    {
        NSString *specStr = [NSString stringWithFormat:@"%@平方",[[_ScreeningCondition objectAtIndex:2] objectAtIndex:i]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setNumberOfLines:0];
        [btn setTitle:specStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn setEnabled:YES];
        
        [btn addTarget:self action:@selector(specBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setCornerRadius:2.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn setTag:3];
        btn.layer.borderColor = [[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]CGColor];
        [array4 addObject:btn];
        
        int yu = i%3;
        CGFloat originX = 0.0;
        
        
        if(yu == 0)
        {
            originX = 5*1 + btnWidth*0 + 5;
        }
        if(yu == 1)
        {
            originX = 5*2 + btnWidth*1 - 5;
        }
        if(yu == 2)
        {
            originX = 5*3 + btnWidth*2 - 15;
        }
        
        
        int chu = i/3;
        CGFloat originY = 5*(chu+1) + 30*chu;
        [btn setFrame:CGRectMake(originX,originY, btnWidth-20, 30)];
        

    }    
    _myDic = [[NSDictionary alloc] initWithObjectsAndKeys:
              array1,@"用途",
              array2,@"品牌",
              array3,@"型号",
              array4,@"横截面",nil];
    
    ivArray = [[NSMutableArray alloc] init];
   
    for(int i=0;i<[[_myDic allKeys] count];i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 23, 27)];
        [iv setImage:[UIImage imageNamed:@"askPriceCar"]];
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

        showUseCell = NO;
        showModelCell = NO;
        showSpecCell = NO;
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
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor brownColor];
    
    brandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//   [brandBtn setTitle:brandString forState:UIControlStateNormal];
     [brandBtn setFrame:CGRectMake(myRect.size.width-160, 5, 80, 30)];
    [brandBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [brandBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    brandBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    brandBtn.layer.borderWidth = 1.0f;
    [brandBtn setTag:0];
    [brandBtn setHidden:YES];
    
    
    brandBtn_0 = [[UIButton alloc] init];
    useCloseIV = [UIImage imageNamed:@"close_btn"];
    [brandBtn_0 setBackgroundImage:useCloseIV forState:UIControlStateNormal];
    [brandBtn_0 setFrame:CGRectMake(myRect.size.width-80, 5, 30, 30)];
    brandBtn_0.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [brandBtn_0 addTarget:self action:@selector(branBtnMet_0:) forControlEvents:UIControlEventTouchUpInside];
    brandBtn_0.layer.borderWidth = 1.0f;
    [brandBtn_0 setTag:0];
    [brandBtn_0 setHidden:YES];

    modelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modelBtn setFrame:CGRectMake(myRect.size.width-160, 5, 80, 30)];
//    [modelBtn setTitle:modelString forState:UIControlStateNormal];
    [modelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [modelBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    modelBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    modelBtn.layer.borderWidth = 1.0f;
   [modelBtn setTag:1];
    [modelBtn setHidden:YES];
    
    
    modelBtn_1 = [[UIButton alloc] init];
    useCloseIV_1 = [UIImage imageNamed:@"close_btn"];
    [modelBtn_1 setBackgroundImage:useCloseIV_1 forState:UIControlStateNormal];
    [modelBtn_1 setFrame:CGRectMake(myRect.size.width-80, 5, 30, 30)];
    modelBtn_1.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [modelBtn_1 addTarget:self action:@selector(modelBtnMet_1:) forControlEvents:UIControlEventTouchUpInside];
    modelBtn_1.layer.borderWidth = 1.0f;
    [modelBtn_1 setTag:1];
    [modelBtn_1 setHidden:YES];

    
    useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [useBtn setFrame:CGRectMake(myRect.size.width-160, 5, 80, 30)];
    [useBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [useBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    useBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    useBtn.layer.borderWidth = 1.0f;
    [useBtn setTag:2];
    [useBtn setHidden:YES];
    
    
    useBtn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    useCloseIV_2 = [UIImage imageNamed:@"close_btn"];
    [useBtn_2 setBackgroundImage:useCloseIV_2 forState:UIControlStateNormal];
    [useBtn_2 setFrame:CGRectMake(myRect.size.width-80, 5, 30, 30)];
    useBtn_2.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [useBtn_2 addTarget:self action:@selector(useBtnMet_2:) forControlEvents:UIControlEventTouchUpInside];
     useBtn_2.layer.borderWidth = 1.0f;
    [useBtn_2 setTag:2];
    [useBtn_2 setHidden:YES];

    specBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [specBtn setFrame:CGRectMake(myRect.size.width-160, 5, 80, 30)];
    [specBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [specBtn setTitleColor:[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    specBtn.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
     specBtn.layer.borderWidth = 1.0f;
    [specBtn setTag:3];
    [specBtn setHidden:YES];
    
   
    specBtn_3 = [[UIButton alloc] init];
    useCloseIV_3 = [UIImage imageNamed:@"close_btn"];
    [specBtn_3 setBackgroundImage:useCloseIV_3 forState:UIControlStateNormal];
    [specBtn_3 setFrame:CGRectMake(myRect.size.width-80, 5, 30, 30)];
    specBtn_3.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:54.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [specBtn_3 addTarget:self action:@selector(specBtnMet_3:) forControlEvents:UIControlEventTouchUpInside];
    specBtn_3.layer.borderWidth = 1.0f;
    [specBtn_3 setTag:3];
    [specBtn_3 setHidden:YES];
   
    triangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"askPriceCar"]];
    [triangle setTag:0];
    
    triangle_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"askPriceCar"]];
    [triangle_1 setTag:1];
    
    triangle_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"askPriceCar"]];
    [triangle_2 setTag:2];
    
    triangle_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"askPriceCar"]];
    [triangle_3 setTag:3];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView:) name:@"closeChooseView" object:nil];
}

- (void)branBtnMet_0:(UIButton *)button
{
    int sectionIndex = ((UIButton*)button).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    [brandBtn setHidden:YES];
    [brandBtn_0 setHidden:YES];
    brandString = @"";
    showBrandCell = YES;
    [triangle setHidden:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brand_save"];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
    
}

- (void)modelBtnMet_1:(UIButton *)button
{
    int sectionIndex = ((UIButton*)button).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    [modelBtn setHidden:YES];
    [modelBtn_1 setHidden:YES];
    modelString = @"";
    showModelCell = YES;
    [triangle_1 setHidden:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"model_save"];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];

}

- (void)useBtnMet_2:(UIButton *)button
{
    int sectionIndex = ((UIButton*)button).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    [useBtn setHidden:YES];
    [useBtn_2 setHidden:YES];
     useString = @"";
    showUseCell = YES;
    [triangle_2 setHidden:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"use_save"];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

- (void)specBtnMet_3:(UIButton *)button
{
    int sectionIndex = ((UIButton*)button).tag;
    flag[sectionIndex] = !flag[sectionIndex];
    [specBtn setHidden:YES];
    [specBtn_3 setHidden:YES];
    specString = @"";
    showSpecCell = YES;
    [triangle_3 setHidden:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"spec_save"];
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
}

-(void)closeView:(NSNotification *)sender
{
    [self closeViewAnimations];
}

//接收点击灰色背景，关闭筛选界面_动画效果
-(void)closeViewAnimations
{
    CGRect frameRect = [[UIScreen mainScreen] bounds];
    
    int aWidth = frameRect.size.width;
    frameRect.origin.x = aWidth;
    frameRect.origin.y = 0;
    
    [UIView animateWithDuration:0.5f animations:^(void) {
        [self.view setFrame:frameRect];
    } completion:^(BOOL finished) {
//        [self.view.superview removeFromSuperview];
        self.view.superview.hidden = YES;
    }];
}

- (void) clear:(UIButton *) sender
{
//    if(headBtnArray && headBtnArray.count != 0)
//    {
        [headBtnArray removeAllObjects];
        
        showUseCell = YES;
        showModelCell = YES;
        showSpecCell = YES;
        showBrandCell = YES;
        
        brandBtn.hidden = YES;
        brandBtn_0.hidden = YES;
        modelBtn.hidden = YES;
        modelBtn_1.hidden = YES;
        useBtn.hidden = YES;
        useBtn_2.hidden = YES;
        specBtn.hidden = YES;
        specBtn_3.hidden = YES;

         triangle.hidden = NO;
         triangle_1.hidden = NO;
         triangle_2.hidden = NO;
         triangle_3.hidden = NO;
    
        useString = @"";
        modelString = @"";
        specString = @"";
        brandString = @"";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brand_save"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"model_save"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"use_save"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"spec_save"];
    
    [self loadRequestWithUse:useString WithModel:modelString WithSpec:specString WithBrand:brandString WithRequestName:@"ScreeningCondition" WithTag:0];
//    }

//    
//    // 背影view的通知事件
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadNomalData" object:nil];
}

- (void) sure:(UIButton *) sender
{
//    NSLog(@"useString = %@",useString);
//    NSLog(@"brandString = %@",brandString);
//    NSLog(@"specString = %@",specString);
//    NSLog(@"modelString = %@",modelString);
    
    if([self.delegate respondsToSelector:@selector(requestStringWithUse:WithBrand:WithSpec:WithModel:WithSeq:)])
    {
        [self.delegate requestStringWithUse:useString WithBrand:brandString WithSpec:specString WithModel:modelString WithSeq:@""];
    }
    
    //关闭筛选界面_动画效果
     [self closeViewAnimations];
    
    // 背影view的通知事件
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeBackView" object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_myDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        if(!headBtnArray || headBtnArray.count == 0)
//        {
//            return 0;
//        }
//        return 1;
//    }
	return [self numberOfRowsInSection:section];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        [[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]] count];
        UIButton *btn = (UIButton *)[[_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]] lastObject];

        if(indexPath.section == 2)
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
        if(indexPath.section == 1)
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
        if(indexPath.section == 0)
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
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if(section == 2)
    {
        if(showUseCell == YES)
        {
            
        }
        else
        {
//            return 0;
        }
    }
    if(section == 1)
    {
        if(showModelCell == YES)
        {
            
        }
        else
        {
//            return 0;
        }
    }
    if(section == 3)
    {
        if(showSpecCell == YES)
        {
            
        }
        else
        {
//            return 0;
        }
    }
    if(section == 0)
    {
        if(showBrandCell == YES)
        {
            
        }
        else
        {
//            return 0;
        }
    }
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	headClickView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myRect.size.width, 40)];
    headClickView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 39.5, myRect.size.width, 0.5);
    lineView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[headClickView addSubview:lineView];

    UIView *triangView = [[UIView alloc]init];
    triangView.frame = CGRectMake(210, 6, 28, 28);
    [headClickView addSubview:triangView];
    
    abtn = [UIButton buttonWithType:UIButtonTypeCustom];
    abtn.frame = CGRectMake(0, 0,myRect.size.width, 40);
    abtn.tag = section;
	[abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
	[headClickView addSubview:abtn];
    
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, myRect.size.width, 30)];
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
	titleLabel.text = [[_myDic allKeys] objectAtIndex:section];
    [abtn addSubview:titleLabel];
 
    switch(section)
    {
        case 0:
            [abtn addSubview:brandBtn];
            [abtn addSubview:brandBtn_0];
            [triangView addSubview:triangle];

            break;
        case 1:
            [abtn addSubview:modelBtn];
            [abtn addSubview:modelBtn_1];
            [triangView addSubview:triangle_1];

      
            break;
        case 2:
            [abtn addSubview:useBtn];
            [abtn addSubview:useBtn_2];
            [triangView addSubview:triangle_2];

            break;
        case 3:
            [abtn addSubview:specBtn];
            [abtn addSubview:specBtn_3];
            [triangView addSubview:triangle_3];
            break;
     }
	return headClickView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell setSelectionStyle:0];
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
    
//    if(indexPath.section == 0)
//    {
//        if(!headBtnArray || headBtnArray.count == 0)
//        {
//            
//        }
//        else
//        {
//           选中的btn
//            for(UIButton *btn in headBtnArray)
//            {
//                [cell.contentView addSubview:btn];
//            }
//        }
//    }
//    else
//    {
//        列表的所有Btn
        NSMutableArray *array = [_myDic valueForKey:[[_myDic allKeys] objectAtIndex:indexPath.section]];
        for(UIButton *btn in array)
        {
            [cell.contentView addSubview:btn];
        }
//    }

    return cell;
}


-(void)headerClicked:(UIButton*)sender
{
//    NSLog(@"headerClicked+++++++++++ = %d",sender.tag);
	int sectionIndex = sender.tag;
    if(sectionIndex == 0)
    {
        showBrandCell = !showBrandCell;
        flag[sectionIndex] = showBrandCell;
    }
    if(sectionIndex == 1)
    {
        showModelCell = !showModelCell;
        flag[sectionIndex] = showModelCell;
    }
    if(sectionIndex == 2)
    {
        showUseCell = !showUseCell;
        flag[sectionIndex] = showUseCell;
    }
    if(sectionIndex == 3)
    {
        showSpecCell = !showSpecCell;
        flag[sectionIndex] = showSpecCell;
    }
	UIButton *btn = sender;
//	flag[sectionIndex] = !flag[sectionIndex];
    UIImageView *iv = [ivArray objectAtIndex:sectionIndex];
    switch (sectionIndex)
    {
        case 0:
            if(!flag[sectionIndex])
                triangle.transform = CGAffineTransformMakeRotation(-M_PI);
            else
                triangle.transform = CGAffineTransformMakeRotation(0);
            break;
        case 1:
            if(!flag[sectionIndex])
                triangle_1.transform = CGAffineTransformMakeRotation(-M_PI);
            else
                triangle_1.transform = CGAffineTransformMakeRotation(0);
            break;
        case 2:
            if(!flag[sectionIndex])
                triangle_2.transform = CGAffineTransformMakeRotation(-M_PI);
            else
                triangle_2.transform = CGAffineTransformMakeRotation(0);
            break;
        case 3:
            if(!flag[sectionIndex])
                triangle_3.transform = CGAffineTransformMakeRotation(-M_PI);
            else
                triangle_3.transform = CGAffineTransformMakeRotation(0);
            break;
    }
    
    NSLog(@"flag[sectionIndex] = %d",flag[sectionIndex]);
    if(flag[sectionIndex])
	{
        btn.selected = YES;
        iv.transform = CGAffineTransformMakeRotation(M_2_PI);
	}
	else
    {
		btn.selected = NO;
        iv.transform = CGAffineTransformMakeRotation(0);
	}
    
	[tv reloadData];
}



- (int)numberOfRowsInSection:(NSInteger)section
{
	if (flag[section])
    {
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
