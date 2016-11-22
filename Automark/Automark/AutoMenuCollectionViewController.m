//
//  AutoMenuCollectionViewController.m
//  Automark
//
//  Created by Melanie Hsu on 11/21/16.
//  Copyright © 2016 Melanie Hsu. All rights reserved.
//

#import "AutoMenuCollectionViewController.h"
#import "CameraViewController.h"
#import "CustomizePhotoViewController.h"

@interface AutoMenuCollectionViewController () {
    NSArray *menuPhotos;
    CameraViewController *camVC;
    CustomizePhotoViewController *custVC;
}

@end

@implementation AutoMenuCollectionViewController

static NSString * const reuseIdentifier = @"MenuCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize menu image array
    menuPhotos = [NSArray arrayWithObjects:[UIImage imageNamed:@"CameraW"], [UIImage imageNamed:@"CollageW"], [UIImage imageNamed:@"Border"], [UIImage imageNamed:@"Marker"], nil];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:100 green:82 blue:86 alpha:0.66];
    cell.layer.cornerRadius = 16.0;
    
    UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:100];
    if (cellImageView) {
        
    } else {
        cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [cell addSubview:cellImageView];
        cellImageView.tag = 100;
    }
    cellImageView.image = [[menuPhotos objectAtIndex:indexPath.row] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cellImageView setTintColor:[UIColor brownColor]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        camVC = [[CameraViewController alloc] init];
        [self presentViewController:camVC animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        NSLog(@"Collage");
    } else if (indexPath.row == 2) {
        custVC = [[CustomizePhotoViewController alloc] init];
        [self presentViewController:custVC animated:YES completion:nil];
    } else {
        NSLog(@"Marker");
    }
}


#pragma mark UICollectionViewDelegateFlowLayout methods
/* This protocol defines methods allowing coordination with a UICollectionViewFlowLayout object to implement a grid-based layout. Methods define the size of items and spacing between items in the grid. */

// Asks the delegate for the size of the specified item's cell
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

// Asks the delegate for the margins to apply to the content in the specified section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(98.0, 98.0, 98.0, 98.0);
}

// Asks the delegate for the spacing between successive rows or columns of a section
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}

// Asks the delegate for the spacing between successive items in the rows or columns of a section.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}

@end
