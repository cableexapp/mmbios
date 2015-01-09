#import "logisticsTrackingViewController.h"
#import "LogisticsTrackingTableViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"
#import "AppDelegate.h"

@interface logisticsTrackingViewController ()
{
    LogisticsTrackingTableViewController *logisticsTrackingTableViewController;
    AppDelegate *app;
}
@end

@implementation logisticsTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"物流详情"];
    self.navigationItem.titleView = top;
    
    [self.logisticsNameLabel setText:self.mylogisticsName];
    [self.logisticsNumLabel setText:[NSString stringWithFormat:@"快递单号:%@",self.mylogisticsId]];
    
    logisticsTrackingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingTableViewController"];
    logisticsTrackingTableViewController.view.frame = self.tableBackView.bounds;
    [self addChildViewController:logisticsTrackingTableViewController];
    [self.tableBackView addSubview:logisticsTrackingTableViewController.view];
    logisticsTrackingTableViewController.myArray = [[NSMutableArray alloc] init];

    logisticsTrackingTableViewController.isRequest = YES;
    [logisticsTrackingTableViewController.tableView reloadData];
    
    _wv = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_wv setDelegate:self];
    
    //    http://m.kuaidi100.com/index_all.html?type="+com+"&postid="+nu
    
//    NSString *str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.mylogisticsNum,self.mylogisticsId];
//    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.lookForTradeMsg = YES;
    [self loadRequest];
    
}


- (void) webViewDidStartLoad:(UIWebView *)webView
{
}

- (void) loadRequest
{
    if(conn)
    {
        [conn stopConnection];
        conn = nil;
    }
//    if(!conn)
//    {
//    NSString *pushString = [NSString stringWithFormat:@"rand=%@&id=%@&fromWeb=%@&postid=@",@"1",self.mylogisticsNum,@"null",self.mylogisticsId];

    NSString *pushString = [NSString stringWithFormat:@"rand=%@&id=%@&fromWeb=%@&postid=%@",@"1",self.mylogisticsNum,@"null",self.mylogisticsId];
    
//        NSString *pushString = [NSString stringWithFormat:@"id=%@&com=%@&nu=%@&show=%@&muti=%@&order=%@",@"ac0b8f2dcfe149fc",self.mylogisticsNum,self.mylogisticsId,@"0",@"1",@"desc"];
    
        NSString *urlString = [NSString stringWithFormat:@"%@",@"http://wap.kuaidi100.com/wap_result.jsp?"];
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLogisticsTrackingTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
//    }

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
//    [self loadRequest];
}

- (void) resultWithString:(NSString *)str
{
    app.lookForTradeMsg = NO;
    NSLog(@"str = %@",str);

    NSString *dataStr = str;
    NSLog(@"%@",dataStr);
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"data = %@",dataStr);
    
    NSXMLParser *parse = [[NSXMLParser alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    [parse setDelegate:self];
    [parse parse];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"elementName =%@",elementName);
    //判断是否是meeting
    if ([elementName isEqualToString:@"html"])
    {
        if([elementName isEqualToString:@"body"])
        {
            NSLog(@"%@",elementName);
        }
        //判断属性节点
        if ([attributeDict objectForKey:@"class"])
        {
            //获取属性节点中的值
            NSString *addr=[attributeDict objectForKey:@"class"];
            NSLog(@"addr = %@",addr);
        }
    }
    //判断member
//    if ([elementName isEqualToString:@"member"])
//    {
//        NSLog(@"member");
//    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
//    int logistStatus = [[dicRespon objectForKey:@"status"] intValue];
//    
//    if(URLTag == URLLogisticsTrackingTag)
//    {
        NSLog(@"%@",dicRespon);
    
//    NSArray *arr = [[NSArray alloc] init];


    
    if([[dicRespon allKeys] count] == 0 || [dicRespon isKindOfClass:[NSNull class]])
    {
        
    }
    else
    {
//        NSString *dataStr = [dicRespon objectForKey:@"lookForTradeMsg"];
//        NSLog(@"%@",dataStr);
//        dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        NSLog(@"data = %@",dataStr);
//        
//        NSXMLParser *parse = [[NSXMLParser alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
//        [parse setDelegate:self];
//        [parse parse];
        
//        for(int i=0;i<arr.count;i++)
//        {
//            [logisticsTrackingTableViewController.myArray addObject:[arr objectAtIndex:i]];
//        }
    }
    
    logisticsTrackingTableViewController.isRequest = NO;
    [logisticsTrackingTableViewController.tableView reloadData];

    
//        if(logistStatus == 1)
//        {
//            NSArray *arr = [[NSArray alloc] initWithObjects:[dicRespon objectForKey:@"data"], nil];
//            for(int i=0;i<arr.count;i++)
//            {
//                [logisticsTrackingTableViewController.myArray addObject:[arr objectAtIndex:i]];
//            }
//
//            logisticsTrackingTableViewController.isRequest = NO;
//            [logisticsTrackingTableViewController.tableView reloadData];
//
//            NSString *statusString = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"state"]];
//            int statusInt = [statusString intValue];
//            if([DCFCustomExtra validateString:statusString] == NO)
//            {
//                [self.logisticsStatusLabel setText:[NSString stringWithFormat:@"%@",@"状态请求错误"]];
//                return;
//            }
//            switch (statusInt) {
//                case 0:
//                    [self.logisticsStatusLabel setText:@"物流状态:在途"];
//                    break;
//                case 1:
//                    [self.logisticsStatusLabel setText:@"物流状态:已揽件"];
//                    break;
//                case 2:
//                    [self.logisticsStatusLabel setText:@"物流状态:疑难"];
//                    break;
//                case 3:
//                    [self.logisticsStatusLabel setText:@"物流状态:已签收"];
//                    break;
//                case 4:
//                    [self.logisticsStatusLabel setText:@"物流状态:退签"];
//                    break;
//                case 5:
//                    [self.logisticsStatusLabel setText:@"物流状态:派件中"];
//                    break;
//                case 6:
//                    [self.logisticsStatusLabel setText:@"物流状态:退回中"];
//                    break;
//                default:
//                    break;
//            }
//        }
//        else if(logistStatus == 2)
//        {
////            [DCFStringUtil showNotice:msg];
//            [self loadRequest];
//        }
//        else if (logistStatus == 0)
//        {
//            
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
