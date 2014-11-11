
#import "GrayPageControl.h"


@implementation GrayPageControl


- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if ( self ) {

        activeImage = [[UIImage imageNamed:@"inactive_page_image"] retain];
        inactiveImage = [[UIImage imageNamed:@"active_page_image"] retain];

        [self setCurrentPage:1];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {

        activeImage = [[UIImage imageNamed:@"inactive_page_image"] retain];
        inactiveImage = [[UIImage imageNamed:@"active_page_image"] retain];

        [self setCurrentPage:1];
	}
	return self;
}


- (void)updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {

        UIImageView* dot = [self.subviews objectAtIndex:i];

        if (i == self.currentPage) {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = activeImage;
            }
            else {
                
                dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
            }
        }
        else {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = inactiveImage;
            }
            else {
                
                dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
            }
        }
    }
}

-(void) setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    [self updateDots];
}


-(void)dealloc {

    [activeImage release];
    [inactiveImage release];

    [super dealloc];
}

@end
