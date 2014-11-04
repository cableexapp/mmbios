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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DCFTopLabel *top = [[DCFTopLabel alloc] initWithTitle:@"物流详情"];
    self.navigationItem.titleView = top;
    
    [self.logisticsNameLabel setText:self.mylogisticsNum];
    [self.logisticsNumLabel setText:self.mylogisticsId];
    
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

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error = %@",error.description);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    if(!conn)
    {
        NSString *pushString = [NSString stringWithFormat:@"id=%@&com=%@&nu=%@&show=%@&muti=%@&order=%@",@"ac0b8f2dcfe149fc",self.mylogisticsNum,self.mylogisticsId,@"0",@"1",@"desc"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@",@"http://api.kuaidi100.com/api?"];
        conn = [[DCFConnectionUtil alloc] initWithURLTag:URLLogisticsTrackingTag delegate:self];
        
        [conn getResultFromUrlString:urlString postBody:pushString method:POST];
        
   
    }
    else
    {
    }
}

- (void) resultWithDic:(NSDictionary *)dicRespon urlTag:(URLTag)URLTag isSuccess:(ResultCode)theResultCode
{
    int logistStatus = [[dicRespon objectForKey:@"status"] intValue];
    NSString *msg = [dicRespon objectForKey:@"message"];
    
    if(URLTag == URLLogisticsTrackingTag)
    {
        NSLog(@"%@",dicRespon);
        if(logistStatus == 1)
        {
            NSArray *arr = [[NSArray alloc] initWithObjects:[dicRespon objectForKey:@"data"], nil];
            for(int i=0;i<arr.count;i++)
            {
                [logisticsTrackingTableViewController.myArray addObject:[arr objectAtIndex:i]];
            }
        }
        else
        {
            [DCFStringUtil showNotice:msg];
        }

        logisticsTrackingTableViewController.isRequest = NO;
        [logisticsTrackingTableViewController.tableView reloadData];
        
        [self.logisticsStatusLabel setText:[NSString stringWithFormat:@"%@",[dicRespon objectForKey:@"state"]]];
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