import { Helmet } from 'react-helmet-async';

import { DriverView } from 'src/sections/driver/view';

// ----------------------------------------------------------------------

export default function DriverPage() {
  return (
    <>
      <Helmet>
        <title> Driver | Halaman Data Driver </title>
      </Helmet>

      <DriverView />
    </>
  );
}
