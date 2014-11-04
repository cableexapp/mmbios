//
//  MyShoppingListViewController.m
//  Far_East_MMB_iOS
//
//  Created by App01 on 14-9-1.
//  Copyright (c) 2014年 App01. All rights reserved.
//

#import "MyShoppingListViewController.h"
#import "UIViewController+AddPushAndPopStyle.h"
#import "MCDefine.h"
#import "DCFTopLabel.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "DCFChenMoreCell.h"
//#import "LoginViewController.h"
#import "LoginNaviViewController.h"
#import "UpOrderViewController.h"
#import "B2CShopCarListData.h"
#import "UIImageView+WebCache.h"
#import "B2CUpOrderData.h"
#import "AppDelegate.h"

@interface MyShoppingListViewController ()
{
    AppDelegate *app;

    DCFChenMoreCell *moreCell;
    
    NSMutableArray *cellBtnArray;   //cell前面选择的按钮
    
    NSMutableArray *cellImageViewArray;
    
    UIView *buttomView;
    
    
    NSMutableArray *headBtnArray;
    NSMutableArray *headLabelArray;
    
    UIButton *buttomBtn;
    
    UIButton *rightBtn;
    
    UIStoryboard *sb;
    
    NSMutableArray *dataArray;
    
    
    NSMutableArray *subtractArray;  //减数组
    NSMutableArray *addArray;  //加数组
    
    NSMutableArray *chooseGoodsArray;   //选中商品数组
    
    int total;  //dataArray里面的数目
    
    UILabel *moneyLabel;
    
    float totalMoney;
    
    int subtractNum;
    int addNum;
    
    
    int subtractBtnRow;
    int addBtnRow;
    
    int subtractBtnSection;
    int addBtnSection;
    
    UIButton *payBtn;
    
    NSMutableArray *shopIdArray;
}
@end

@implementation MyShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) buttomBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    if(chooseGoodsArray.count != 0)
    {
        [chooseGoodsArray removeAllObjects];
    }
    if(btn.selected == YES)
    {
        for(int i=0;i<headLabelArray.count;i++)
        {
            [[headBtnArray objectAtIndex:i] setSelected:YES];
            
            NSMutableArray *cellbtnArray = [cellBtnArray objectAtIndex:i];
            for(UIButton *btn in cellbtnArray)
            {
                [btn setSelected:YES];
            }
         
            NSMutableArray *goosArray = [dataArray objectAtIndex:i];
            for(B2CShopCarListData *carList in goosArray)
            {
                [chooseGoodsArray addObject:carList];
            }
        }
    }
    if(btn.selected == NO)
    {
        for(int i=0;i<headLabelArray.count;i++)
        {
            [[headBtnArray objectAtIndex:i] setSelected:NO];
            
            NSMutableArray *cellbtnArray = [cellBtnArray objectAtIndex:i];
            for(UIButton *btn in cellbtnArray)
            {
                [btn setSelected:NO];
            }
            
            if(chooseGoodsArray.count != 0)
            {
                [chooseGoodsArray removeAllObjects];
            }
        }
        
    }
    [tv reloadData];
    [self calculateTotalMoney];
    [self payBtnChange];
}

- (id) initWithDataArray:(NSArray *)arr
{
    if(self = [super init])
    {
     
        app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        
        NSString *string = [NSString stringWithFormat:@"%@%@",@"getShoppingCartList",time];
        
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/getShoppingCartList.html?"];
        NSString *pushString = nil;
        
        BOOL hasLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] boolValue];
        
        NSString *visitorid = [app getUdid];
        
        NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
   
        if(hasLogin == YES)
        {
            pushString = [NSString stringWithFormat:@"memberid=%@&token=%@",memberid,token];
        }
        else
        {
            pushString = [NSString stringWithFormat:@"visitorid=%@&token=%@",visitorid,token];
        }
        
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarGoodsMsgTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    return self;
}


