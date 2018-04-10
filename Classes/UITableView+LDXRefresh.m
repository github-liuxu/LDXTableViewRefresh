//
//  UITableView+LDXRefresh.m
//  testTableview
//
//  Created by 刘东旭 on 2018/4/5.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "UITableView+LDXRefresh.h"
#import "LDXRefreshController.h"
#import <objc/runtime.h>

//static const void *kLDXRefreshBlock = @"kLDXRefreshBlock";
//static const void *kLDXRefreshState = @"kLDXRefreshState";
//static const void *kLDXRefreshView = @"kLDXRefreshView";
//static const void *kLDXRefreshFinishStateTime = @"kLDXRefreshFinishStateTime";
//static const void *kLDXRefreshOffsetY = @"kLDXRefreshOffsetY";
static const void *kLDXRefreshController = &kLDXRefreshController;


@implementation UITableView (LDXRefresh)

- (void)ldx_installRefreshBlock:(void(^)(void))block {
    LDXRefreshController *controller = [[LDXRefreshController alloc] initWithTableView:self];
    [controller ldx_installRefreshBlock:block];
    objc_setAssociatedObject(self, kLDXRefreshController, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)self];
//
//    objc_setAssociatedObject(self, kLDXRefreshBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//    objc_setAssociatedObject(self, kLDXRefreshState, @(LDXRefreshNormal), OBJC_ASSOCIATION_RETAIN);
//    LDXRefreshView *ldx_refreshView = [[LDXRefreshView alloc] initWithFrame:CGRectMake(0, -78, self.frame.size.width, 78)];
//    [self addSubview:ldx_refreshView];
//
//    objc_setAssociatedObject(self, kLDXRefreshView, ldx_refreshView, OBJC_ASSOCIATION_RETAIN);
//    objc_setAssociatedObject(self, kLDXRefreshOffsetY, @(-78), OBJC_ASSOCIATION_RETAIN);
    
}

- (void)ldx_removeRefresh {
    LDXRefreshController *ldx_refreshController = objc_getAssociatedObject(self, kLDXRefreshController);
    [ldx_refreshController ldx_removeRefresh];
}

- (void)ldx_finishRefresh {
    LDXRefreshController *ldx_refreshController = objc_getAssociatedObject(self, kLDXRefreshController);
    [ldx_refreshController ldx_finishRefresh];
}

- (void)ldx_setRefreshOffset:(CGFloat)offsetY {
    LDXRefreshController *ldx_refreshController = objc_getAssociatedObject(self, kLDXRefreshController);
    [ldx_refreshController ldx_setRefreshOffset:offsetY];
}

- (void)ldx_setFinishStateDisplayTime:(CGFloat)displayTime {
    LDXRefreshController *ldx_refreshController = objc_getAssociatedObject(self, kLDXRefreshController);
    [ldx_refreshController ldx_setFinishStateDisplayTime:displayTime];
}

- (void)ldx_setCustomRefreshView:(UIView<LDXRefreshViewProtocol> *)customView {
    LDXRefreshController *ldx_refreshController = objc_getAssociatedObject(self, kLDXRefreshController);
    [ldx_refreshController ldx_setCustomRefreshView:customView];
}

@end
