//
//  LDXRefreshController.m
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/7.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "LDXRefreshController.h"
#import "LDXRefreshViewProtocol.h"

typedef enum : NSUInteger {
    LDXRefreshNormal,
    LDXRefreshRefreshing,
    LDXRefreshRefreshFinish,
} LDXRefreshState;

@interface LDXRefreshView : UIView <LDXRefreshViewProtocol>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) LDXRefreshState *ldx_refreshState;

- (void)ldx_refreshOffsetY:(CGFloat)offsetY;
- (void)ldx_refreshing;
- (void)ldx_refreshFinish;

@end

@implementation LDXRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = @"下拉刷新";
        [self addSubview:self.label];
    }
    return self;
}

- (void)ldx_refreshOffsetY:(CGFloat)offsetY {
    //    self.label.text = [@"hello" stringByAppendingFormat:@"%f",[offsetY floatValue]];
}

- (void)ldx_refreshing {
    self.label.text = @"正在刷新";
}

- (void)ldx_refreshFinish {
    self.label.text = @"完成刷新";
}

@end

@interface LDXRefreshController ()

@property (nonatomic, assign) LDXRefreshState refreshState;
@property (nonatomic, copy) void(^refreshBlock)(void);
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) CGFloat refreshOffsetY;
@property (nonatomic, strong) LDXRefreshView *refreshView;
@property (nonatomic, assign) CGFloat refreshFinishStateTime;

@end

@implementation LDXRefreshController

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        self.refreshState = LDXRefreshNormal;
        self.refreshView = [[LDXRefreshView alloc] initWithFrame:CGRectMake(0, -78, self.tableView.frame.size.width, 78)];
        [self.tableView addSubview:self.refreshView];
        self.refreshOffsetY = -78;
    }
    return self;
}

- (void)ldx_installRefreshBlock:(void(^)(void))block {
    self.refreshBlock = block;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)ldx_removeRefresh {
    [self.refreshView removeFromSuperview];
    self.refreshView = nil;
}

- (void)ldx_finishRefresh {
    [self.refreshView performSelector:@selector(ldx_refreshFinish)];
    self.refreshState = LDXRefreshRefreshFinish;
    
    [UIView animateWithDuration:0.3 delay:self.refreshFinishStateTime options:UIViewAnimationOptionTransitionNone animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.refreshState = LDXRefreshNormal;
    }];
}

- (void)ldx_setRefreshOffset:(CGFloat)offsetY {
    self.refreshOffsetY = offsetY;
}

- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime {
    self.refreshFinishStateTime = displayTime;
}

- (void)ldx_setCustomRefreshView:(UIView<LDXRefreshViewProtocol> *)customView {
    [self ldx_removeRefresh];
    [self.tableView addSubview:customView];
    self.refreshView = (LDXRefreshView*)customView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        [self.refreshView ldx_refreshOffsetY:offsetY];
        if (offsetY<=self.refreshOffsetY && self.refreshState == LDXRefreshNormal && !self.tableView.isDragging) {
            self.refreshState = LDXRefreshRefreshing;
            [self.refreshView ldx_refreshing];
            self.tableView.contentInset = UIEdgeInsetsMake(-self.refreshOffsetY-1, 0, 0, 0);
            !self.refreshBlock?:self.refreshBlock();
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