- (NSString *) getMemberId
{
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    
    if(memberid.length == 0)
    {
        LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
        [self presentViewController:loginNavi animated:YES completion:nil];
        
    }
    return memberid;
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    
    int result = [[dicRespon objectForKey:@"result"] intValue];
    NSString *msg = [dicRespon objectForKey:@"msg"];
    
    if(URLTag == URLShopCarGoodsMsgTag)
    {
        if(result == 1)
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[B2CShopCarListData getListArray:[dicRespon objectForKey:@"items"]]];
            
            dataArray = [[NSMutableArray alloc] init];
            
            headLabelArray = [[NSMutableArray alloc] init];
            
            chooseGoodsArray = [[NSMutableArray alloc] init];
            
//            shopIdArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<tempArray.count;i++)
            {
                NSString *sShopName = [[tempArray objectAtIndex:i] shopId];
                if(i == 0)
                {
                    [headLabelArray addObject:sShopName];
                }
                if(i > 0)
                {
                    if([headLabelArray containsObject:sShopName] == YES)
                    {
                        
                    }
                    else
                    {
                        [headLabelArray addObject:sShopName];
                    }
                }
            }
            
            
            headBtnArray = [[NSMutableArray alloc] init];
            for(int i=0;i<headLabelArray.count;i++)
            {
                UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [headBtn setFrame:CGRectMake(5, 5, 30, 30)];
                
                [headBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
                [headBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
                [headBtn setSelected:NO];
                [headBtn setTag:i];
                [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [headBtnArray addObject:headBtn];
            }
            
            for(NSString *str in headLabelArray)
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for(B2CShopCarListData *data in tempArray)
                {
                    NSString *s = data.shopId;
                    if([s isEqualToString:str])
                    {
                        [array addObject:data];
                    }
                }
                [dataArray addObject:array];
            }
            
            
#pragma mark - 添加cell里面的btn,图片
            cellBtnArray = [[NSMutableArray alloc] init];
            cellImageViewArray = [[NSMutableArray alloc] init];
            subtractArray = [[NSMutableArray alloc] init];
            addArray = [[NSMutableArray alloc] init];
            
            for(int i = 0;i < dataArray.count;i++)
            {
                NSMutableArray *a =  [[NSMutableArray alloc] init];
                NSMutableArray *b = [[NSMutableArray alloc] init];
                NSMutableArray *c = [[NSMutableArray alloc] init];
                NSMutableArray *d = [[NSMutableArray alloc] init];
                
                for(int j=0;j<[[dataArray objectAtIndex:i] count];j++)
                {
                    UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    [cellBtn setFrame:CGRectMake(5, 45, 30, 30)];
                    
                    [cellBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
                    [cellBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
                    [cellBtn setSelected:NO];
                    [cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    //                    [cellBtn setTag:i];
                    [cellBtn setSelected:NO];
                    
                    UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(cellBtn.frame.origin.x + cellBtn.frame.size.width + 5, 5, 100, 100)];
                    
                    UIButton *subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [subtractBtn setTitle:@"-" forState:UIControlStateNormal];
                    subtractBtn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
                    subtractBtn.layer.borderWidth = 1.0f;
                    [subtractBtn addTarget:self action:@selector(subtractBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    subtractBtn.layer.masksToBounds = YES;
                    [subtractBtn setBackgroundColor:[UIColor whiteColor]];
                    [subtractBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    
                    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [addBtn setTitle:@"+" forState:UIControlStateNormal];
                    addBtn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
                    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    addBtn.layer.borderWidth = 1.0f;
                    addBtn.layer.masksToBounds = YES;
                    [addBtn setBackgroundColor:[UIColor whiteColor]];
                    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    
                    [a addObject:cellBtn];
                    
                    [b addObject:cellIv];
                    
                    [c addObject:subtractBtn];
                    
                    [d addObject:addBtn];
                }
                [cellBtnArray addObject:a];
                [cellImageViewArray addObject:b];
                [subtractArray addObject:c];
                [addArray addObject:d];
            }
            total = 0;
            for(int i=0;i<dataArray.count;i++)
            {
                NSMutableArray *arr = [dataArray objectAtIndex:i];
                total = total + arr.count;
            }
            
            
            [tv reloadData];
        }
        else if (result == 0)
        {
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLShopCarsubtractTag)
    {
        if(result == 0)
        {
            subtractNum = subtractNum +1;
            
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
            }
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"操作失败"];
            }
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            B2CShopCarListData *data =  [[dataArray objectAtIndex:subtractBtnSection] objectAtIndex:subtractBtnRow];
            data.num = [NSString stringWithFormat:@"%d",subtractNum];
            
            [self calculateTotalMoney];
            
            [tv reloadData];
        }
        
        B2CShopCarListData *data =  [[dataArray objectAtIndex:subtractBtnSection] objectAtIndex:subtractBtnRow];
        data.num = [NSString stringWithFormat:@"%d",subtractNum];
        
    }
    if(URLTag == URLShopCarAddTag)
    {
        if(result == 0)
        {
            addNum = addNum -1;
            
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
            }
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"操作失败"];
            }
        }
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
            B2CShopCarListData *data =  [[dataArray objectAtIndex:addBtnSection] objectAtIndex:addBtnRow];
            data.num = [NSString stringWithFormat:@"%d",addNum];
            
            
            [self calculateTotalMoney];
            [tv reloadData];
        }
        
        B2CShopCarListData *data =  [[dataArray objectAtIndex:addBtnSection] objectAtIndex:addBtnRow];
        data.num = [NSString stringWithFormat:@"%d",addNum];
        
    }
    if(URLTag == URLShopCarDeleteTag)
    {
        if(result == 1)
        {
            [DCFStringUtil showNotice:msg];
            
   
            for(int i=0;i<cellBtnArray.count;i++)
            {
                NSMutableArray *arr = [cellBtnArray objectAtIndex:i];
                
                
                for(int j=arr.count-1;j>=0;j--)
                {
                    UIButton *btn = [arr objectAtIndex:j];
                    int row = btn.tag%1000;
                    int section = btn.tag/1000;
                    if(btn.selected == YES)
                    {
                        B2CShopCarListData *car = [[dataArray objectAtIndex:section] objectAtIndex:row];
                        
                        NSMutableArray *data = [dataArray objectAtIndex:section];
                        [data removeObject:car];
                        
                        [chooseGoodsArray removeObject:car];
                        
                        UIImageView *cellIv = [[cellImageViewArray objectAtIndex:section] objectAtIndex:row];
                        [[cellImageViewArray objectAtIndex:section] removeObject:cellIv];
                        
                        
                        UIButton *subBtn = [[subtractArray objectAtIndex:section] objectAtIndex:row];
                        [[subtractArray objectAtIndex:section] removeObject:subBtn];
                        
                        
                        UIButton *addBtn = [[addArray objectAtIndex:section] objectAtIndex:row];
                        [[addArray objectAtIndex:section] removeObject:addBtn];
                        
                        UIButton *cellBtn = [[cellBtnArray objectAtIndex:section] objectAtIndex:row];
                        [[cellBtnArray objectAtIndex:section] removeObject:cellBtn];
                    }
                }
            }
            
            total = 0;
            for( int i=0;i<dataArray.count;i++)
            {
                NSMutableArray *array = [dataArray objectAtIndex:i];
                if(array.count == 0)
                {
                    [rightBtn setHidden:YES];
                }
                else
                {
                    [rightBtn setHidden:NO];
                }
                total = total + array.count;
            }
            
            
            
            for(int i=dataArray.count-1;i>=0;i--)
            {
                if([[dataArray objectAtIndex:i] count] == 0)
                {
                    [headLabelArray removeObjectAtIndex:i];
                    
                    [headBtnArray removeObjectAtIndex:i];
                }
            }
            
            
            if(total == 0)
            {
                [dataArray removeAllObjects];
                dataArray = nil;
            }
            
  
            
            [moneyLabel setText:[DCFCustomExtra notRounding:0.00 afterPoint:2]];
            
            [buttomBtn setSelected:NO];
            [tv reloadData];
            [self payBtnChange];
        }
        else
        {
            if(msg.length == 0)
            {
                [DCFStringUtil showNotice:@"删除失败"];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLCartConfirmTag)
    {
        if(result == 1)
        {
            B2CUpOrderData *orderData = [[B2CUpOrderData alloc] initWithDataDic:dicRespon];
            [self setHidesBottomBarWhenPushed:YES];
            UpOrderViewController *order = [[UpOrderViewController alloc] initWithDataArray:chooseGoodsArray WithMoney:totalMoney WithOrderData:orderData WithTag:1];
            [self.navigationController pushViewController:order animated:YES];
            
        }
        else if (result == 0)
        {
            if(msg.length != 0)
            {
                [DCFStringUtil showNotice:msg];
            }
            else
            {
                [DCFStringUtil showNotice:@"结算失败"];
            }
        }
    }
}

- (void) subtractBtnClick:(UIButton *) sender
{

    subtractBtnRow = sender.tag%1000;
    subtractBtnSection = sender.tag/1000;
    
    UIButton *btn = [[cellBtnArray objectAtIndex:subtractBtnSection] objectAtIndex:subtractBtnRow];
    if(btn.selected == NO)
    {
        [DCFStringUtil showNotice:@"请先选择商品"];
        return;
    }
    else
    {
        B2CShopCarListData *carListData = [[dataArray objectAtIndex:subtractBtnSection] objectAtIndex:subtractBtnRow];
        
        subtractNum = [carListData.num intValue];
        if(subtractNum <= 0)
        {
            [DCFStringUtil showNotice:@"不能小于0"];
            subtractNum = 0;
            return;
        }
        else
        {
            subtractNum = subtractNum - 1;
        }
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        
        NSString *string = [NSString stringWithFormat:@"%@%@",@"UpdateShoppingCart",time];
        
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UpdateShoppingCart.html?"];
        
        NSString *pushNum = [NSString stringWithFormat:@"%d",subtractNum];
        
        NSString  *pushString = [NSString stringWithFormat:@"cartid=%@&itemnum=%@&token=%@",carListData.itemId,pushNum,token];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarsubtractTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        
    }
}


- (void) addBtnClick:(UIButton *) sender
{
    addBtnRow = sender.tag%1000;
    addBtnSection = sender.tag/1000;
    
    UIButton *btn = [[cellBtnArray objectAtIndex:addBtnSection] objectAtIndex:addBtnRow];
    if(btn.selected == NO)
    {
        [DCFStringUtil showNotice:@"请先选择商品"];
        return;
    }
    else
    {
        B2CShopCarListData *carListData = [[dataArray objectAtIndex:addBtnSection] objectAtIndex:addBtnRow];
        addNum = [carListData.num intValue];
        addNum = addNum + 1;
        
        
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        
        NSString *string = [NSString stringWithFormat:@"%@%@",@"UpdateShoppingCart",time];
        
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/UpdateShoppingCart.html?"];
        
        NSString *pushNum = [NSString stringWithFormat:@"%d",addNum];
        
        NSString  *pushString = [NSString stringWithFormat:@"cartid=%@&itemnum=%@&token=%@",carListData.itemId,pushNum,token];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarAddTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
    
   
    
    //    [tv reloadData];
    //    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
    //    NSArray *arr = [NSArray arrayWithObject:path];
    //    [tv reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}

- (void) payBtnChange
{
    NSString *btnTitle = [NSString stringWithFormat:@"结算(%d)",chooseGoodsArray.count];
    [payBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pushAndPopStyle];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //    [moreCell startAnimation];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"家装馆购物车"];
    self.navigationItem.titleView = top;
    
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateHighlighted];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 13, 34, 25)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, 320, 54)];
    [buttomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:buttomView];
    
    UIView *buttomTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [buttomTopView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [buttomView addSubview:buttomTopView];
    
    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttomBtn setFrame:CGRectMake(5, 13, 30, 30)];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
    [buttomBtn setSelected:NO];
    [buttomBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:buttomBtn];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 50, 30)];
    [countLabel setTextColor:[UIColor blackColor]];
    [countLabel setTextAlignment:NSTextAlignmentLeft];
    [countLabel setText:@"合计 ¥"];
    [buttomView addSubview:countLabel];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x + countLabel.frame.size.width+5, 13, 100, 30)];
    [moneyLabel setTextColor:[UIColor redColor]];
    totalMoney = 0.00;
    [moneyLabel setText:[DCFCustomExtra notRounding:totalMoney afterPoint:2]];
    [moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [buttomView addSubview:moneyLabel];
    
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setFrame:CGRectMake(moneyLabel.frame.origin.x + moneyLabel.frame.size.width + 10, 10, 100, 34)];
    payBtn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    payBtn.layer.borderWidth = 1.0f;
    payBtn.layer.cornerRadius = 2.0f;
    payBtn.layer.masksToBounds = YES;
    [self payBtnChange];
    [payBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:payBtn];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 54-54)];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [self.view addSubview:tv];
    
}


