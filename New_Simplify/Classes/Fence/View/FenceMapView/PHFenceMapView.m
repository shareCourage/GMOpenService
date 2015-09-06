//
//  PHFenceMapView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceMapView.h"
#import "PHFenceMap.h"
#import "PHFenceAnnotation.h"

@interface PHFenceMapView ()

@end

@implementation PHFenceMapView


- (void)setFenceMap:(PHFenceMap *)fenceMap
{
    _fenceMap = fenceMap;
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
    [self.bmkMapView removeAnnotations:self.bmkMapView.annotations];
    if ((fenceMap.coords.count >= 3)) {//多边形
        [self addPolygonWithCoords:fenceMap.coords];
        [self.bmkMapView setCenterCoordinate:[self averageCoord:fenceMap.coords] animated:YES];

    }
    else if (fenceMap.coords.count == 2){//直线
        [self addPolylineWithCoords:fenceMap.coords];
    }
    else if (fenceMap.coords.count < 2) {//圆形
        if (fenceMap.coords.count == 1) {
            free([self transitToCoords:fenceMap.coords]);
        }
        else {
            [self addCircleWithCoordinate:fenceMap.coordinate radius:fenceMap.radius];
            [self addAnnotationWithCoordinate:fenceMap.coordinate];
        }
    }
}

/**
 *  计算经纬度的平均值
 */
- (CLLocationCoordinate2D)averageCoord:(NSArray *)coords {
    double lats = 0;
    double lngs = 0;
    for (NSString *obj in coords) {
        NSArray *objArray = [NSArray seprateString:obj characterSet:@","];
        NSString *lat = [objArray firstObject];
        NSString *lng = [objArray lastObject];
        lats += [lat doubleValue];
        lngs += [lng doubleValue];
    }
    return CLLocationCoordinate2DMake(lats / coords.count, lngs / coords.count);
}

/**
 *  添加BMKPolyline
 *
 */
- (void)addPolylineWithCoords:(NSArray *)coords
{
    CLLocationCoordinate2D *coordsC = [self transitToCoords:coords];
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coordsC count:coords.count];
    [self.bmkMapView addOverlay:polyline];
    free(coordsC);
}

/**
 *  添加BMKPolygon
 *
 */
- (void)addPolygonWithCoords:(NSArray *)coords
{
    CLLocationCoordinate2D *coordsC = [self transitToCoords:coords];
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coordsC count:coords.count];
    [self.bmkMapView addOverlay:polygon];
    free(coordsC);
}
- (CLLocationCoordinate2D *)transitToCoords:(NSArray *)coords
{
    int count = (int)coords.count;
    CLLocationCoordinate2D *coordsC = malloc(sizeof(CLLocationCoordinate2D) * count);
    int i = 0;
    for (NSString *obj in coords) {
        NSArray *objArray = [NSArray seprateString:obj characterSet:@","];
        NSString *lat = [objArray firstObject];
        NSString *lng = [objArray lastObject];
        coordsC[i].latitude = [lat doubleValue];
        coordsC[i].longitude = [lng doubleValue];
        [self addAnnotationWithCoordinate:coordsC[i]];
        i ++;
    }
    return coordsC;
}
/**
 *  添加BMKCircle
 *
 */
- (void)addCircleWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(double)radius
{
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coordinate radius:radius];
    [self.bmkMapView addOverlay:circle];
}

/**
 *  添加PHFenceAnnotation大头针
 *
 */
- (void)addAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_fenceMap.coords.count == 0) {//判断是圆形时，才设置地图中心点
        [self.bmkMapView setCenterCoordinate:coordinate animated:YES];
    }
    PHFenceAnnotation *fenceAn = [PHFenceAnnotation fenceAnnotation];
    fenceAn.coordinate = coordinate;
    [self.bmkMapView addAnnotation:fenceAn];
}






#pragma mark - BMKMapViewDelegate

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        circleView.lineWidth = 3.0;
        return circleView;
    }
    else if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        polygonView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    else if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [super mapView:mapView regionDidChangeAnimated:animated];
    if ([self.delegate respondsToSelector:@selector(fenceMapViewRegionDidChanged:)]) {
        [self.delegate fenceMapViewRegionDidChanged:self];
    }
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    if ([self.delegate respondsToSelector:@selector(fenceMapView:onLongClick:)]) {
        [self.delegate fenceMapView:self onLongClick:coordinate];
    }
}



//#if 0
- (CLLocationDistance)calculateDistanceBetweenLeftAndRightPoint
{
    CGPoint leftP = CGPointMake(0, 0);
    CGPoint rightP = CGPointMake(PH_WidthOfScreen, 0);
    CLLocationCoordinate2D leftCoor = [self.bmkMapView convertPoint:leftP toCoordinateFromView:self];
    CLLocationCoordinate2D rightCoor = [self.bmkMapView convertPoint:rightP toCoordinateFromView:self];
    PHLog(@"leftCoor ->%.6f,%.6f",leftCoor.latitude,leftCoor.longitude);
    PHLog(@"rightCoor->%.6f,%.6f",rightCoor.latitude,rightCoor.longitude);
    BMKMapPoint aPoint = BMKMapPointForCoordinate(leftCoor);
    BMKMapPoint bPoint = BMKMapPointForCoordinate(rightCoor);
    CLLocationDistance distance= BMKMetersBetweenMapPoints(aPoint, bPoint);
    PHLog(@"distance->%.3f",distance);
    
    return distance;
}
//#endif

@end






