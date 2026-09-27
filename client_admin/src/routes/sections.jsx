import { lazy, Suspense } from 'react';
import { Outlet, Navigate, useRoutes } from 'react-router-dom';

import DashboardLayout from 'src/layouts/dashboard';


export const IndexPage = lazy(() => import('src/pages/app'));
export const BlogPage = lazy(() => import('src/pages/blog'));
export const UserPage = lazy(() => import('src/pages/user'));
export const CustomerPage = lazy(() => import('src/pages/customer'));
export const DriverPage = lazy(() => import('src/pages/driver'));
export const FarePage = lazy(() => import('src/pages/fare'));
export const RidePage = lazy(() => import('src/pages/ride'));
export const OrderanPage = lazy(() => import('src/pages/orderan'));
export const LoginPage = lazy(() => import('src/pages/login'));
export const ProductsPage = lazy(() => import('src/pages/products'));
export const Page404 = lazy(() => import('src/pages/page-not-found'));

// ----------------------------------------------------------------------

export default function Router() {
  const routes = useRoutes([
    {
      element: (
        <DashboardLayout>
          <Suspense>
            <Outlet />
          </Suspense>
        </DashboardLayout>
      ),
      children: [
        { element: <IndexPage />, index: true },
        { path: 'customer', element: <CustomerPage /> },
        { path: 'driver', element: <DriverPage /> },
        { path: 'fare', element: <FarePage /> },
        { path: 'ride', element: <RidePage /> },
        { path: 'orderan', element: <OrderanPage /> },
        
      ],
    },
    {
      path: 'login',
      element: <LoginPage />,
    },
    {
      path: '404',
      element: <Page404 />,
    },
    {
      path: '*',
      element: <Navigate to="/404" replace />,
    },
  ]);

  return routes;
}