#pragma mark - section里面的按钮点击事件
- (void) headBtnClick:(UIButton *) sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected = !btn.selected;
    
    int tag = [sender tag];
    
    NSMutableArray *array = [cellBtnArray objectAtIndex:tag];
    
    NSMutableArray *a = [dataArray objectAtIndex:tag];
    
    
    if(btn.selected == YES)
    {
        for(UIButton *b in array)
        {
            [b setSelected:YES];
        }
        
        if(chooseGoodsArray.count == 0)
        {
            for(int i=0;i<a.count;i++)
            {
                [chooseGoodsArray addObject:[a objectAtIndex:i]];
            }
        }
        else
        {
            for(int i=0;i<a.count;i++)
            {
                B2CShopCarListData *data = [a objectAtIndex:i];
                for(int j=0;j<chooseGoodsArray.count;j++)
                {
                    B2CShopCarListData *carList  = [chooseGoodsArray objectAtIndex:j];
                    if(data == carList)
                    {
                        
                    }
                    else
                    {
                        [chooseGoodsArray addObject:data];
                    }
                }
            }
            
#pragma mark - 去掉重复元素
            NSSet *set = [NSSet setWithArray:chooseGoodsArray];
            
            if(chooseGoodsArray.count != 0)
            {
                [chooseGoodsArray removeAllObjects];
            }
            for(int i=0;i<[[set allObjects] count];i++)
            {
                [chooseGoodsArray addObject:[[set allObjects] objectAtIndex:i]];
            }
            
        }
 
    }
    else
    {
        [buttomBtn setSelected:NO];
        for(UIButton *b in array)
        {
            [b setSelected:NO];
        }
        if(chooseGoodsArray.count == 0)
        {
            
        }
        else
        {
            for(int i=0;i<a.count;i++)
            {
                B2CShopCarListData *data = [a objectAtIndex:i];
                for(int j=0;j<chooseGoodsArray.count;j++)
                {
                    B2CShopCarListData *carList  = [chooseGoodsArray objectAtIndex:j];
                    if(data == carList)
                    {
                        [chooseGoodsArray removeObject:data];
                    }
                    else
                    {
                        
                    }
                }
            }
            
        }
        
        
    }
    
    if(chooseGoodsArray.count == total)
    {
        [buttomBtn setSelected:YES];
    }
    else
    {
        [buttomBtn setSelected:NO];
    }
    [self calculateTotalMoney];
    [self payBtnChange];
}

