//
//  DSShopCellView.m
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 27.03.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import "DSShopCellView.h"

NSString *nibName = @"DSShopCellView";

@implementation DSShopCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (UIView *)loadFromNib {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:nibName
                                bundle:bundle];
    UIView *view = [[nib instantiateWithOwner:self
                                     options:nil] firstObject];
    return view;
}

- (void)setup {
    
    UIView *view = [self loadFromNib];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:view];
}

@end
