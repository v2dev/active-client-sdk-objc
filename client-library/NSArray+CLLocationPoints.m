//
//  NSArray+CLLocationPoints.m
//  Percero
//
//  Created by Jeff Wolski on 9/11/13.
//
//

#import "NSArray+CLLocationPoints.h"

CLLocationCoordinate2D distanceMultipilersFromReferenceLocation(CLLocation *location);
void coordinatesInMetersFromCLLocationPoints(NSArray *points, CLLocationCoordinate2D * coordinates);

CLLocationCoordinate2D distanceMultipilersFromReferenceLocation(CLLocation *location)
{
    CLLocationCoordinate2D distanceMultipliers = { 0 };
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    CLLocationDistance northingDistance = 0.0;
    CLLocationDistance eastingDistance = 0.0;
    
    CLLocation *northLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude + 1];
    northingDistance = [location distanceFromLocation:northLocation];
    
    CLLocation *eastLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude+1 longitude:coordinate.longitude];
    eastingDistance = [location distanceFromLocation:eastLocation];
    
    distanceMultipliers.latitude = eastingDistance;
    distanceMultipliers.longitude = northingDistance;
    
    return distanceMultipliers;
}

void coordinatesInMetersFromCLLocationPoints(NSArray *points, CLLocationCoordinate2D * coordinates)
{
    NSUInteger pointsCount = points.count;
    CLLocationCoordinate2D distanceMultipliers = distanceMultipilersFromReferenceLocation(points[0]);
    
    // populated the coordinates array with point coordinates
    for (NSUInteger pointIndex = 0 ; pointIndex < pointsCount ; pointIndex++) {
        CLLocation *point = points[pointIndex];
        CLLocationCoordinate2D coordinate = [point coordinate];
        coordinates[pointIndex] = coordinate;
    };
    
    // translate and scale to meters all coordinates
    CLLocationCoordinate2D referenceCoordinate = coordinates[0];
    for (NSUInteger coordinateIndex = 0 ; coordinateIndex < pointsCount ; coordinateIndex++) {
        CLLocationCoordinate2D coordinate = coordinates[coordinateIndex];
        coordinate.latitude -= referenceCoordinate.latitude;
        coordinate.longitude -= referenceCoordinate.longitude;
        
        coordinate.latitude *= distanceMultipliers.latitude;
        coordinate.longitude *= distanceMultipliers.longitude;
    };
    
}


@implementation NSArray (CLLocationPoints)

- (double) areaInMeters{
    NSUInteger selfCount = self.count;
    CLLocationCoordinate2D coordinates[selfCount];
    coordinatesInMetersFromCLLocationPoints(self, coordinates);
    
    double sumA = 0.0;
    double sumB = 0.0;
    double area = 0.0;
    
    for (NSUInteger coordinateIndex = 0; coordinateIndex < selfCount; coordinateIndex++) {
        sumA += .5 * coordinates[coordinateIndex].latitude * coordinates[(coordinateIndex + 1) % selfCount].longitude;
        sumB += .5 * coordinates[coordinateIndex].longitude * coordinates[(coordinateIndex + 1) % selfCount].latitude;
    }
    
    area = fabs(sumA - sumB);
    
    return area;
}

- (double) areaInAcres{

    return [self areaInMeters] * 4046.8252519;

}
@end
