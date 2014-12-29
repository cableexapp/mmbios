
#import <UIKit/UIKit.h>
#import "DCFConnectionUtil.h"

@interface logisticsTrackingViewController : UIViewController<UIWebViewDelegate,ConnectionDelegate>
{
    DCFConnectionUtil *conn;
    NSString *com;
    NSString *comcontact;
    NSString *comurl;
    NSString *condition;
    NSString *ischeck;
    NSString *message;
    NSString *nu;
    NSString *state;
    NSString *status;
}
@property (strong,nonatomic) UIWebView *wv;

@property (weak, nonatomic) IBOutlet UILabel *logisticsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsStatusLabel;

@property (weak, nonatomic) IBOutlet UIView *tableBackView;

@property (strong,nonatomic) NSString *mylogisticsId;
@property (strong,nonatomic) NSString *mylogisticsNum;
@property (strong,nonatomic) NSString *mylogisticsName;

@end