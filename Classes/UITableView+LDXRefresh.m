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

static const void *kLDXRefreshController = &kLDXRefreshController;


@implementation UITableView (LDXRefresh)

- (void)ldx_installRefreshBlock:(void(^)(void))block {
    LDXRefreshController *ldx_controller = [[LDXRefreshController alloc] initWithTableView:self];
    [ldx_controller ldx_installRefreshBlock:block];
    objc_setAssociatedObject(self, kLDXRefreshController, ldx_controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
