//
//  NanoViewController.m
//  Nano
//
//  Created by steven0610 on 08/28/2018.
//  Copyright (c) 2018 steven0610. All rights reserved.
//

#import "NanoViewController.h"

@interface NanoViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NanoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *cellText = nil;
    if (indexPath.row%10 == 0) {
        usleep(3000*1000);
        cellText = @"我要睡一会，等等";
    }else{
        cellText = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    }
    
    cell.textLabel.text = cellText;
    return cell;
}
@end
