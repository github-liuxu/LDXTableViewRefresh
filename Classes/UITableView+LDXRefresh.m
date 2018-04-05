//
//  UITableView+LDXRefresh.m
//  testTableview
//
//  Created by 刘东旭 on 2018/4/5.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "UITableView+LDXRefresh.h"
#import <objc/runtime.h>

static const void *kLDXRefreshBlock = @"kLDXRefreshBlock";
static const void *kLDXRefreshState = @"kLDXRefreshState";
static const void *kLDXRefreshView = @"kLDXRefreshView";
static const void *kLDXRefreshFinishStateTime = @"kLDXRefreshFinishStateTime";
static const void *kLDXRefreshOffsetY = @"kLDXRefreshOffsetY";

typedef enum : NSUInteger {
    LDXRefreshNormal,
    LDXRefreshRefreshing,
    LDXRefreshRefreshFinish,
} LDXRefreshState;

@interface LDXRefreshView : UIView <LDXRefreshViewProtocol>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) LDXRefreshState *ldx_refreshState;

- (void)ldx_refreshOffsetY:(NSNumber*)offsetY;
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

- (void)ldx_refreshOffsetY:(NSNumber*)offsetY {
//    self.label.text = [@"hello" stringByAppendingFormat:@"%f",[offsetY floatValue]];
}

- (void)ldx_refreshing {
    self.label.text = @"正在刷新";
}

- (void)ldx_refreshFinish {
    self.label.text = @"完成刷新";
}

@end


@implementation UITableView (LDXRefresh)

- (void)ldx_installRefreshBlock:(void(^)(void))block {
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)self];
    
    objc_setAssociatedObject(self, kLDXRefreshBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, kLDXRefreshState, @(LDXRefreshNormal), OBJC_ASSOCIATION_RETAIN);
    LDXRefreshView *ldx_refreshView = [[LDXRefreshView alloc] initWithFrame:CGRectMake(0, -78, self.frame.size.width, 78)];
    [self addSubview:ldx_refreshView];
    
    objc_setAssociatedObject(self, kLDXRefreshView, ldx_refreshView, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, kLDXRefreshOffsetY, @(-78), OBJC_ASSOCIATION_RETAIN);
    
}

- (void)ldx_removeRefresh {
    LDXRefreshView *ldx_refreshView = objc_getAssociatedObject(self, kLDXRefreshView);
    [ldx_refreshView removeFromSuperview];
    objc_setAssociatedObject(self, kLDXRefreshView, nil, OBJC_ASSOCIATION_RETAIN);
}

- (void)ldx_finishRefresh {
    LDXRefreshView *ldx_refreshView = objc_getAssociatedObject(self, kLDXRefreshView);
    [ldx_refreshView performSelector:@selector(ldx_refreshFinish)];
    objc_setAssociatedObject(self, kLDXRefreshState, @(LDXRefreshRefreshFinish), OBJC_ASSOCIATION_RETAIN);
    CGFloat ldxRefreshStateTime = [objc_getAssociatedObject(self, kLDXRefreshFinishStateTime) floatValue];
    [UIView animateWithDuration:0.3 delay:ldxRefreshStateTime options:UIViewAnimationOptionTransitionNone animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        objc_setAssociatedObject(self, kLDXRefreshState, @(LDXRefreshNormal), OBJC_ASSOCIATION_RETAIN);
    }];
}

- (void)ldx_setRefreshOffset:(CGFloat)offsetY {
    objc_setAssociatedObject(self, kLDXRefreshOffsetY, @(offsetY), OBJC_ASSOCIATION_RETAIN);
}

- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime {
    objc_setAssociatedObject(self, kLDXRefreshFinishStateTime, @(displayTime), OBJC_ASSOCIATION_RETAIN);
}

- (void)ldx_setCustomRefreshView:(UIView<LDXRefreshViewProtocol> *)customView {
    [self ldx_removeRefresh];
    [self addSubview:customView];
    
    objc_setAssociatedObject(self, kLDXRefreshView, customView, OBJC_ASSOCIATION_RETAIN);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == (__bridge void * _Nullable)(self) && [keyPath isEqualToString:@"contentOffset"]) {
        float offsetY = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        LDXRefreshState state = [objc_getAssociatedObject(self, kLDXRefreshState) integerValue];
        LDXRefreshView *ldx_refreshView = objc_getAssociatedObject(self, kLDXRefreshView);
        [ldx_refreshView performSelector:@selector(ldx_refreshOffsetY:) withObject:@(offsetY)];
        float refreshOffsetY = [objc_getAssociatedObject(self, kLDXRefreshOffsetY) floatValue];
        if (offsetY<=refreshOffsetY && state == LDXRefreshNormal && !self.isDragging) {
            objc_setAssociatedObject(self, kLDXRefreshState, @(LDXRefreshRefreshing), OBJC_ASSOCIATION_RETAIN);
            [ldx_refreshView performSelector:@selector(ldx_refreshing)];
            self.contentInset = UIEdgeInsetsMake(-refreshOffsetY-1, 0, 0, 0);
            void (^block)(void) = objc_getAssociatedObject(self, kLDXRefreshBlock);
            block();
        }
    }
}

@end