- (void) payBtnClick:(UIButton *) sender
{
    if(!chooseGoodsArray || chooseGoodsArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择商品"];
        return;
    }
    
    
    NSString *items = nil;
    
    
    if(chooseGoodsArray && chooseGoodsArray.count != 0)
    {
        for(int i=0;i<chooseGoodsArray.count;i++)
        {
            B2CShopCarListData *data = [chooseGoodsArray objectAtIndex:i];
            if(i == 0)
            {
                items = [NSString stringWithFormat:@"%@,",data.itemId];
            }
            else
            {
                items = [items stringByAppendingString:[NSString stringWithFormat:@"%@,",data.itemId]];
            }
        }
        items = [items substringWithRange:NSMakeRange(0, items.length-1)];
    }
    
    NSString *time = [DCFCustomExtra getFirstRunTime];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",@"cartConfirm",time];
    
    NSString *token = [DCFCustomExtra md5:string];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/cartConfirm.html?"];
    NSString *pushString = nil;
    

    if([[self getMemberId] length] == 0 || [[self getMemberId] isKindOfClass:[NSNull class]])
    {
        
    }
    else
    {
        pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&coloritem=%@",[self getMemberId],token,items];
        
        
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLCartConfirmTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    }
  
    
    
}


- (NSArray*)getSortArrForMainApp:(NSArray*)arrSrc {
    NSArray* arrDes = [arrSrc sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //change your code
        NSString *value1 = obj1;
        NSString *value2 = obj2;
        return value1.intValue < value2.intValue ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    return arrDes;
}



NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};


