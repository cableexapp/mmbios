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
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"查看物流信息"];
    self.navigationItem.titleView = top;
    
    [self.logisticsNameLabel setText:self.mylogisticsName];
    [self.logisticsNumLabel setText:[NSString stringWithFormat:@"快递单号: %@",self.mylogisticsId]];
    
    logisticsTrackingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"logisticsTrackingTableViewController"];
    logisticsTrackingTableViewController.view.frame = self.tableBackView.bounds;
    [self addChildViewController:logisticsTrackingTableViewController];
    [self.tableBackView addSubview:logisticsTrackingTableViewController.view];
    
    logisticsTrackingTableViewController.isRequest = YES;
    [logisticsTrackingTableViewController.tableView reloadData];
 
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
    
    NSString *pushString = [NSString stringWithFormat:@"rand=%@&id=%@&fromWeb=%@&postid=%@",@"1",self.mylogisticsNum,@"null",self.mylogisticsId];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",@"http://wap.kuaidi100.com/wap_result.jsp?"];
    conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLogisticsTrackingTag delegate:self];
    
    [conn getResultFromUrlString:urlString postBody:pushString method:POST];
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
    logisticsTrackingTableViewController.myArray = [[NSMutableArray alloc] init];
    NSString *dataStr = str;
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSArray *arr = [dataStr componentsSeparatedByString:@"<p>"];
    
    NSMutableArray *strArr = [[NSMutableArray alloc] init];
    for(int i=0;i<arr.count;i++)
    {
        NSString *s = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
        if([s hasPrefix:@"&middot;"])
        {
            [strArr addObject:s];
        }
    }
    for(int i=0;i<strArr.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@",[strArr objectAtIndex:i]];
        NSArray *a = [str componentsSeparatedByString:@"<br />"];
        
        NSString *s1 = [NSString stringWithFormat:@"%@",[a objectAtIndex:0]];
        s1 = [s1 substringFromIndex:8];
        
        NSString *s2 = [NSString stringWithFormat:@"%@",[a lastObject]];
        NSArray *b = [s2 componentsSeparatedByString:@"</p>"];
        s2 = [b objectAtIndex:0];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:s1,@"time",s2,@"content", nil];
        [logisticsTrackingTableViewController.myArray addObject:dic];
    }
    if(logisticsTrackingTableViewController.myArray.count != 0)
    {
        logisticsTrackingTableViewController.myArray = (NSMutableArray *)[[logisticsTrackingTableViewController.myArray reverseObjectEnumerator] allObjects];
        NSString *sendStatus = (NSString *)[[logisticsTrackingTableViewController.myArray objectAtIndex:0] objectForKey:@"content"];
        
        if([sendStatus rangeOfString:@"已签收"].location !=NSNotFound || [sendStatus rangeOfString:@"拍照签收"].location !=NSNotFound)
        {
            [self.logisticsStatusLabel setText:@"物流状态: 已签收"];
        }
        else
        {
            [self.logisticsStatusLabel setText:@"物流状态: 在途"];
        }
    }

//    [logisticsTrackingTableViewController.myArray removeAllObjects];
    logisticsTrackingTableViewController.isRequest = NO;
    [logisticsTrackingTableViewController reloadData:logisticsTrackingTableViewController.isRequest];
//    [logisticsTrackingTableViewController.tableView reloadData];
}


- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{

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
