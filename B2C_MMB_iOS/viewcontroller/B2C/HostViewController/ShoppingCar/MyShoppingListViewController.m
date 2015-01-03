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
#import "ShoppingHostViewController.h"
#import "GoodsDetailViewController.h"
#import "ShopHostTableViewController.h"

@interface MyShoppingListViewController ()
{
    AppDelegate *app;
    
    DCFChenMoreCell *moreCell;
    
    NSMutableArray *cellBtnArray;   //cell前面选择的按钮
    
    NSMutableArray *cellImageViewArray;
    
    NSMutableArray *priceLabelArray;
    
    NSMutableArray *colorLabelArray;
    
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
    
    double totalMoney;
    
    int subtractNum;
    int addNum;
    
    
    int subtractBtnRow;
    int addBtnRow;
    
    int subtractBtnSection;
    int addBtnSection;
    
    UIButton *payBtn;
    
    NSMutableArray *shopIdArray;
    
    BOOL flag;  //商品数组section是否为空
    
    UIView *backView;
    UILabel *label_1;
    
    UIImageView *shopcarView;
    
    UILabel *label_2;
    
    UIButton *buyBtn;
    UIView *loginView;
    UIButton *logBtn;
    
    UILabel *countLabel;
    
    NSMutableArray *tempArray;
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    for(UIView *view in self.navigationController.navigationBar.subviews)
    {
        if([view tag] == 100 || [view tag] == 101 )
        {
            [view setHidden:YES];
        }
    }
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"global_delete"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    if(buttomBtn)
    {
        [buttomBtn setSelected:NO];
    }
    [self loadRequest];
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
        for(int i=0;i<dataArray.count;i++)
        {
            [[[headBtnArray objectAtIndex:i] lastObject] setSelected:YES];
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
        for(int i=0;i<dataArray.count;i++)
        {
            [[[headBtnArray objectAtIndex:i] lastObject] setSelected:NO];
            
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

- (void) loadRequest
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

- (id) initWithDataArray:(NSArray *)arr
{
    if(self = [super init])
    {
        //        [self loadRequest];
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
    
    if(URLTag == URLValidProductBeforeSubOrderTag)
    {
        if(result == 1)
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

            NSString *string = [NSString stringWithFormat:@"%@%@",@"cartConfirm",time];

            NSString *token = [DCFCustomExtra md5:string];

            NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/cartConfirm.html?"];
            NSString *pushString = nil;

            pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&coloritem=%@",[self getMemberId],token,items];
            conn = [[DCFConnectionUtil alloc] initWithURLTag:URLCartConfirmTag delegate:self];
            [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        }
        else
        {
            if([DCFCustomExtra validateString:msg] == NO)
            {
//                [DCFStringUtil showNotice:msg];
            }
            else
            {
                [DCFStringUtil showNotice:msg];
            }
        }
    }
    if(URLTag == URLShopCarGoodsMsgTag)
    {
        if(_reloading == YES)
        {
            [self doneLoadingViewData];
        }
        else if(_reloading == NO)
        {
            
        }
        
        if(result == 1)
        {
            if(!tempArray || tempArray.count == 0)
            {
                tempArray = [[NSMutableArray alloc] initWithArray:[B2CShopCarListData getListArray:[dicRespon objectForKey:@"items"]]];
                
                dataArray = [[NSMutableArray alloc] init];
                
                headLabelArray = [[NSMutableArray alloc] init];
                
                chooseGoodsArray = [[NSMutableArray alloc] init];
                
                for(int i=0;i<tempArray.count;i++)
                {
                    NSString *sShopName = [[tempArray objectAtIndex:i] shopId];
                    NSMutableArray *shopNameArray = [NSMutableArray arrayWithObject:sShopName];
                    if(i == 0)
                    {
                        [headLabelArray addObject:shopNameArray];
                    }
                    if(i > 0)
                    {
                        if([headLabelArray containsObject:shopNameArray] == YES)
                        {
                            
                        }
                        else
                        {
                            [headLabelArray addObject:shopNameArray];
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
                    NSMutableArray *arr = [NSMutableArray arrayWithObject:headBtn];
                    
                    [headBtnArray addObject:arr];
                }
                
                for(NSArray *str in headLabelArray)
                {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    for(B2CShopCarListData *data in tempArray)
                    {
                        NSString *s = data.shopId;
                        if([s isEqualToString:(NSString *)[str lastObject]])
                        {
                            [array addObject:data];
                        }
                    }
                    [dataArray addObject:array];
                }
                
                
                if (dataArray.count > 0)
                {
                    backView.hidden = YES;
                    tv.scrollEnabled = YES;
                }
                else
                {
                    backView.hidden = NO;
                    tv.scrollEnabled = NO;
                }
                
                cellBtnArray = [[NSMutableArray alloc] init];
                cellImageViewArray = [[NSMutableArray alloc] init];
                subtractArray = [[NSMutableArray alloc] init];
                addArray = [[NSMutableArray alloc] init];
                priceLabelArray = [[NSMutableArray alloc] init];
                colorLabelArray = [[NSMutableArray alloc] init];
                
                for(int i = 0;i < dataArray.count;i++)
                {
                    NSMutableArray *a =  [[NSMutableArray alloc] init];
                    NSMutableArray *b = [[NSMutableArray alloc] init];
                    NSMutableArray *c = [[NSMutableArray alloc] init];
                    NSMutableArray *d = [[NSMutableArray alloc] init];
                    NSMutableArray *e = [[NSMutableArray alloc] init];
                    NSMutableArray *f = [[NSMutableArray alloc] init];
                    
                    for(int j=0;j<[[dataArray objectAtIndex:i] count];j++)
                    {
                        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [cellBtn setTag:1000*i+j];
                        [cellBtn setFrame:CGRectMake(5, 40, 30, 30)];
                        
                        [cellBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
                        [cellBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
                        [cellBtn setSelected:NO];
                        [cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        //                    [cellBtn setTag:i];
                        [cellBtn setSelected:NO];
                        
                        UIImageView *cellIv = [[UIImageView alloc] initWithFrame:CGRectMake(cellBtn.frame.origin.x + cellBtn.frame.size.width + 10, 20, 70, 70)];
                        
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
                        
                        UILabel *subPriceLabel = [[UILabel alloc] init];
                        [subPriceLabel setText:@"单价:"];
                        [subPriceLabel setFont:[UIFont systemFontOfSize:12]];
                        
                        UILabel *subColorLabel = [[UILabel alloc] init];
                        [subColorLabel setFont:[UIFont systemFontOfSize:12]];
                        
                        [a addObject:cellBtn];
                        
                        [b addObject:cellIv];
                        
                        [c addObject:subtractBtn];
                        
                        [d addObject:addBtn];
                        
                        [e addObject:subPriceLabel];
                        
                        [f addObject:subColorLabel];
                    }
                    [cellBtnArray addObject:a];
                    [cellImageViewArray addObject:b];
                    [subtractArray addObject:c];
                    [addArray addObject:d];
                    [priceLabelArray addObject:e];
                    [colorLabelArray addObject:f];
                }
                total = 0;
                for(int i=0;i<dataArray.count;i++)
                {
                    NSMutableArray *arr = [dataArray objectAtIndex:i];
                    total = total + arr.count;
                }
            }
            else
            {
                
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
//            [DCFStringUtil showNotice:msg];
            
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
//            [DCFStringUtil showNotice:msg];
            
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
            
            for(int i=cellBtnArray.count-1;i>=0;i--)
            {
                NSMutableArray *arr = [cellBtnArray objectAtIndex:i];

                for(int j=arr.count-1;j>=0;j--)
                {
                    UIButton *btn = [arr objectAtIndex:j];

                    int row = btn.tag%1000;
                    int section = btn.tag/1000;
                    if(btn.selected == YES)
                    {
                        
                        NSMutableArray *data = [dataArray objectAtIndex:section];

                        B2CShopCarListData *car = [data objectAtIndex:row];
                        
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
                        
                        UILabel *label = [[priceLabelArray objectAtIndex:section] objectAtIndex:row];
                        [[priceLabelArray objectAtIndex:section] removeObject:label];
                        
                        UILabel *colorLab = [[colorLabelArray objectAtIndex:section] objectAtIndex:row];
                        [[colorLabelArray objectAtIndex:section] removeObject:colorLab];
                    }
                }
            }
            
            total = 0;
            for( int i=0;i<dataArray.count;i++)
            {
                NSMutableArray *array = [dataArray objectAtIndex:i];
                total = total + array.count;
            }
            if(total == 0)
            {
                [rightBtn setHidden:YES];
                [dataArray removeAllObjects];
                dataArray = nil;
            }
            else
            {
                [rightBtn setHidden:NO];
            }
            if (dataArray.count == 0)
            {
                backView.hidden = NO;
                tv.scrollEnabled = NO;
            }
            for(int i=dataArray.count-1;i>=0;i--)
            {
                if([[dataArray objectAtIndex:i] count] == 0)
                {
                    [[headLabelArray objectAtIndex:i] removeAllObjects];
                    
                    [[headBtnArray objectAtIndex:i] removeAllObjects];
                }
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
        if(subtractNum == 1)
        {
            [DCFStringUtil showNotice:@"商品数量不能为0"];
            subtractNum = 1;
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

#pragma mark - 图片点击
- (void) cellIvTap:(UITapGestureRecognizer *) sender
{
    int section = [[sender view] tag]/10000;
    int row = [[sender view] tag] % 10000;
    B2CShopCarListData *carListData = [[dataArray objectAtIndex:section] objectAtIndex:row];
    NSString *productId = [carListData productId];
    [self setHidesBottomBarWhenPushed:YES];
    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc] initWithProductId:productId];
    [self.navigationController pushViewController:detail animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
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
        int productNum = [carListData.productNum intValue];
        if(addNum > productNum)
        {
            [DCFStringUtil showNotice:@"所购数量不能超过库存"];
            return;
        }
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
    
    
    
    [tv reloadData];
    //    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
    //    NSArray *arr = [NSArray arrayWithObject:path];
    //    [tv reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}

- (void) payBtnChange
{
    NSString *btnTitle = [NSString stringWithFormat:@"结算(%d)",chooseGoodsArray.count];
    [payBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
}

- (void) doLoadRequest
{
    [self loadRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLoadRequest) name:@"B2CGoodsHasBuy" object:nil];
    
    [self pushAndPopStyle];
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //    [moreCell startAnimation];
    
    sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"我的购物车"];
    self.navigationItem.titleView = top;
    
    buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 114, ScreenWidth, 54)];
    [self.view addSubview:buttomView];
    
    loginView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 60)];
    [loginView setBackgroundColor:[UIColor whiteColor]];
    loginView.layer.cornerRadius = 5;
    loginView.layer.masksToBounds = YES;
    //    [noCell.contentView addSubview:loginView];
    
    logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logBtn.backgroundColor = [UIColor colorWithRed:237/255.0 green:142/255.0 blue:0/255.0 alpha:1.0];
    logBtn.layer.cornerRadius = 5;
    [logBtn setFrame:CGRectMake(10, 10, 70, 40)];
    [logBtn addTarget:self action:@selector(logBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    label_1 = [[UILabel alloc] initWithFrame:CGRectMake(logBtn.frame.origin.x + logBtn.frame.size.width + 15, logBtn.frame.origin.y, 200, 40)];
    [label_1 setBackgroundColor:[UIColor clearColor]];
    [label_1 setTextAlignment:NSTextAlignmentLeft];
    [label_1 setFont:[UIFont systemFontOfSize:12]];
    [label_1 setTextColor:[UIColor blackColor]];
    [label_1 setNumberOfLines:0];
    [label_1 setText:@"登录后可以同步电脑和手机端的商品,并保存在账户中"];
    
    [self hiddenButtomView];
    
    UIView *buttomTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [buttomTopView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [buttomView addSubview:buttomTopView];
    
    buttomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttomBtn setFrame:CGRectMake(5, 13, 28, 28)];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [buttomBtn setBackgroundImage:[UIImage imageNamed:@"unchoose.png"] forState:UIControlStateNormal];
    [buttomBtn setSelected:NO];
    [buttomBtn addTarget:self action:@selector(buttomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:buttomBtn];

    CGSize allLabelSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:@"全选" WithSize:CGSizeMake(MAXFLOAT, 28)];
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttomBtn.frame.origin.x+buttomBtn.frame.size.width+5, buttomBtn.frame.origin.y, allLabelSize.width, 28)];
    [allLabel setText:@"全选"];
    [allLabel setFont:[UIFont systemFontOfSize:12]];
    [allLabel setTextAlignment:NSTextAlignmentLeft];
    [buttomView addSubview:allLabel];
    
    payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setFrame:CGRectMake(ScreenWidth-110, 10, 100, 34)];
    payBtn.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:142.0/255.0 blue:0/255.0 alpha:1.0];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.layer.cornerRadius = 5.0f;
    payBtn.layer.masksToBounds = YES;
    [self payBtnChange];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:payBtn];
    
    moneyLabel = [[UILabel alloc] init];
    totalMoney = 0.00;

    CGSize moneySize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"￥ %@",[DCFCustomExtra notRounding:totalMoney afterPoint:2]] WithSize:CGSizeMake(MAXFLOAT, 20)];
 
    [moneyLabel setText:[NSString stringWithFormat:@"￥ %@",[DCFCustomExtra notRounding:totalMoney afterPoint:2]]];
    
    [moneyLabel setFont:[UIFont systemFontOfSize:12]];
    [moneyLabel setTextColor:[UIColor redColor]];
    [moneyLabel setFrame:CGRectMake(ScreenWidth-120-moneySize.width, 10, moneySize.width, 20)];
    [moneyLabel setTextAlignment:NSTextAlignmentRight];
    [buttomView addSubview:moneyLabel];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
    [countLabel setTextColor:[UIColor blackColor]];
    [countLabel setFont:[UIFont systemFontOfSize:12]];
    [countLabel setTextAlignment:NSTextAlignmentRight];
    [countLabel setText:@"合计:"];
    [buttomView addSubview:countLabel];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x, countLabel.frame.origin.y+countLabel.frame.size.height, countLabel.frame.size.width+moneyLabel.frame.size.width+5, 14)];
    [l setTextAlignment:NSTextAlignmentRight];
    [l setFont:[UIFont systemFontOfSize:12]];
    [l setText:@"不含运费"];
    [buttomView addSubview:l];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 54-54)];
    [tv setDataSource:self];
    tv.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    [tv setDelegate:self];
    [self.view addSubview:tv];
    
    //ADD REFRESH VIEW
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -300, ScreenWidth, 300)];
    [self.refreshView setDelegate:self];
    [tv addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
    
    noCell = [[UITableViewCell alloc] init];
    [noCell.contentView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [noCell setSelectionStyle:0];
}


-(void)hiddenButtomView
{
    backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, ScreenHeight - 114, ScreenWidth, 54);
    backView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
    [self.view insertSubview:backView aboveSubview:buttomView];
    backView.hidden = YES;
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

- (NSString *)dictoJSON:(NSDictionary *)theDic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strP = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    return [Rsa rsaEncryptString:strP];
    return strP;
}