- (NSMutableArray *) sort:(NSMutableArray *) arr
{
    for(int i=0;i<arr.count;i++)
    {
        for(int j=0;j<arr.count-1-i;j++)
        {
            if([arr[j+1] intValue] >= [arr[j] intValue])
            {
                int temp = [arr[j] intValue];
                arr[j] = arr[j+1];
                arr[j+1] = [NSNumber numberWithInt:temp];
            }
        }
    }
    return arr;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        
        NSString *items = nil;
        if(chooseGoodsArray && chooseGoodsArray.count != 0)
        {
            for(int i=0;i<chooseGoodsArray.count;i++)
            {
                B2CShopCarListData *data = [chooseGoodsArray objectAtIndex:i];
                if(i == 0)
                {
                    items = [NSString stringWithFormat:@"%@,",data.itemId];
                }
                else
                {
                    items = [items stringByAppendingString:[NSString stringWithFormat:@"%@,",data.itemId]];
                }
            }
            items = [items substringWithRange:NSMakeRange(0, items.length-1)];
        }
        
        NSString *time = [DCFCustomExtra getFirstRunTime];
        
        NSString *string = [NSString stringWithFormat:@"%@%@",@"deleteCartItems",time];
        
        NSString *token = [DCFCustomExtra md5:string];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/deleteCartItems.html?"];
        
        
        NSString  *pushString = [NSString stringWithFormat:@"cartids=%@&token=%@",items,token];
        
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLShopCarDeleteTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        
    }
}

