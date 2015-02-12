//
//  ViewController.m
//  CategoryScrollExample
//
//  Created by 村上優孝 on 2015/02/12.
//  Copyright (c) 2015年 村上優孝. All rights reserved.
//

#import "ViewController.h"

#define CATEGORY_BAR_HEIGHT 30
#define CATEGORIES @[@"0", @"1", @"2"]

@interface ViewController ()

@property UIScrollView *categoryScrollView;
@property UIScrollView *tableScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createArticleScrollView];
    [self createCategoryScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - ScrollView

- (void) createCategoryScrollView{
    CGFloat CATEGORY_WIDTH = 120;
    CGFloat CATEGORY_HEIGHT = CATEGORY_BAR_HEIGHT;
    
    self.categoryScrollView = [[UIScrollView alloc] init];
    self.categoryScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    self.categoryScrollView.backgroundColor = [UIColor lightGrayColor];
    self.categoryScrollView.contentSize = CGSizeMake(CATEGORY_WIDTH * CATEGORIES.count, CATEGORY_HEIGHT);
    self.categoryScrollView.pagingEnabled = YES;
    self.categoryScrollView.clipsToBounds = NO;
    self.categoryScrollView.bounds = CGRectMake(0.0f, 0.0f, CATEGORY_WIDTH, 0);
    self.categoryScrollView.delegate = self;
    [self.view addSubview:self.categoryScrollView];
    
    // 線を引く
    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(CATEGORY_WIDTH -30 , CATEGORY_HEIGHT, CATEGORY_WIDTH, 2)];
    horizontal.backgroundColor = [UIColor redColor];
    [self.view addSubview:horizontal];
    
    // テーブルをカテゴリの数だけ追加
    for (int i=0; i < CATEGORIES.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CATEGORY_WIDTH * i, 0, CATEGORY_WIDTH, CATEGORY_HEIGHT);
        label.text = CATEGORIES[i];
        [self.categoryScrollView addSubview:label];
    }
}

- (void) createArticleScrollView{
    CGFloat TABLE_WIDTH = self.view.frame.size.width;
    CGFloat TABLE_HEIGHT = self.view.bounds.size.height;
    CGRect tableBounds = CGRectMake(0.0f, CATEGORY_BAR_HEIGHT, TABLE_WIDTH, TABLE_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height - CATEGORY_BAR_HEIGHT);
    
    self.tableScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.tableScrollView.contentSize = CGSizeMake(TABLE_WIDTH * CATEGORIES.count, TABLE_HEIGHT);
    self.tableScrollView.pagingEnabled = YES;
    self.tableScrollView.clipsToBounds = NO;
    self.tableScrollView.delegate = self;
    [self.view addSubview:self.tableScrollView];
    
    
    // UITableView をUIScrollView に追加
    CGRect tableFrame = tableBounds;
    tableFrame.origin.x = 0.0f;
    for (int i = 0; i < CATEGORIES.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableFrame.origin.x += TABLE_WIDTH;
        [self.tableScrollView addSubview:tableView];
    }
}

#pragma mark - TableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d", tableView.tag, indexPath.row];
    return cell;
}

#pragma mark - ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    if (scrollView == self.tableScrollView) {
        [self.categoryScrollView setContentOffset:CGPointMake(self.categoryScrollView.frame.size.width * fractionalPage, self.categoryScrollView.frame.origin.y) animated:NO];
    }
}

@end