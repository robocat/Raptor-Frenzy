#import "GKExtras.h"

NSString *NSStringFromGKPeerConnectionState(GKPeerConnectionState state) {
	switch (state) {
		case GKPeerStateUnavailable :
			return @"Unavailable";
		case GKPeerStateAvailable :
			return @"Available";
		case GKPeerStateConnecting :
			return @"Connecting";
		case GKPeerStateConnected :
			return @"Connected";
		case GKPeerStateDisconnected :
			return @"Disconnected";
		default:
			return @"Unknown!!";
	}
}
