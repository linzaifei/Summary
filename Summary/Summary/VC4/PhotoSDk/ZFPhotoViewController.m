//
//  ZFPhotoViewController.m
//  Summary
//
//  Created by xinshiyun on 2017/4/12.
//  Copyright © 2017年 林再飞. All rights reserved.
//

#import "ZFPhotoViewController.h"
#import <Photos/Photos.h>
#import "ZFAsset.h"
#import "ZFPhotoHeadView.h"
#import "ZFPhotoCollectionViewCell.h"
@interface ZFPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *dataArr;
@property(strong,nonatomic)NSMutableArray <PHAsset *>*seletedPhotos;
@property(strong,nonatomic)NSMutableDictionary *selectedAssetsDic;
@end

@implementation ZFPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self loadData];
}
-(instancetype)init{
    if (self = [super init]) {
        self.columnCount = 3;
        self.columnSpacing = 5;
        self.rowSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.maxCount = 9;
    }
    return self;
}

-(void)setNavi{
    ZFPhotoHeadView *photoHeadView = [ZFPhotoHeadView new];
    photoHeadView.barTintColor = [UIColor brownColor];
    photoHeadView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:photoHeadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = self.sectionInset;
    CGFloat itemWidth = (kScreenWidth - self.rowSpacing * (self.columnCount - 1) - self.sectionInset.left - self.sectionInset.right) / self.columnCount;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ZFPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZFPhotoCollectionViewCell class])];
   
    __weak ZFPhotoViewController *ws = self;
    photoHeadView.cancelBlock = ^(){
        [ws dismissViewControllerAnimated:YES completion:NULL];
    };
    photoHeadView.chooseBlock = ^(){
        if ([ws.delegate respondsToSelector:@selector(photoPickerViewController:didSelectPhotos:)]) {
            [ws.delegate photoPickerViewController:ws didSelectPhotos:[ws.seletedPhotos copy]];
        }
    };
    

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[photoHeadView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(photoHeadView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[photoHeadView(==64)]-0-[_collectionView]-0-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(photoHeadView,_collectionView)]];
}

-(void)loadData{

    /*
    PHFetchResult<PHAssetCollection *> *assetAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    // 遍历所有的自定义相簿
    __weak ZFPhotoViewController *ws = self;
    [assetAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ws enumerateAssetsInAssetCollection:obj original:YES];
    }];
    
   */

    // 获得相机胶卷
    PHAssetCollection *Libararys = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:Libararys original:YES];
     
}
/**
 遍历所有照片
 
 @param assetCollection 相簿
 @param original 是不是原始图片
 */

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original{
    //相簿名
    NSLog(@"title = %@",assetCollection.localizedTitle);
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> * assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    
    [self.dataArr removeAllObjects];
    UIImage *cameraImage = [UIImage imageNamed:[@"ZFPhotoBundle.bundle" stringByAppendingPathComponent:@"AssetsCamera.png"]];
    [cameraImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.dataArr addObject:cameraImage];
    /*
     synchronous：指定请求是否同步执行。
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
     */
    __weak ZFPhotoViewController *ws = self;
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:obj];
    }];
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZFPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZFPhotoCollectionViewCell class]) forIndexPath:indexPath];
    id data = self.dataArr[indexPath.item];
    [cell zf_setAssest:data];
    
    BOOL isSelected = NO;
    if ([data isKindOfClass:[PHAsset class]]) {
        PHAsset *asset = (PHAsset *)data;
        if ([self.selectedAssetsDic valueForKey:asset.localIdentifier]) {
            isSelected = YES;
        }
    }
    cell.isSelect = isSelected;
    
    __weak ZFPhotoViewController *ws = self;
    __weak ZFPhotoCollectionViewCell *weakCell = cell;
    cell.btnSelectBlock = ^(PHAsset *asset, BOOL isSelect) {
        NSString *urlKey = asset.localIdentifier;
        if ([self.selectedAssetsDic valueForKey:urlKey]) {
            weakCell.isSelect = NO;
            [self.seletedPhotos removeObject:self.selectedAssetsDic[urlKey]];
            [self.selectedAssetsDic removeObjectForKey:urlKey];
        }else {
            if (self.seletedPhotos.count>=self.maxCount) {
//                 [RemindView showViewWithTitle:[NSString stringWithFormat:@"%@%lu", NSLocalizedString(@"最多选择", nil), (unsigned long)self.maxCount] location:LocationTypeMIDDLE];
                return;
            }
            weakCell.isSelect = YES;
            [ws.selectedAssetsDic setObject:asset forKey:urlKey];
            [ws.seletedPhotos addObject:asset];
        }

    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}

-(void)setSelectItems:(NSArray<PHAsset *> *)selectItems{
    for (PHAsset *asset in selectItems) {
        if (asset) {
            [self.selectedAssetsDic setValue:asset forKey:asset.localIdentifier];
        }
        [self.seletedPhotos addObject:asset];
    }
}


-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray <PHAsset *>*)seletedPhotos{
    if (_seletedPhotos == nil) {
        _seletedPhotos = [NSMutableArray array];
    }
    return _seletedPhotos;
}

- (NSMutableDictionary *)selectedAssetsDic {
    if (_selectedAssetsDic == nil) {
        _selectedAssetsDic = [NSMutableDictionary dictionary];
    }
    return _selectedAssetsDic;
}

#pragma mark  --- 相册获取参考数据
//获取自定义相册簿 （自己创建的相册）
/*
 Album //从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
 SmartAlbum //经由相机得来的相册
 Moment //Photos 为我们自动生成的时间分组的相册
 */


/*
 enum PHAssetCollectionSubtype : Int {
 case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
 case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
 case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
 case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
 case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
 case AlbumMyPhotoStream //用户的 iCloud 照片流
 case AlbumCloudShared //用户使用 iCloud 共享的相册
 case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
 case SmartAlbumPanoramas //相机拍摄的全景照片
 case SmartAlbumVideos //相机拍摄的视频
 case SmartAlbumFavorites //收藏文件夹
 case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
 case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
 case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
 case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
 case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。
 case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
 case Any //包含所有类型
 }
 */


/*
 info 信息
 
 PHImageFileOrientationKey = 0;
 PHImageFileSandboxExtensionTokenKey = "298fd95ea90e3a96018632dba00e53e37ad85426;00000000;00000000;000000000000001a;com.apple.app-sandbox.read;00000001;01000003;00000000000382d7;/private/var/mobile/Media/DCIM/100APPLE/IMG_0197.JPG";
 PHImageFileURLKey = "file:///var/mobile/Media/DCIM/100APPLE/IMG_0197.JPG";
 PHImageFileUTIKey = "public.jpeg";
 PHImageResultDeliveredImageFormatKey = 9999;
 PHImageResultIsDegradedKey = 0;
 PHImageResultIsInCloudKey = 0;
 PHImageResultIsPlaceholderKey = 0;
 PHImageResultOptimizedForSharing = 0;
 PHImageResultWantedImageFormatKey = 4035;
 */


-(void)dealloc{
    NSLog(@"销毁 %s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
