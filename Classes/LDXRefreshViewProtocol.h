//
//  LDXRefreshProtocol.h
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/8.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自定义刷新组件的协议
 */
@protocol LDXRefreshViewProtocol <NSObject>

@required

/**
 刷新过程中偏移量回调的
 
 @param offsetY offsetY偏移量
 */
- (void)ldx_refreshOffsetY:(NSNumber*)offsetY;

/**
 正在刷新的回调
 */
- (void)ldx_refreshing;

/**
 刷新完成的回调
 */
- (void)ldx_refreshFinish;

/**
 结束刷新
 */
- (void)ldx_endRefresh;

@end
