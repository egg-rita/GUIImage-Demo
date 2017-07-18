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

@property(nonatomic,copy)NSArray *dataArr;//滤镜数组
@property(nonatomic,copy)NSArray *imgArr;//图片数组

@property(nonatomic,strong)UIButton *nextBtn;//下一张图片
@property(nonatomic,strong)UIButton *upBtn;//下一张图片

@property(nonatomic,assign)NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    self.view.backgroundColor = [UIColor redColor];
    [self setupUI];
//    [self originImgView];//原始图片
    [self changeImageView];//修改后的图片
    
}

-(void)originImgView{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.0)];
    self.imgView.image = [UIImage imageNamed:self.imgArr[_index]];
    [self.view addSubview:self.imgView];
}
-(void)changeImageView{
    self.changeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.0)];
     self.changeImgView.contentMode = UIViewContentModeScaleToFill;
     self.changeImgView.image = [UIImage imageNamed:self.imgArr[_index]];
    
    CGSize size = [UIImage imageNamed:self.imgArr[_index]].size;
    CGFloat scale = self.view.bounds.size.width/size.width;
    CGRect frame = self.changeImgView.frame;
    frame.size.height = size.height * scale;
    self.changeImgView.frame = frame;
    
    [self.view addSubview:self.changeImgView];
}

-(void)setupUI{
    
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.upBtn];
    //===============================================
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(100.0, 50.0);
    self.flowLayout.minimumLineSpacing = 10.0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50.0, self.view.bounds.size.width, 50.0) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}
#pragma mark - method
-(void)BtnClickAction:(UIButton*)sender{
    switch (sender.tag) {
            case 2000:
            {//下一张
                _index++;
                if (_index >= self.imgArr.count) {
                    _index = 0;
                }
               UIImage *img = [UIImage imageNamed:self.imgArr[_index]];
                CGSize size = img.size;
                //比例
               CGFloat scale = self.view.bounds.size.width/size.width;
                
               CGRect frame = self.changeImgView.frame;
                frame.size.height = size.height * scale;
                self.changeImgView.frame = frame;
                
                self.changeImgView.image = img;
                    break;
            }
            case 2001:
            {//上一张
                _index-- ;
                if (_index < 0) {
                    _index = self.imgArr.count-1;
                }
                UIImage *img = [UIImage imageNamed:self.imgArr[_index]];
                CGSize size = img.size;
                //比例
                CGFloat scale = self.view.bounds.size.width/size.width;
                
                CGRect frame = self.changeImgView.frame;
                frame.size.height = size.height * scale;
                self.changeImgView.frame = frame;
                
                self.changeImgView.image = img;
                break;
            }
        default:
            break;
    }
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
    
    switch (indexPath.row) {
            case 0://晕影
        {
            [self vignetteFilterTest];
            break;
        }
            case 1:{//高斯模糊
            [self gaussianBlurFilterTest];
                break;
            }
            case 2://反色
        {
            [self colorInvertFilterTest];
            break;
        }
            case 3://blend
        {
            [self multiplyBlendFilterTest];
            break;
        }
            case 4://锐化
        {
            [self sharpenFilterTest];
            break;
        }
            case 5://伽马线
        {
            [self gammaFilterTest];
            break;
        }
        default:
            break;
    }
    
}
-(void)gammaFilterTest{
   GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc]init];
    [gammaFilter useNextFrameForImageCapture];
    
    gammaFilter.gamma = 3.0;//(ps:0 ~ 3.0)
    [self getImageDataSource:gammaFilter];
    
    self.changeImgView.image = [gammaFilter imageFromCurrentFramebuffer];
}
//锐化
-(void)sharpenFilterTest{
    GPUImageSharpenFilter *filter = [[GPUImageSharpenFilter alloc]init];
    filter.sharpness = 0.5;//锐化-4.0 ~ 4.0
    [filter useNextFrameForImageCapture];
    
    [self getImageDataSource:filter];
    self.changeImgView.image =[filter imageFromCurrentFramebuffer];
}

