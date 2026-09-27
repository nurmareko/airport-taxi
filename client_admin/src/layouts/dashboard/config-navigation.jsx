import SvgColor from 'src/components/svg-color';

// ----------------------------------------------------------------------

const icon = (name) => (
  <SvgColor src={`/assets/icons/navbar/${name}.svg`} sx={{ width: 1, height: 1 }} />
);

const navConfig = [
  {
    title: 'dashboard',
    path: '/',
    icon: icon('dashboard-svgrepo-com'),
  },
  {
    title: 'customer',
    path: '/customer',
    icon: icon('users-young-svgrepo-com'),
  },
  {
    title: 'driver',
    path: '/driver',
    icon: icon('id-card-svgrepo-com'),
  },
  {
    title: 'pengantaran',
    path: '/ride',
    icon: icon('destination-direction-filled-svgrepo-com'),
  },
  {
    title: 'orderan',
    path: '/orderan',
    icon: icon('choices-order-svgrepo-com'),
  },
  {
    title: 'tarif',
    path: '/fare',
    icon: icon('rupiah-2-svgrepo-com'),
  },
  
];

export default navConfig;
