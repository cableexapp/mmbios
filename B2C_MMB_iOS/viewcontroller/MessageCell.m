
#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "UIImageView+WebCache.h"

@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
}

@end

@implementation MessageCell
@synthesize richTextView = _richTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentBtn];
        
        //4.创建图文混排
        self.richTextView = [[TQRichTextView alloc] init];
        self.richTextView.backgroundColor = [UIColor clearColor];
        self.richTextView.delegage = self;
        [_contentBtn addSubview:self.richTextView];
    }
    return self;
}

-(int)calc_charsetNum:(NSString*)_str
{
    unsigned result = 0;
    const char *tchar=[_str UTF8String];
    if (NULL == tchar)
    {
        return result;
    }
    result = strlen(tchar);
    return result;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;
    
    // 1、设置时间
    if (messageFrame.showTime == NO)
    {
        _timeBtn.hidden = YES;
       [_timeBtn setBackgroundImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    }
    else
    {
        _timeBtn.hidden = NO;
        NSArray *timeArray = [message.time componentsSeparatedByString:@":"];
        NSString *tempTime = [NSString stringWithFormat:@"%@:%@",[timeArray objectAtIndex:3],[timeArray objectAtIndex:4]];
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [_timeBtn setTitle:tempTime forState:UIControlStateNormal];
        
    }
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像

    _iconView.frame = _messageFrame.iconF;
    
    if ([message.icon isEqualToString:@"icon01.png"])
    {
        NSString *headPortraitUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"headPortraitUrl"];
        [_iconView setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:[UIImage imageNamed:@"icon01.png"]];
    }
    else
    {
        _iconView.image = [UIImage imageNamed:message.icon];
    }
 
    // 3、设置内容
//    _contentBtn.frame = _messageFrame.contentF;
    _contentBtn.frame = CGRectMake(_messageFrame.contentF.origin.x, _messageFrame.contentF.origin.y, _messageFrame.contentF.size.width-5, _messageFrame.contentF.size.height-10);
    if (message.type == MessageTypeMe)
    {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
//        NSLog(@"length = %d",[self calc_charsetNum:message.content]);
        if ([self calc_charsetNum:message.content] <= 33 && [message.content rangeOfString:@"["].location == NSNotFound)
        {
//           NSLog(@"111111");
            _contentBtn.frame = CGRectMake(_messageFrame.contentF.origin.x+10, _messageFrame.contentF.origin.y+10, _messageFrame.contentF.size.width-5, _messageFrame.contentF.size.height-10);
            self.richTextView.frame = CGRectMake(10, 7, _contentBtn.frame.size.width-25, _contentBtn.frame.size.height-10);
        }
        else if ([message.content rangeOfString:@"["].location != NSNotFound && [message.content rangeOfString:@"]"].location != NSNotFound)
        {
//           NSLog(@"22222");
            int m = [message.content componentsSeparatedByString:@"["].count-1;
            _contentBtn.frame = CGRectMake(_messageFrame.contentF.origin.x+22*m, _messageFrame.contentF.origin.y+10, _messageFrame.contentF.size.width-20*m, _messageFrame.contentF.size.height-10);
            self.richTextView.frame = CGRectMake(10, 7, _contentBtn.frame.size.width-25, _contentBtn.frame.size.height-10);
        }
        else
        {
//           NSLog(@"33333");
            _contentBtn.frame = CGRectMake(_messageFrame.contentF.origin.x+10, _messageFrame.contentF.origin.y, _messageFrame.contentF.size.width-5, _messageFrame.contentF.size.height-10);
            self.richTextView.frame = CGRectMake(10, 5, _contentBtn.frame.size.width-25, _contentBtn.frame.size.height-10);
        }
    }
    else
    {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
        if ([self calc_charsetNum:message.content] <= 33)
        {
            self.richTextView.frame = CGRectMake(23, 7, _contentBtn.frame.size.width-25, _contentBtn.frame.size.height-10);
        }
        else
        {
            self.richTextView.frame = CGRectMake(23, 5, _contentBtn.frame.size.width-25, _contentBtn.frame.size.height-10);
        }
    }
    self.richTextView.text = message.content;
    self.richTextView.font = kContentFont;
    
    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
    
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

@end