#pragma mark - 删除
- (void) rightBtnClick:(id) sender
{
    if(chooseGoodsArray && chooseGoodsArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择要删除的商品"];
        return;
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要删除么" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(dataArray)
    {
        for(NSMutableArray *testArr in dataArray)
        {
            if(testArr.count == 0)
            {
                return 0;
            }
        }
        if(dataArray.count == 0)
        {
            return 0;
        }
    }
    
    if(!dataArray)
    {
        return 0;
    }
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!dataArray || dataArray.count == 0)
    {
        return ScreenHeight - 34;
    }
    if(dataArray && [[dataArray objectAtIndex:indexPath.section] count] != 0)
    {
        NSString *content = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] productItmeTitle];
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:content WithSize:CGSizeMake(160, MAXFLOAT)];
        if(size.height + 50 <= 100)
        {
            return 110;
        }
        else
        {
            return size.height + 50;
        }
    }
    return ScreenHeight - 34;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!headLabelArray || headLabelArray.count == 0)
    {
        return 1;
    }
    return headLabelArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return [[dataArray objectAtIndex:section] count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [view addSubview:[headBtnArray objectAtIndex:section]];
    
    NSString *title = [[[dataArray objectAtIndex:section] lastObject] sShopName];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
//    [sectionLabel setText:[headLabelArray objectAtIndex:section]];
    [sectionLabel setText:title];
    [sectionLabel setTextAlignment:NSTextAlignmentLeft];
    [sectionLabel setTextColor:[UIColor blackColor]];
    [sectionLabel setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:sectionLabel];
    
    return view;
}

