import { Helmet } from 'react-helmet-async';

import { FareView } from 'src/sections/fare/view';

// ----------------------------------------------------------------------

export default function FarePage() {
  return (
    <>
      <Helmet>
        <title> Fare | Halaman Data Fare </title>
      </Helmet>

      <FareView />
    </>
  );
}
