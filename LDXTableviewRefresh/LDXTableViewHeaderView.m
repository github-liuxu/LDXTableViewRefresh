//
//  TestView.m
//  testTableview
//
//  Created by 刘东旭 on 2018/4/5.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "LDXTableViewHeaderView.h"

@interface LDXTableViewHeaderView ()

@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshImageView;
@property (nonatomic, strong) UIActivityIndicatorView *refreshActivity;

@end

@implementation LDXTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.refreshLabel = [[UILabel alloc] init];
        self.refreshLabel.text = @"下拉刷新";
        self.refreshLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.refreshLabel];
        self.refreshImageView = [UIImageView new];
        self.refreshImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"arrow@2x" ofType:@"png"]];
        [self addSubview:self.refreshImageView];
        self.refreshActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.refreshActivity];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.refreshLabel.frame = self.bounds;
    self.refreshLabel.center = CGPointMake(self.refreshLabel.center.x+20, self.refreshLabel.center.y);
    self.refreshImageView.frame = CGRectMake(0, 0, 15, 40);
    self.refreshImageView.center = CGPointMake(self.center.x-35, self.refreshLabel.center.y);
    self.refreshActivity.center = self.refreshImageView.center;
}

- (void)ldx_refreshOffsetY:(CGFloat)offsetY {
    if (offsetY == 0) {
        self.refreshImageView.transform = CGAffineTransformIdentity;
    }
    
    if (offsetY < 0) {

        
    }
}

/**
 正在刷新的回调
 */
- (void)ldx_refreshing {
    self.refreshLabel.text = @"正在刷新...";
    [self.refreshActivity startAnimating];
    self.refreshImageView.hidden = YES;
    self.refreshImageView.transform = CGAffineTransformMakeRotation(M_PI);
}

/**
 刷新完成的回调
 */
- (void)ldx_refreshFinish {
    self.refreshLabel.text = @"完成刷新";
    [self.refreshActivity stopAnimating];
    self.refreshImageView.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
