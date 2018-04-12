//
//  ViewController.m
//  testTableview
//
//  Created by 刘东旭 on 2018/4/4.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "ViewController.h"
//#import "LDXRefreshController.h"
#import "UITableView+LDXRefresh.h"
#import "UITableView+LDXLoadMore.h"
//#import "LDXTableViewHeaderView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *tableView;
    int a;
    NSMutableArray *datasource;
//    LDXRefreshController *contrlloer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:topView];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 80;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"abc"];
    [self.view addSubview:tableView];
//    contrlloer = [[LDXRefreshController alloc] initWithTableView:tableView];
//    __weak typeof(contrlloer) weakContrlloer = contrlloer;
//    [contrlloer ldx_installRefreshBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakContrlloer ldx_finishRefresh];
//        });
//    }];
    __weak typeof(tableView) weakTableView = tableView;
    [tableView ldx_installRefreshBlock:^{
        NSLog(@"刷新");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView ldx_finishRefresh];
        });
    }];
////    [tableView ldx_setRefreshOffset:-30];
//    [tableView ldx_setFinishStateDisplayTime:1];
//    LDXTableViewHeaderView *view = [[LDXTableViewHeaderView alloc] initWithFrame:CGRectMake(0, -87, 414, 78)];
//    view.center = CGPointMake(tableView.center.x, -78/2);
//    view.backgroundColor = [UIColor blueColor];
//    [tableView ldx_setCustomRefreshView:view];
    datasource = [NSMutableArray array];
    for (int i = 0; i<15; i++) {
        [datasource addObject:[NSString stringWithFormat:@"%d",i]];
    }
    __weak typeof(datasource) weakDatasource = datasource;
    [tableView setLoadMoreMode:LDXLoadMoreFooter];
    [tableView ldx_installLoadMoreBlock:^{
        NSLog(@"加载更多");
        for (int i = 0; i<15; i++) {
            [weakDatasource addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [weakTableView reloadData];
        [weakTableView ldx_finishLoadMore];
    }];
    
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = datasource[indexPath.row];
    return cell;
}

//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return 80;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