- (void) logBtnClick:(UIButton *) sender
{
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];
}


- (void) buyBtnClick:(UIButton *) sender
{
}

- (UITableViewCell *) loadNonDataTableview:tableView NoIndexPath:indexPath
{
    static NSString *moreCellId = @"moreCell";
    UITableViewCell *noCell = [tableView cellForRowAtIndexPath:indexPath];
    if(!noCell)
    {
        noCell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:moreCellId];
        [noCell.contentView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.masksToBounds = YES;
    [noCell.contentView addSubview:view];
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    logBtn.layer.borderWidth = 1.0F;
    logBtn.layer.borderColor = [UIColor blueColor].CGColor;
    logBtn.layer.cornerRadius = 5;
    [logBtn setFrame:CGRectMake(10, 10, 70, 40)];
    [logBtn addTarget:self action:@selector(logBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logBtn];
    
    UILabel *label_1 = [[UILabel alloc] initWithFrame:CGRectMake(logBtn.frame.origin.x + logBtn.frame.size.width + 15, logBtn.frame.origin.y, 200, 40)];
    [label_1 setBackgroundColor:[UIColor clearColor]];
    [label_1 setTextAlignment:NSTextAlignmentLeft];
    [label_1 setFont:[UIFont systemFontOfSize:12]];
    [label_1 setTextColor:[UIColor blackColor]];
    [label_1 setNumberOfLines:0];
    [label_1 setText:@"登陆后可以同步电脑和手机端的商品,并保存在账户中"];
    [view addSubview:label_1];
    
    
    NSString *string = @"您的购物车中暂时没有商品,现在去浏览选购商品~";
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:string WithSize:CGSizeMake(200, MAXFLOAT)];
    UILabel *label_2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 150, 200, size.height)];
    [label_2 setBackgroundColor:[UIColor clearColor]];
    [label_2 setTextAlignment:NSTextAlignmentLeft];
    [label_2 setFont:[UIFont systemFontOfSize:15]];
    [label_2 setTextColor:[UIColor blackColor]];
    [label_2 setNumberOfLines:0];
    [label_2 setText:string];
    [noCell.contentView addSubview:label_2];
    
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setFrame:CGRectMake(100, label_2.frame.origin.y + label_2.frame.size.height + 50, 120, 40)];
    [buyBtn setTitle:@"选购商品" forState:UIControlStateNormal];
    buyBtn.layer.borderColor = [UIColor blueColor].CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.layer.cornerRadius = 5.0f;
    [buyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [noCell.contentView addSubview:buyBtn];
    
    return noCell;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray)
    {
        for(int i=0;i<dataArray.count;i++)
        {
            NSMutableArray *arr = [dataArray objectAtIndex:i];
            if(arr.count == 0 && i == dataArray.count-1)
            {
                return [self loadNonDataTableview:tableView NoIndexPath:indexPath];
            }
        }
    }
    
    if(!dataArray || dataArray.count == 0)
    {
        return [self loadNonDataTableview:tableView NoIndexPath:indexPath];
    }
    
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    
    UIButton *cellBtn = [[cellBtnArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cellBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:cellBtn];
    
    UIImageView *cellIv = [[cellImageViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] productItemPic]];
    [cellIv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
    [cell.contentView addSubview:cellIv];
    
    NSString *content = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] productItmeTitle];
    CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:content WithSize:CGSizeMake(160, MAXFLOAT)];
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellIv.frame.origin.x + cellIv.frame.size.width + 5, 5, 160, size.height)];
    [introduceLabel setTextAlignment:NSTextAlignmentLeft];
    [introduceLabel setTextColor:[UIColor blackColor]];
    [introduceLabel setNumberOfLines:0];
    [introduceLabel setFont:[UIFont systemFontOfSize:12]];
    [introduceLabel setText:content];
    [cell.contentView addSubview:introduceLabel];
    
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(introduceLabel.frame.origin.x, introduceLabel.frame.origin.y + introduceLabel.frame.size.height + 10, 30, 20)];
    [countLabel setText:@"数量:"];
    [countLabel setTextAlignment:NSTextAlignmentLeft];
    [countLabel setTextColor:[UIColor blackColor]];
    [countLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:countLabel];
    
    
    float x = countLabel.frame.origin.x + countLabel.frame.size.width + 10;
    float y = countLabel.frame.origin.y;
    
    UIButton *subBtn = [[subtractArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [subBtn setFrame:CGRectMake(x,y,30, 30)];
    [subBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:subBtn];
    
    UIButton *addBtn = [[addArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [addBtn setFrame:CGRectMake(x+90, y, 30, 30)];
    [addBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:addBtn];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [numLabel setFrame:CGRectMake(x+35, y, 50, 30)];
    [numLabel setText:[[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] num]];
    [numLabel setTextAlignment:NSTextAlignmentCenter];
    [numLabel setTextColor:[UIColor blackColor]];
    numLabel.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    numLabel.layer.borderWidth = 1.0f;
    numLabel.layer.masksToBounds = YES;
    [numLabel setBackgroundColor:[UIColor whiteColor]];
    
    [cell.contentView addSubview:numLabel];
    
    
    return cell;
    //    }
    return nil;
}

#pragma mark - cell里面的选择按钮点击事件
- (void) cellBtnClick:(UIButton *) sender
{
    sender.selected = !sender.selected;
    
    
    int row = sender.tag%1000;
    int section = sender.tag/1000;
    
    B2CShopCarListData *carListData = [[dataArray objectAtIndex:section] objectAtIndex:row];
    
    if(sender.selected == YES)
    {
        if([chooseGoodsArray containsObject:carListData] == YES)
        {
            
        }
        else
        {
            [chooseGoodsArray addObject:carListData];
        }
    }
    else if (sender.selected == NO)
    {
        if([chooseGoodsArray containsObject:carListData] == YES)
        {
            [chooseGoodsArray removeObject:carListData];
        }
        else
        {
            
        }
    }
    
    int count = 0;
    
    for(int i=0;i<[[dataArray objectAtIndex:section] count];i++)
    {
        for(B2CShopCarListData *data in chooseGoodsArray)
        {
            if(data == [[dataArray objectAtIndex:section] objectAtIndex:i])
            {
                count++;
            }
        }
    }
    if(count == [[dataArray objectAtIndex:section] count])
    {
        [[headBtnArray objectAtIndex:section] setSelected:YES];
    }
    else
    {
        [[headBtnArray objectAtIndex:section] setSelected:NO];
    }
    

    
    NSLog(@"chooseGoodsArray = %@",chooseGoodsArray);
    [self calculateTotalMoney];
    [self payBtnChange];
    
    for(UIButton *btn in headBtnArray)
    {
        if(btn.selected == YES)
        {
            [buttomBtn setSelected:YES];
        }
        else if (btn.selected == NO)
        {
            [buttomBtn setSelected:NO];
            return;
        }
    }
}

#pragma mark - 计算总价
- (void) calculateTotalMoney
{
    totalMoney = 0.00;
    
    for (int i=0; i<chooseGoodsArray.count; i++)
    {
        B2CShopCarListData *carlist = [chooseGoodsArray objectAtIndex:i];
        NSString *price = carlist.price;
        totalMoney = [price floatValue]*[carlist.num intValue] + totalMoney;
    }
    
    
    [moneyLabel setText:[NSString stringWithFormat:@"%.2f",totalMoney]];
    [moneyLabel setText:[DCFCustomExtra notRounding:totalMoney afterPoint:2]];
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