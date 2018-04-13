//
//  LDXLoadMoreViewProtocol.h
//  LDXTableviewRefresh
//
//  Created by 刘东旭 on 2018/4/11.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自定义刷新组件的协议
 */
@protocol LDXLoadMoreViewProtocol <NSObject>

@required

/**
 上拉加载过程中偏移量回调的
 
 @param offsetY offsetY偏移量
 */
- (void)ldx_loadMoreOffsetY:(NSNumber*)offsetY;

/**
 正在上拉加载的回调
 */
- (void)ldx_loadingMore;

/**
 上拉加载完成的回调
 */
- (void)ldx_loadMoreFinish;

/**
 结束刷新
 */
- (void)ldx_endLoadMore;

/**
 没有更多数据

 @param noMoreDataString 没有更多数据的显示
 */
- (void)ldx_noMoreData:(NSString *)noMoreDataString;

@end