//通常用于创建阴影和深度效果(ps:混合模式 Blend,只能两张)
-(void)multiplyBlendFilterTest{
    
//    GPUImagePicture *stillImageSource1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"01.jpg"]];
    
    GPUImagePicture *stillImageSource2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"02.jpg"]];
    
    GPUImagePicture *stillImageSource3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"04.jpg"]];
    
    GPUImageMultiplyBlendFilter *blendFilter = [[GPUImageMultiplyBlendFilter alloc] init];
    
//    [stillImageSource1 addTarget:blendFilter];
//    [stillImageSource1 processImage];
    [stillImageSource2 addTarget:blendFilter];
    [stillImageSource2 processImage];
    [stillImageSource3 addTarget:blendFilter];
    [stillImageSource3 processImage];
    
    [blendFilter useNextFrameForImageCapture];
    
    CGRect frame = self.changeImgView.frame;
    frame.size.height = 400.0;
    self.changeImgView.frame = frame;
    
    self.changeImgView.image = [blendFilter imageFromCurrentFramebuffer];

}
//反色
-(void)colorInvertFilterTest{
   GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc]init];
    [filter useNextFrameForImageCapture];
    //获取图片数据源
    [self getImageDataSource:filter];
    
    self.changeImgView.image = [filter imageFromCurrentFramebuffer];
}

//高斯模糊
-(void)gaussianBlurFilterTest{
    //创建高斯模糊滤镜
  GPUImageGaussianBlurFilter *blurFilter =  [[GPUImageGaussianBlurFilter alloc]init];
    [blurFilter setTexelSpacingMultiplier:1.0];
    [blurFilter setBlurRadiusInPixels:1.0];
    [blurFilter forceProcessingAtSize:self.changeImgView.bounds.size];
    //获取图片数据源
    [self getImageDataSource:blurFilter];
    [blurFilter useNextFrameForImageCapture];
   self.changeImgView.image = [blurFilter imageFromCurrentFramebuffer];
}

//晕影，形成黑色圆形边缘，突出中间图像的效果
-(void)vignetteFilterTest{
    //创建滤镜
    GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc]init];
    //设置滤镜参数
    [vignetteFilter forceProcessingAtSize:self.changeImgView.bounds.size];
    [vignetteFilter useNextFrameForImageCapture];
    
    [self getImageDataSource:vignetteFilter];
    
    self.changeImgView.image = [vignetteFilter imageFromCurrentFramebuffer];//获取渲染后的图片;
}
//获取图片数据源
-(void)getImageDataSource:(id<GPUImageInput>)filter{
    
    GPUImagePicture *picture = [[GPUImagePicture alloc]initWithImage:self.changeImgView.image];
    [picture addTarget:filter];
    [picture processImage];

}
#pragma mark - setter
-(NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr = @[@"01.jpg",@"02.jpg",@"03.jpg",@"04.jpg",@"05.jpeg"];
    }
    return _imgArr;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"晕影",@"高斯模糊",@"反色",@"Blend",@"锐化",@"伽马线",@"7"];
    }
    return _dataArr;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _nextBtn.frame = CGRectMake(self.view.bounds.size.width-110.0, self.view.bounds.size.height - 100, 80, 30);
        _nextBtn.tag = 2000;
        [_nextBtn setTitle:@"下一张" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.backgroundColor = [UIColor grayColor];
        [_nextBtn addTarget:self action:@selector(BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}
-(UIButton *)upBtn{
    if (!_upBtn) {
        _upBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _upBtn.frame = CGRectMake(30, self.view.bounds.size.height - 100, 80, 30);
        _upBtn.tag = 2001;
        [_upBtn setTitle:@"上一张" forState:(UIControlStateNormal)];
        [_upBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _upBtn.backgroundColor = [UIColor grayColor];
        [_upBtn addTarget:self action:@selector(BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _upBtn;
}
@end

@implementation CustomCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
