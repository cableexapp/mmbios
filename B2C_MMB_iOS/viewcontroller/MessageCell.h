
#import <UIKit/UIKit.h>
#import "TQRichTextView.h"
@class MessageFrame;

@interface MessageCell : UITableViewCell<TQRichTextViewDelegate>

@property (nonatomic, strong) MessageFrame *messageFrame;

@property (nonatomic,strong) TQRichTextView * richTextView;

//时间中间量
@property NSDate *tempDate;

@end
