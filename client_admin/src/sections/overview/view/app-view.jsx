import React, { useState, useEffect } from 'react';
import {
  Pie,
  Cell,
  Legend,
  Tooltip,
  PieChart,
  ResponsiveContainer,
} from 'recharts'; // Import recharts

import Grid from '@mui/material/Unstable_Grid2';
import { Card, Container, Typography } from '@mui/material';
import CircularProgress from '@mui/material/CircularProgress';

import { useRouter } from 'src/routes/hooks';

import AppWidgetSummary from '../app-widget-summary';

export default function AppView() {
  const [customerCount, setCustomerCount] = useState(0);
  const [driverCount, setDriverCount] = useState(0);
  const [rideCount, setRideCount] = useState(0);
  const [orderCount, setOrderCount] = useState(0);
  const [loading, setLoading] = useState(true); // Loading state
  const [rideChartData, setRideChartData] = useState([]);
  const [orderChartData, setOrderChartData] = useState([]);
  const token = localStorage.getItem('authToken');
  const router = useRouter();

  useEffect(() => {
    const fetchData = async (url, setData) => {
      try {
        const response = await fetch(url, {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (!response.ok) {
          throw new Error(`Failed to fetch data from ${url}`);
        }

        const { data } = await response.json();
        setData(data.length);
      } catch (error) {
        console.error(`Error fetching data from ${url}:`, error);
        setData(0); // In case of an error, set to 0
        router.push('/login');
      }
    };

    const fetchRideChartData = async () => {
      try {
        const response = await fetch('http://localhost:3000/api/admin/getRide', {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch ride data');
        }

        const { data } = await response.json();

        const statusCounts = data.reduce((acc, ride) => {
          const statusText = getLabelText(ride.rideStatus);
          acc[statusText] = acc[statusText] ? acc[statusText] + 1 : 1;
          return acc;
        }, {});

        const preparedChartData = Object.keys(statusCounts).map((key) => ({
          name: key,
          value: statusCounts[key],
        }));

        setRideChartData(preparedChartData);
      } catch (error) {
        console.error('Error fetching ride data:', error);
      } finally {
        setLoading(false);
      }
    };

    const fetchOrderChartData = async () => {
      try {
        const response = await fetch('http://localhost:3000/api/admin/getOrderan', {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch order data');
        }

        const { data } = await response.json();

        const statusCounts = data.reduce((acc, order) => {
          const statusText = getStatusLabel(order.status);
          acc[statusText] = acc[statusText] ? acc[statusText] + 1 : 1;
          return acc;
        }, {});

        const preparedOrderData = Object.keys(statusCounts).map((key) => ({
          name: key,
          value: statusCounts[key],
        }));

        setOrderChartData(preparedOrderData);
      } catch (error) {
        console.error('Error fetching order data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData('http://localhost:3000/api/admin/getCustomer', setCustomerCount);
    fetchData('http://localhost:3000/api/admin/getDriver', setDriverCount);
    fetchData('http://localhost:3000/api/admin/getRide', setRideCount);
    fetchData('http://localhost:3000/api/admin/getOrderan', setOrderCount);
    fetchRideChartData();
    fetchOrderChartData();
  }, [token, router]);

  const getLabelText = (rideStatus) => {
    switch (rideStatus) {
      case 0:
        return 'Sedang Proses';
      case 1:
        return 'Selesai Mengantar';
      case 2:
        return 'Batal';
      case 3:
        return 'Selesai';
      default:
        return 'Tidak Diketahui';
    }
  };

  const getStatusLabel = (status) => {
    switch (status) {
      case 1:
        return 'Sedang Proses';
      case 2:
        return 'Menjemput Customer';
      case 3:
        return 'Menuju Bandara';
      case 4:
        return 'Selesai';
      case 5:
        return 'Dibatalkan Customer';
      case 6:
        return 'Dibatalkan Driver';
      case 7:
        return 'Ditolak Driver';
      default:
        return 'Tidak Selesai';
    }
  };

  const COLORS = {
    'Sedang Proses': '#FFD700', // Kuning
    'Selesai Mengantar': '#00CFFF', // Biru info
    'Batal': '#E57373', // Merah gelap
    'Selesai': '#66BB6A', // Hijau gelap,
    'Menjemput Customer': '#00BFFF', // Biru muda
    'Menuju Bandara': '#0099FF', // Biru gelap
    'Dibatalkan Customer': '#E57373',
    'Dibatalkan Driver': '#EF5350',
    'Ditolak Driver': '#D32F2F',
  };

  if (loading) {
    return (
      <Container>
        <CircularProgress />
      </Container>
    );
  }

  return (
    <Container maxWidth="xl">
      <Typography variant="h4" sx={{ mb: 5 }}>
        Hi, Welcome Back Admin👋
      </Typography>

      <Grid container spacing={3}>
        <Grid xs={12} sm={6} md={3}>
          <AppWidgetSummary
            title="Customer"
            total={customerCount}
            color="success"
            icon={<img alt="icon" src="/assets/icons/service.png" />}
          />
        </Grid>

        <Grid xs={12} sm={6} md={3}>
          <AppWidgetSummary
            title="Driver"
            total={driverCount}
            color="info"
            icon={<img alt="icon" src="/assets/icons/license.png" />}
          />
        </Grid>

        <Grid xs={12} sm={6} md={3}>
          <AppWidgetSummary
            title="Pengantaran"
            total={rideCount}
            color="warning"
            icon={<img alt="icon" src="/assets/icons/destination.png" />}
          />
        </Grid>

        <Grid xs={12} sm={6} md={3}>
          <AppWidgetSummary
            title="Orderan"
            total={orderCount}
            color="error"
            icon={<img alt="icon" src="/assets/icons/car.png" />}
          />
        </Grid>
      </Grid>

      <Card sx={{ mt: 3, display: 'flex', justifyContent: 'space-around' }}>
      {/* Ride Pie Chart */}
      <div style={{ width: '45%', textAlign: 'center' }}>
        <Typography variant="h6" sx={{ mb: 2 }}>
          Data Pengantaran
        </Typography>
        <div style={{ width: '100%', height: 300 }}>
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={rideChartData}
                cx="50%"
                cy="50%"
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
                label
              >
                {rideChartData.map((entry) => (
                  <Cell key={`cell-${entry.name}`} fill={COLORS[entry.name]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Order Pie Chart */}
      <div style={{ width: '45%', textAlign: 'center' }}>
        <Typography variant="h6" sx={{ mb: 2 }}>
          Data Orderan
        </Typography>
        <div style={{ width: '100%', height: 300 }}>
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={orderChartData}
                cx="50%"
                cy="50%"
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
                label
              >
                {orderChartData.map((entry) => (
                  <Cell key={`cell-${entry.name}`} fill={COLORS[entry.name]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>
    </Card>
    </Container>
  );
}
