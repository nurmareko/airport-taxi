import { Helmet } from 'react-helmet-async';

import { RideView } from 'src/sections/ride/view';

// ----------------------------------------------------------------------

export default function RidePage() {
  return (
    <>
      <Helmet>
        <title> Ride | Halaman Data Ride </title>
      </Helmet>

      <RideView />
    </>
  );
}
