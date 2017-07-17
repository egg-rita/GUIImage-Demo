//
//  ViewController.m
//  GUIImage-Demo
//
//  Created by WT－WD on 17/7/17.
//  Copyright © 2017年 none. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import <Masonry.h>

@interface CustomCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@end


@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIImageView *imgView;//原始图片
@property(nonatomic,strong)UIImageView *changeImgView;//修改后的图片

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,copy)NSArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupUI];
    [self originImgView];//原始图片
    [self changeImageView];//修改后的图片
}

-(void)originImgView{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.0)];
    self.imgView.image = [UIImage imageNamed:@"01.jpg"];
    [self.view addSubview:self.imgView];
}
-(void)changeImageView{
    self.changeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 220.0, self.view.bounds.size.width, 200.0)];
     self.changeImgView.image = [UIImage imageNamed:@"01.jpg"];
    [self.view addSubview:self.changeImgView];
}

-(void)setupUI{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(100.0, 50.0);
    self.flowLayout.minimumLineSpacing = 10.0;
//    self.flowLayout.minimumInteritemSpacing = 0.0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50.0, self.view.bounds.size.width, 50.0) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
CustomCell *cell = (CustomCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CustomCell alloc]init];
        cell.backgroundColor = [UIColor greenColor];
    }
    cell.titleLabel.text = self.dataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - setter
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    }
    return _dataArr;
}

@end

@implementation CustomCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
