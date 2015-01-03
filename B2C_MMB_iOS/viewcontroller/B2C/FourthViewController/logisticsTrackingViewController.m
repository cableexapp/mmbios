#import "logisticsTrackingViewController.h"
#import "LogisticsTrackingTableViewController.h"
#import "DCFTopLabel.h"
#import "MCDefine.h"
#import "DCFCustomExtra.h"
#import "DCFStringUtil.h"

@interface logisticsTrackingViewController ()
{
    LogisticsTrackingTableViewController *logisticsTrackingTableViewController;
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
    
    NSLog(@"%@ %@ %@",self.mylogisticsNum,self.mylogisticsName,self.mylogisticsId);
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
    
    NSString *str = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.mylogisticsNum,self.mylogisticsId];
    NSLog(@"mylogisticsNum = %@ mylogisticsId = %@",self.mylogisticsNum,self.mylogisticsId);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
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
        NSString *pushString = [NSString stringWithFormat:@"id=%@&com=%@&nu=%@&show=%@&muti=%@&order=%@",@"ac0b8f2dcfe149fc",self.mylogisticsNum,self.mylogisticsId,@"0",@"1",@"desc"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@",@"http://api.kuaidi100.com/api?"];
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLogisticsTrackingTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
//    }

}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error = %@",error.description);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadRequest];
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int logistStatus = [[dicRespon objectForKey:@"status"] intValue];
    NSLog(@"logistStatus = %d",logistStatus);
    
    if(URLTag == URLLogisticsTrackingTag)
    {

        if(logistStatus == 1)
        {
            NSArray *arr = [[NSArray alloc] initWithObjects:[dicRespon objectForKey:@"data"], nil];
            for(int i=0;i<arr.count;i++)
            {
                [logisticsTrackingTableViewController.myArray addObject:[arr objectAtIndex:i]];
            }
            
            logisticsTrackingTableViewController.isRequest = NO;
            [logisticsTrackingTableViewController.tableView reloadData];
            
            NSString *statusString = [NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"state"]];
            int statusInt = [statusString intValue];
            if([DCFCustomExtra validateString:statusString] == NO)
            {
                [self.logisticsStatusLabel setText:[NSString stringWithFormat:@"%@",@"状态请求错误"]];
                return;
            }
            switch (statusInt) {
                case 0:
                    [self.logisticsStatusLabel setText:@"物流状态:在途"];
                    break;
                case 1:
                    [self.logisticsStatusLabel setText:@"物流状态:已揽件"];
                    break;
                case 2:
                    [self.logisticsStatusLabel setText:@"物流状态:疑难"];
                    break;
                case 3:
                    [self.logisticsStatusLabel setText:@"物流状态:已签收"];
                    break;
                case 4:
                    [self.logisticsStatusLabel setText:@"物流状态:退签"];
                    break;
                case 5:
                    [self.logisticsStatusLabel setText:@"物流状态:派件中"];
                    break;
                case 6:
                    [self.logisticsStatusLabel setText:@"物流状态:退回中"];
                    break;
                default:
                    break;
            }
        }
        else if(logistStatus == 2)
        {
//            [DCFStringUtil showNotice:msg];
            [self loadRequest];
        }
        else if (logistStatus == 0)
        {
            
        }
    }
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
