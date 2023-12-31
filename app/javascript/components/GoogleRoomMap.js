import React from 'react';
import {
  DirectionsRenderer,
  GoogleMap,
  LoadScript,
  Marker,
} from '@react-google-maps/api';
import LocationButton from './LocationButton';
import RouteButton from './RouteButton';
import Swal from 'sweetalert2';

const mapOptions = {
  zoomControl: true,
  streetViewControl: true,
  mapTypeControl: false,
  fullscreenControl: false,
};

class GoogleRoomMap extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      map: /** @type google.maps.Map */ (null),
      origin: {},
      directionResponse: null,
      distance: '',
      duration: '',
    };
  }

  async getGeolocation() {
    let origin = await fetch(
      `https://www.googleapis.com/geolocation/v1/geolocate?key=${this.props.api_key}`,
      {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
      }
    )
      .then((resp) => resp.json())
      .then((location) => location.location)
      .catch(() => Swal.fire({
        icon: 'error',
        title: 'Oops...',
        text: 'Something went wrong!'
      }))

    this.setState({ origin: origin });
  }

  async calculateRoute() {
    if (this.state.origin === {}) {
      return;
    }

    let center = { lat: this.props.lat, lng: this.props.lng };
    let directionService = new google.maps.DirectionsService();
    let results = await directionService.route({
      origin: new google.maps.LatLng(
        this.state.origin.lat,
        this.state.origin.lng
      ),
      destination: new google.maps.LatLng(center.lat, center.lng),
      travelMode: google.maps.TravelMode.DRIVING,
    });

    this.setState({ directionResponse: results });
    this.setState({ distance: results.routes[0].legs[0].distance.text });
    this.setState({ duration: results.routes[0].legs[0].duration.text });
  }

  render() {
    let center = { lat: this.props.lat, lng: this.props.lng };

    return (
      <LoadScript googleMapsApiKey={this.props.api_key}>
        <div className='relative'>
          <GoogleMap
            mapContainerStyle={{
              width: '100%',
              height: '480px',
            }}
            center={center}
            zoom={15}
            options={mapOptions}
            onLoad={(map) => {
              this.setState({ map: map });
              this.getGeolocation();
            }}
          >
            {/* Child components, such as markers, info windows, etc. */}
            {!this.state.directionResponse && <Marker position={center} />}
            {this.state.directionResponse && (
              <>
                <DirectionsRenderer directions={this.state.directionResponse} />
                <h2 className='absolute p-5 font-bold bg-white border rounded-lg shadow-xl top-2 left-20'>
                  <div className='gradient-text'>
                    距離：{this.state.distance}
                  </div>
                  <div className='gradient-text'>
                    車程：{this.state.duration}
                  </div>
                </h2>
              </>
            )}
          </GoogleMap>
          <LocationButton
            onClick={() => {
              this.state.map.panTo(center);
              this.state.map.setZoom(15);
              this.setState({ directionResponse: null });
            }}
          />
          <RouteButton onClick={this.calculateRoute.bind(this)} />
        </div>
      </LoadScript>
    );
  }
}

export default GoogleRoomMap;