- (void) payBtnClick:(UIButton *) sender
{
    if(!chooseGoodsArray || chooseGoodsArray.count == 0)
    {
        [DCFStringUtil showNotice:@"您尚未选择商品"];
        return;
    }

//    NSString *items = nil;

//    if(chooseGoodsArray && chooseGoodsArray.count != 0)
//    {
//        for(int i=0;i<chooseGoodsArray.count;i++)
//        {
//            B2CShopCarListData *data = [chooseGoodsArray objectAtIndex:i];
//            if(i == 0)
//            {
//                items = [NSString stringWithFormat:@"%@,",data.itemId];
//            }
//            else
//            {
//                items = [items stringByAppendingString:[NSString stringWithFormat:@"%@,",data.itemId]];
//            }
//        }
//        items = [items substringWithRange:NSMakeRange(0, items.length-1)];
//    }
    
//    NSString *time = [DCFCustomExtra getFirstRunTime];
    
//    NSString *string = [NSString stringWithFormat:@"%@%@",@"cartConfirm",time];
    
//    NSString *token = [DCFCustomExtra md5:string];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/cartConfirm.html?"];
//    NSString *pushString = nil;
    
//    pushString = [NSString stringWithFormat:@"memberid=%@&token=%@&coloritem=%@",[self getMemberId],token,items];
//    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLCartConfirmTag delegate:self];
//    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
    
    NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
//
    if(chooseGoodsArray && chooseGoodsArray.count != 0)
    {
        for(int i=0;i<chooseGoodsArray.count;i++)
        {
            B2CShopCarListData *data = [chooseGoodsArray objectAtIndex:i];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 data.createDate,@"createDate",
                                 data.colorId,@"colorId",
                                 data.colorName,@"colorName",
                                 data.colorPrice,@"colorPrice",
                                 data.isAvaliable,@"isAvaliable",
                                 data.isDelete,@"isDelete",
                                 data.isSale,@"isSale",
                                 data.isUse,@"isUse",
                                 data.itemId,@"itemId",
                                 data.memberId,@"memberId",
                                 data.num,@"count",
                                 data.price,@"productPrice",
                                 data.productId,@"productId",
                                 data.productItemPic,@"productItemPic",
                                 data.productItemSku,@"productName",
                                 data.productNum,@"productNum",
                                 data.sShopName,@"sShopName",
                                 data.shopId,@"shopId",
                                 data.visitorId,@"visitorId",
                                 data.productItmeTitle,@"productTitle",
                                 data.recordId,@"recordId",
                                 nil];
            
            [goodsArray addObject:dic];
        }
    }
