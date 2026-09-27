import React, { useState, useEffect } from 'react';
import { Pie, Cell, Legend, Tooltip, PieChart, ResponsiveContainer } from 'recharts';

import CircularProgress from '@mui/material/CircularProgress';
import {
  Card,
  Stack,
  Table,
  TableRow,
  Container,
  TableBody,
  TableHead,
  TableCell,
  Typography,
  TableContainer,
  TablePagination,
} from '@mui/material'; // Import recharts
import Label from 'src/components/label';

const getStatusLabel = (status) => {
  switch (status) {
    case 1:
      return 'Sedang proses';
    case 2:
      return 'Menjemput customer';
    case 3:
      return 'Menuju bandara';
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

const getStatusColor = (status) => {
  if (status === 4) {
    return 'success'; // hijau
  }
  if (status === 5 || status === 6 || status === 7) {
    return 'error'; // merah
  }
  return 'info'; // biru
};

export default function OrderanPage() {
  const [orderans, setOrderans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  useEffect(() => {
    const token = localStorage.getItem('authToken');

    const fetchOrderans = async () => {
      try {
        const response = await fetch('http://localhost:3000/api/admin/getOrderan', {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch orderan data');
        }

        const { data } = await response.json();

        // Fetch location names for each orderan
        const orderansWithLocation = await Promise.all(
          data.map(async (orderan) => {
            const locationName = await getAddress(orderan.lat, orderan.long);
            return { ...orderan, locationName };
          })
        );

        setOrderans(orderansWithLocation);
      } catch (error) {
        console.error('Error fetching orderan data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchOrderans();
  }, []);

  const handleChangePage = (event, newPage) => setPage(newPage);

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const statusCounts = orderans.reduce((acc, orderan) => {
    const statusText = getStatusLabel(orderan.status);
    acc[statusText] = acc[statusText] ? acc[statusText] + 1 : 1;
    return acc;
  }, {});

  const pieChartData = Object.keys(statusCounts).map((key) => ({
    name: key,
    value: statusCounts[key],
  }));

  const COLORS = {
    'Sedang proses': '#00CFFF', // Biru
    'Menjemput customer': '#00BFFF', // Biru muda
    'Menuju bandara': '#0099FF', // Biru lebih gelap
    'Selesai': '#66BB6A', // Hijau gelap
    'Dibatalkan Customer': '#E57373', // Merah gelap
    'Dibatalkan Driver': '#EF5350', // Merah terang
    'Ditolak Driver': '#D32F2F', // Merah sangat gelap
    'Tidak Selesai': '#FF8A80', // Merah pastel
  };
  
  if (loading) {
    return (
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="center" sx={{ minHeight: '100vh' }}>
          <CircularProgress />
        </Stack>
      </Container>
    );
  }

  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="h4">Data Pesanan</Typography>
      </Stack>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="body2" color="textSecondary">
          Data ini merupakan informasi dan aktivitas pesanan yang menggunakan layanan dan Aplikasi Airport Taxi Sharing.
          Informasi ini termasuk informasi kontak pelanggan dan driver 
          yang bertujuan untuk memberikan pengalaman terbaik dalam layanan taksi.
        </Typography>
      </Stack>

      <Card>
        {/* Add PieChart */}
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie
              data={pieChartData}
              cx="50%"
              cy="50%"
              outerRadius={80}
              fill="#8884d8"
              dataKey="value"
              label
            >
              {pieChartData.map((entry) => (
                <Cell key={`cell-${entry.name}`} fill={COLORS[entry.name]} />
              ))}
            </Pie>
            <Tooltip />
            <Legend />
          </PieChart>
        </ResponsiveContainer>
      </Card>

      <Card>
        <TableContainer sx={{ overflow: 'auto' }}>
          <Table sx={{ minWidth: 800 }}>
            <TableHead>
              <TableRow>
                <TableCell>Id Pesanan</TableCell>
                <TableCell>Id Pengantaran</TableCell>
                <TableCell>Nama Customer</TableCell>
                <TableCell>Nama Driver</TableCell>
                <TableCell>Biaya</TableCell>
                <TableCell>Tarif Per Km</TableCell>
                <TableCell>Lokasi Pesanan</TableCell>
                <TableCell>Status</TableCell>
                <TableCell>Dibuat Pada</TableCell>
                <TableCell>Diperbarui Pada</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {orderans.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage).map((orderan, index) => (
                <TableRow key={orderan.id}>
                  <TableCell>{page * rowsPerPage + orderan.id}</TableCell>
                  <TableCell>{orderan.rideId}</TableCell>
                  <TableCell>{orderan.customerName}</TableCell>
                  <TableCell>{orderan.driverName}</TableCell>
                  <TableCell>{orderan.cost}</TableCell>
                  <TableCell>{orderan.farePerKm}</TableCell>
                  <TableCell>{orderan.locationName}</TableCell>
                  <TableCell>
                    <Label color={getStatusColor(orderan.status)}>{getStatusLabel(orderan.status)}</Label>
                  </TableCell>
                  <TableCell>{orderan.createDatetime}</TableCell>
                  <TableCell>{orderan.updateDatetime}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={orderans.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Card>
    </Container>
  );
}

// geocoding.js

export const getAddress = async (lat, long) => {
  const apiKey = 'AIzaSyAkQFCwjjTYexrostQaE4fOWo3zKh9UMaU';
  const response = await fetch(
    `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=${apiKey}`
  );
  const data = await response.json();
  if (data.status === 'OK' && data.results.length > 0) {
    return data.results[0].formatted_address;
  }
  return 'Unknown Location';
};
