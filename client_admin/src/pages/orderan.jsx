import { Helmet } from 'react-helmet-async';

import { OrderanView } from 'src/sections/orderan/view';

// ----------------------------------------------------------------------

export default function OrderanPage() {
  return (
    <>
      <Helmet>
        <title> Orderan | Halaman Data Orderan </title>
      </Helmet>

      <OrderanView />
    </>
  );
}
