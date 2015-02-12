//
//  ViewController.m
//  CategoryScrollExample
//
//  Created by 村上優孝 on 2015/02/12.
//  Copyright (c) 2015年 村上優孝. All rights reserved.
//

#import "ViewController.h"

#define CATEGORY_BAR_HEIGHT 30
#define CATEGORIES @[@"ニュース", @"エンタメ", @"グルメ"]

@interface ViewController ()

@property UIScrollView *categoryScrollView;
@property UIScrollView *tableScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createTableScrollView]; // テーブルのスクロールビューを作成
    
    [self createCategoryScrollView]; // カテゴリーのスクロールビューを作成
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - ScrollView

- (void) createCategoryScrollView{
    CGFloat CATEGORY_WIDTH = 120;
    CGFloat CATEGORY_HEIGHT = CATEGORY_BAR_HEIGHT;
    
    // カテゴリーのスクロールビューを作成
    self.categoryScrollView = [[UIScrollView alloc] init];
    self.categoryScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    self.categoryScrollView.backgroundColor = [UIColor lightGrayColor];
    self.categoryScrollView.contentSize = CGSizeMake(CATEGORY_WIDTH * CATEGORIES.count, CATEGORY_HEIGHT);
    self.categoryScrollView.pagingEnabled = YES;
    self.categoryScrollView.clipsToBounds = NO;
    self.categoryScrollView.bounds = CGRectMake(0.0f, 0.0f, CATEGORY_WIDTH, 0); // カテゴリーの幅をスクロールする幅にする
    self.categoryScrollView.delegate = self;
    [self.view addSubview:self.categoryScrollView];
    
    // カテゴリーの強調線を追加
    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(CATEGORY_WIDTH -30 , CATEGORY_HEIGHT, CATEGORY_WIDTH, 2)];
    horizontal.backgroundColor = [UIColor redColor];
    [self.view addSubview:horizontal];
    
    // カテゴリーをスクロールビューに追加
    for (int i=0; i < CATEGORIES.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CATEGORY_WIDTH * i, 0, CATEGORY_WIDTH, CATEGORY_HEIGHT);
        label.text = CATEGORIES[i];
        [self.categoryScrollView addSubview:label];
    }
}

- (void) createTableScrollView{
    CGFloat TABLE_WIDTH = self.view.frame.size.width;
    CGFloat TABLE_HEIGHT = self.view.bounds.size.height;
    CGRect tableBounds = CGRectMake(0.0f, CATEGORY_BAR_HEIGHT, TABLE_WIDTH, TABLE_HEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height - CATEGORY_BAR_HEIGHT);
    
    // テーブルのスクロールビューを作成
    self.tableScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.tableScrollView.contentSize = CGSizeMake(TABLE_WIDTH * CATEGORIES.count, TABLE_HEIGHT);
    self.tableScrollView.pagingEnabled = YES;
    self.tableScrollView.clipsToBounds = NO;
    self.tableScrollView.delegate = self;
    [self.view addSubview:self.tableScrollView];
    
    
    // テーブルをスクロールビューに追加
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
        [self.categoryScrollView setContentOffset:CGPointMake(self.categoryScrollView.frame.size.width * fractionalPage, self.categoryScrollView.frame.origin.y) animated:NO]; // テーブルのスクロールビューが移動した割合だけカテゴリーのスクロールビューも移動する
    }
}

@end