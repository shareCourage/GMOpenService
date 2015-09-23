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

- (void)removeMapViewOverlays {
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
    [self.bmkMapView removeAnnotations:self.bmkMapView.annotations];
}
- (void)setFenceMap:(PHFenceMap *)fenceMap
{
    _fenceMap = fenceMap;
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
    [self.bmkMapView removeAnnotations:self.bmkMapView.annotations];
    if ((fenceMap.coords.count >= 3)) {//多边形
        [self addPolygonWithCoords:fenceMap.coords];
        [self.bmkMapView setCenterCoordinate:[self averageCoord:fenceMap.coords] animated:YES];
        [self settingMapViewZoomLevelWithDistance:[self maxDistanceOfCoords:fenceMap.coords]];

    }
    else if (fenceMap.coords.count == 2){//直线
        [self addPolylineWithCoords:fenceMap.coords];
    }
    else if (fenceMap.coords.count < 2) {//圆形
        if (fenceMap.coords.count == 1) {
            free([self transitToCoords:fenceMap.coords]);
        }
        else {
            if (fenceMap.coordinate.latitude == 0 || fenceMap.coordinate.longitude == 0) return;
            [self settingMapViewZoomLevelWithDistance:(CGFloat)fenceMap.radius * 2];
            [self addAnnotationWithCoordinate:fenceMap.coordinate];
            [self addCircleWithCoordinate:fenceMap.coordinate radius:fenceMap.radius];
        }
    }
}
- (void)settingMapViewZoomLevelWithDistance:(CGFloat)distance {
    if (distance <= 0) return;
    if (distance < 200) {
        self.bmkMapView.zoomLevel = 19;
    }
    else if (distance < 600) {
        self.bmkMapView.zoomLevel = 18;
    }
    else if (distance < 1000) {
        self.bmkMapView.zoomLevel = 17;
    }
    else if (distance < 2400) {
        self.bmkMapView.zoomLevel = 16;
    }
    else if (distance < 4800) {
        self.bmkMapView.zoomLevel = 15;
    }
    else if (distance < 9600) {
        self.bmkMapView.zoomLevel = 14;
    }
    else if (distance < 18000) {
        self.bmkMapView.zoomLevel = 13;
    }
    else if (distance < 10000) {
        self.bmkMapView.zoomLevel = 12.5f;
    }
    else if (distance < 40000) {
        self.bmkMapView.zoomLevel = 12;
    }
    else if (distance < 100000) {
        self.bmkMapView.zoomLevel = 11;
    }
    else if (distance < 200000) {
        self.bmkMapView.zoomLevel = 10;
    }
    else if (distance < 400000) {
        self.bmkMapView.zoomLevel = 9;
    }
    else if (distance < 600000) {
        self.bmkMapView.zoomLevel = 8;
    }
    else if (distance < 1200000) {
        self.bmkMapView.zoomLevel = 7;
    }
    else if (distance < 2500000) {
        self.bmkMapView.zoomLevel = 6;
    }
    else if (distance < 5000000) {
        self.bmkMapView.zoomLevel = 5;
    }
    else if (distance < 10000000) {
        self.bmkMapView.zoomLevel = 4;
    }
    else if (distance < 20500000) {
        self.bmkMapView.zoomLevel = 3;
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

- (CLLocationDistance)maxDistanceOfCoords:(NSArray *)coords {
    CLLocationDistance distance = 0.0;
    NSString *coordStr1 = [coords firstObject];
    CLLocationCoordinate2D coordA = [self coordsFromString:coordStr1];
    for (int i = 1; i < coords.count; i ++) {
        NSString *coordStr2 = coords[i];
        CLLocationCoordinate2D coordB = [self coordsFromString:coordStr2];
        CLLocationDistance abDistance = [self distanceFromCoordA:coordA toCoordB:coordB];
        if (distance < abDistance) {
            distance = abDistance;
        }
    }
//    PHLog(@"maxDistance->%.2f",distance);
    return distance;
}

- (CLLocationCoordinate2D)coordsFromString:(NSString *)string {
    NSArray *objArray = [NSArray seprateString:string characterSet:@","];
    NSString *lat = [objArray firstObject];
    NSString *lng = [objArray lastObject];
    return CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
}
- (CGFloat)distanceBetweenCoordA:(CLLocationCoordinate2D)coordA coordB:(CLLocationCoordinate2D)coordB {
    CGFloat lat = fabs(coordA.latitude - coordB.latitude);
    CGFloat lng = fabs(coordA.longitude - coordB.longitude);
    return sqrt(lat * lat + lng * lng);
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
    PHLog(@"zoomlevel->%.f",mapView.zoomLevel);
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    if ([self.delegate respondsToSelector:@selector(fenceMapView:onClickBlank:)]) {
        [self.delegate fenceMapView:self onClickBlank:coordinate];
    }
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    if ([self.delegate respondsToSelector:@selector(fenceMapView:onLongClick:)]) {
        [self.delegate fenceMapView:self onLongClick:coordinate];
    }
}


- (CLLocationDistance)distanceFromCoordA:(CLLocationCoordinate2D)coordA toCoordB:(CLLocationCoordinate2D)coordB
{
    BMKMapPoint pointA = BMKMapPointForCoordinate(coordA);
    BMKMapPoint pointB = BMKMapPointForCoordinate(coordB);
    CLLocationDistance distance= BMKMetersBetweenMapPoints(pointA, pointB);
    return distance;
}

@end