//
    NSDictionary *pushDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             goodsArray,@"goodsList",
                             nil];
    NSArray *dicArray = [[NSArray alloc] initWithObjects:pushDic, nil];
    NSDictionary *myDic = [[NSDictionary alloc] initWithObjectsAndKeys:dicArray,@"shopList", nil];
    NSString *time = [DCFCustomExtra getFirstRunTime];
    NSString *string = [NSString stringWithFormat:@"%@%@",@"validProductBeforeSubOrder",time];
    NSString *token = [DCFCustomExtra md5:string];
//
//
    NSString *memberId = [self getMemberId];
    if([DCFCustomExtra validateString:memberId] == NO)
    {
        
    }
    else
    {
        NSString *pushString = [NSString stringWithFormat:@"token=%@&items=%@&memberid=%@",token,[self dictoJSON:myDic],memberId];
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLValidProductBeforeSubOrderTag delegate:self];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_HOST_CHEN,@"/B2CAppRequest/validProductBeforeSubOrder.html?"];
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
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您确定要删除么"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定", nil];
    [av show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == dataArray.count)
    {
        return 0;
    }
    if(!dataArray || dataArray.count == 0)
    {
        return 0;
    }
    if([[dataArray objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    return 46;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
    {
        if(dataArray && dataArray.count != 0)
        {
            for(NSMutableArray *arr in dataArray)
            {
                if(arr.count != 0)
                {
                    if(noCell)
                    {
                        for(UIView *view in noCell.subviews)
                        {
                            [view setHidden:YES];
                            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 0)];
                        }
                    }
                    return 0;
                }
            }
            return ScreenHeight-34;
        }
        else
        {
            for(UIView *view in noCell.subviews)
            {
                [view setHidden:NO];
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            }
            return ScreenHeight-34;
        }
    }
    if(!dataArray || dataArray.count == 0)
    {
        return ScreenHeight - 34;
    }
    if(dataArray && [[dataArray objectAtIndex:indexPath.section] count] != 0)
    {
        return 120;
    }
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!dataArray || dataArray.count == 0)
    {
        return 1;
    }
    return dataArray.count+1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == dataArray.count)
    {
        return 1;
    }
    if(!dataArray || [dataArray count] == 0)
    {
        return 1;
    }
    return [[dataArray objectAtIndex:section] count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == dataArray.count)
    {
        return nil;
    }
    if(!dataArray || dataArray.count == 0)
    {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 46)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:[[headBtnArray objectAtIndex:section] lastObject]];
    [view setTag:section];
    
    NSString *title = [[[dataArray objectAtIndex:section] lastObject] sShopName];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
    //    [sectionLabel setText:[headLabelArray objectAtIndex:section]];
    [sectionLabel setText:title];
    [sectionLabel setTextAlignment:NSTextAlignmentLeft];
    [sectionLabel setTextColor:[UIColor blackColor]];
    [sectionLabel setFont:[UIFont systemFontOfSize:13]];
    [view addSubview:sectionLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, sectionLabel.frame.origin.y+sectionLabel.frame.size.height+10, ScreenWidth-10, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [view addSubview:lineView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTap:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (void) sectionTap:(UITapGestureRecognizer *) sender
{
    int tag = [[sender view] tag];
    if(!dataArray || dataArray.count == 0)
    {
        
    }
    else
    {
        [self setHidesBottomBarWhenPushed:YES];
        ShopHostTableViewController *shopHost = [[ShopHostTableViewController alloc] initWithHeadTitle:[[[dataArray objectAtIndex:tag] lastObject] sShopName] WithShopId:[[[dataArray objectAtIndex:tag] lastObject] shopId] WithUse:@""];
        [self.navigationController pushViewController:shopHost animated:YES];
    }
 
}

- (void) logBtnClick:(UIButton *) sender
{
    LoginNaviViewController *loginNavi = [sb instantiateViewControllerWithIdentifier:@"loginNaviViewController"];
    [self presentViewController:loginNavi animated:YES completion:nil];
}


- (void) buyBtnClick:(UIButton *) sender
{

    
    [self setHidesBottomBarWhenPushed:YES];
    ShoppingHostViewController *shoppingHost = [[ShoppingHostViewController alloc] init];
    int n = 0;
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[ShoppingHostViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        else
        {
            if(n == self.navigationController.viewControllers.count-1)
            {
                [self.navigationController pushViewController:shoppingHost animated:YES];
                break;
            }
        }
        n++;
    }
    [self setHidesBottomBarWhenPushed:NO];

}

- (UITableViewCell *) loadNonDataTableview:tableView NoIndexPath:indexPath
{
    //    static NSString *moreCellId = @"moreCell";
    //    UITableViewCell *noCell = [tableView cellForRowAtIndexPath:indexPath];
    //    if(!noCell)
    //    {
    //        noCell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:moreCellId];
    //        [noCell.contentView setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:234.0/255.0 blue:242.0/255.0 alpha:1.0]];
    //    }
    
    //    if(rightBtn)
    //    {
    //        [rightBtn setHidden:YES]
    //    }
    
    NSString *myMemberid = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberId"];
    if([DCFCustomExtra validateString:myMemberid] == NO)
    {
        [noCell.contentView addSubview:loginView];
        [loginView addSubview:logBtn];
        [loginView addSubview:label_1];
    }
    else
    {
        if(loginView)
        {
            [logBtn removeFromSuperview];
            logBtn = nil;
            [label_1 removeFromSuperview];
            label_1 = nil;
            [loginView removeFromSuperview];
            loginView = nil;
        }
    }
    
    
    if (!shopcarView)
    {
        shopcarView = [[UIImageView alloc] init];
        shopcarView.frame = CGRectMake(20, 130, 61, 60);
        
        shopcarView.image = [UIImage imageNamed:@"shoppingCar"];
        [noCell.contentView addSubview:shopcarView];
    }
    if (!label_2)
    {
        NSString *string = @"您的购物车中暂时没有商品,现在去浏览选购商品~";
        CGSize size = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:15] WithText:string WithSize:CGSizeMake(200, MAXFLOAT)];
        label_2 = [[UILabel alloc] initWithFrame:CGRectMake(85, 150, 200, size.height)];
        [label_2 setBackgroundColor:[UIColor clearColor]];
        [label_2 setTextAlignment:NSTextAlignmentLeft];
        [label_2 setFont:[UIFont systemFontOfSize:15]];
        [label_2 setTextColor:[UIColor blackColor]];
        [label_2 setNumberOfLines:0];
        [label_2 setText:string];
        [noCell.contentView addSubview:label_2];
    }
    if (!buyBtn)
    {
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setFrame:CGRectMake(90, label_2.frame.origin.y + label_2.frame.size.height + 50, 140, 43)];
        [buyBtn setTitle:@"去选购商品" forState:UIControlStateNormal];
        buyBtn.backgroundColor = [UIColor whiteColor];
        buyBtn.layer.cornerRadius = 5.0f;
        [buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [noCell.contentView addSubview:buyBtn];
    }
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    noCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return noCell;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == dataArray.count)
    {
        return [self loadNonDataTableview:tableView NoIndexPath:indexPath];
        
    }
    
    if(dataArray)
    {
        NSMutableArray *arr = [dataArray objectAtIndex:indexPath.section];
        if(arr.count != 0 )
        {
            //商品数组不为空
            //            [
            //            (
            //            "<B2CShopCarListData: 0x1806be80>"
            //            ),
            //            (
            //            )
            //             ]
            flag = NO;
        }
        else
        {
            flag = YES;
        }
        
        //        if(arr.count == 0 && indexPath.section == dataArray.count-1 && flag == YES)
        //        {
        //            return [self loadNonDataTableview:tableView NoIndexPath:indexPath];
        //        }
        //        else
        //        {
        //        }
    }
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //    NSString *cellId = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellId];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
//        [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        [cell setSelectionStyle:0];
    }
    while (CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT != nil)
    {
        [(UIView *)CELL_CONTENTVIEW_SUBVIEWS_LASTOBJECT removeFromSuperview];
    }
    UIButton *cellBtn = [[cellBtnArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    [cellBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:cellBtn];
    UIImageView *cellIv = [[cellImageViewArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cellIv.userInteractionEnabled = YES;
    NSURL *url = [NSURL URLWithString:[[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] productItemPic]];
    [cellIv setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cabel.png"]];
    [cell.contentView addSubview:cellIv];
    [cellIv setTag:10000*indexPath.section+indexPath.row];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellIvTap:)];
    [cellIv addGestureRecognizer:tap];
    
    //单价
    NSString *shopPrice = [NSString stringWithFormat:@"¥ %@",[[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] price]];
    CGSize shopPriceSize;
    if([DCFCustomExtra validateString:shopPrice] == NO)
    {
        shopPriceSize = CGSizeMake(30, 30);
    }
    else
    {
        /**陈晓修改整数后面没有后2位**/
        for(int i=0;i<shopPrice.length;i++)
        {
            char c = [shopPrice characterAtIndex:i];
            if(c == '.')
            {
                break;
            }
            if(c != '.' && i == shopPrice.length-1)
            {
                shopPrice = [shopPrice stringByAppendingString:@".00"];
            }
        }
        
        shopPriceSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:shopPrice WithSize:CGSizeMake(MAXFLOAT, 30)];
    }
    UILabel *label = [[priceLabelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [label setFrame:CGRectMake(cell.contentView.frame.size.width-10-shopPriceSize.width,25, shopPriceSize.width, 30)];
    [label setText:shopPrice];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor redColor]];
    [label setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:label];
    
    //颜色
    NSString *shopColor = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] colorName];
    CGSize shopColorSize;
    if([DCFCustomExtra validateString:shopColor] == NO)
    {
        shopColorSize = CGSizeMake(30, 30);
    }
    else
    {
        shopColorSize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"颜色: %@",shopColor] WithSize:CGSizeMake(MAXFLOAT, 30)];
    }
    UILabel *subColorLab = [[colorLabelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [subColorLab setFrame:CGRectMake(cell.contentView.frame.size.width-10-shopColorSize.width,label.frame.origin.y+label.frame.size.height,shopColorSize.width,30)];
    [subColorLab setText:[NSString stringWithFormat:@"颜色:%@",shopColor]];
    [subColorLab setFont:[UIFont systemFontOfSize:12]];
    [subColorLab setTextColor:[UIColor lightGrayColor]];
    [subColorLab setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:subColorLab];
    
    CGFloat maxWidth = (shopPriceSize.width >= shopColorSize.width)?shopPriceSize.width:shopColorSize.width;

    
    //商品介绍
    NSString *content = [[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] productItmeTitle];
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellIv.frame.origin.x + cellIv.frame.size.width + 10, 20, ScreenWidth-155-maxWidth, 40)];
    [introduceLabel setTextAlignment:NSTextAlignmentLeft];
    [introduceLabel setTextColor:[UIColor blackColor]];
    [introduceLabel setNumberOfLines:0];
    [introduceLabel setFont:[UIFont systemFontOfSize:12]];
    [introduceLabel setText:content];
    [cell.contentView addSubview:introduceLabel];

    
    UIButton *subBtn = [[subtractArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [subBtn setFrame:CGRectMake(introduceLabel.frame.origin.x,introduceLabel.frame.origin.y+introduceLabel.frame.size.height,35, 30)];
    [subBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:subBtn];
    //
    UILabel *numLabel = [[UILabel alloc] init];
    [numLabel setFrame:CGRectMake(subBtn.frame.origin.x + subBtn.frame.size.width-0.5, subBtn.frame.origin.y, 35+0.5, 30)];
    [numLabel setText:[[[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] num]];
    [numLabel setTextAlignment:NSTextAlignmentCenter];
    [numLabel setTextColor:[UIColor blackColor]];
    numLabel.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    numLabel.layer.borderWidth = 1.0f;
    numLabel.layer.masksToBounds = YES;
    [numLabel setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView addSubview:numLabel];
    
    UIButton *addBtn = [[addArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [addBtn setFrame:CGRectMake(numLabel.frame.origin.x+numLabel.frame.size.width-0.5, subBtn.frame.origin.y, 35+0.5, 30)];
    [addBtn setTag:indexPath.row + indexPath.section*1000];
    [cell.contentView addSubview:addBtn];
    //

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, subColorLab.frame.origin.y+subColorLab.frame.size.height+25, ScreenWidth, 10)];
    [lineView setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [cell.contentView addSubview:lineView];
    
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
        [[[headBtnArray objectAtIndex:section] lastObject] setSelected:YES];
    }
    else
    {
        [[[headBtnArray objectAtIndex:section] lastObject] setSelected:NO];
    }
    
    [self calculateTotalMoney];
    [self payBtnChange];
    
    
    for(int i=0;i<headBtnArray.count;i++)
    {
        UIButton *btn = (UIButton *)[[headBtnArray objectAtIndex:i] lastObject];
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
        totalMoney = [price doubleValue]*[carlist.num intValue] + totalMoney;
    }
    CGSize moneySize = [DCFCustomExtra adjustWithFont:[UIFont systemFontOfSize:12] WithText:[NSString stringWithFormat:@"￥ %@",[DCFCustomExtra notRounding:totalMoney afterPoint:2]] WithSize:CGSizeMake(MAXFLOAT, 20)];
    [moneyLabel setFrame:CGRectMake(ScreenWidth-120-moneySize.width, 10, moneySize.width, 20)];
    [countLabel setFrame:CGRectMake(moneyLabel.frame.origin.x-55, 10, 50, 20)];
    [moneyLabel setText:[NSString stringWithFormat:@"￥ %@",[DCFCustomExtra notRounding:totalMoney afterPoint:2]]];
}

#pragma  mark  -  滚动加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    if (tv == (UITableView *)scrollView)
    {
        if (scrollView.contentSize.height > 0 && (scrollView.contentSize.height-scrollView.frame.size.height)>0)
        {
            if (scrollView.contentOffset.y >= scrollView.contentSize.height-scrollView.frame.size.height)
            {
//                [self loadRequest];
            }
        }
    }
}

#pragma mark SCROLLVIEW DELEGATE METHODS
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.refreshView egoRefreshScrollViewDidScroll:tv];
}
//
#pragma mark -
#pragma mark DATA SOURCE LOADING / RELOADING METHODS
- (void)reloadViewDataSource
{
    _reloading = YES;
    
    [self loadRequest];
}
//
- (void)doneLoadingViewData
{
    
    _reloading = NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
}
//
//#pragma mark -
//#pragma mark REFRESH HEADER DELEGATE METHODS
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
    [self reloadViewDataSource];
}
//
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date];
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
