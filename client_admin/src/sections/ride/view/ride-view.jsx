import React, { useState, useEffect } from 'react';
import {
  Pie,
  Cell,
  Legend,
  Tooltip,
  PieChart,
  ResponsiveContainer,
} from 'recharts'; // Import recharts
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
  TablePagination, // Import TablePagination
} from '@mui/material';

import { apiEndpoint } from 'src/api-config';

import Label from 'src/components/label';

export default function RidePage() {
  const [rides, setRides] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0); // Pagination state: current page
  const [rowsPerPage, setRowsPerPage] = useState(5); // Pagination state: rows per page

  useEffect(() => {
    const token = localStorage.getItem('authToken');

    const fetchRides = async () => {
      try {
        const response = await fetch(apiEndpoint('admin/getRide'), {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch ride data');
        }

        const { data } = await response.json();
        const updatedData = await Promise.all(data.map(async (ride) => {
          const locationName = await getLocationName(ride.lat, ride.long);
          return { ...ride, locationName };
        }));
        setRides(updatedData);
      } catch (error) {
        console.error('Error fetching ride data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchRides();
  }, []);

  const getLabelColor = (rideStatus) => {
    switch (rideStatus) {
      case 0:
        return 'warning';
      case 1:
        return 'info';
      case 2:
        return 'error';
      case 3:
        return 'success';
      default:
        return 'default';
    }
  };
  
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

  const getLocationName = async (lat, long) => {
    try {
      const response = await fetch(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=AIzaSyAkQFCwjjTYexrostQaE4fOWo3zKh9UMaU`);
      const data = await response.json();
      return data.results[0]?.formatted_address || 'Unknown location';
    } catch (error) {
      console.error('Error fetching location name:', error);
      return 'Unknown location';
    }
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0); // Reset to the first page when rows per page changes
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

  // Prepare data for pie chart
  const statusCounts = rides.reduce((acc, ride) => {
    const statusText = getLabelText(ride.rideStatus);
    acc[statusText] = acc[statusText] ? acc[statusText] + 1 : 1;
    return acc;
  }, {});

  const chartData = Object.keys(statusCounts).map((key) => ({
    name: key,
    value: statusCounts[key],
  }));

  // Array colors corresponding to rideStatus (0: kuning, 1: biru, 2: merah, 3: hijau)
 
  const COLORS = {
    'Sedang Proses': '#FFD700', // Kuning
    'Selesai Mengantar': '#00CFFF', // Biru info
    'Batal': '#E57373', // Merah gelap
    'Selesai': '#66BB6A' // Hijau gelap
  };


  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="h4">Data Pengantaran</Typography>
      </Stack>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="body2" color="textSecondary">
          Data ini merupakan informasi pengantaran penumpang dari bandara menuju lokasi tujuan mereka yang merupakan bagian dari layanan Aplikasi Airport Taxi Sharing.
        </Typography>
      </Stack>

      <Card>
        {/* Add PieChart */}
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie
              data={chartData}
              cx="50%"
              cy="50%"
              outerRadius={80}
              fill="#8884d8"
              dataKey="value"
              label
            >
              {chartData.map((entry) => (
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
                <TableCell>Id Pengantaran</TableCell> {/* Add a numbering column */}
                <TableCell>Nama Driver</TableCell>
                <TableCell>Radius Pengantaran (meter)</TableCell>
                <TableCell>Status Pengantaran</TableCell>
                <TableCell>Dibuat Pada</TableCell>
                <TableCell>Diperbarui Pada</TableCell>
                <TableCell>Nama Lokasi</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {rides
                .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                .map((row) => (
                  <TableRow key={row.id}>
                    <TableCell>{row.id}</TableCell> {/* Numbering logic */}
                    <TableCell>{row.driverName}</TableCell>
                    <TableCell>{row.pickupRadius}</TableCell>
                    <TableCell>
                      <Label color={getLabelColor(row.rideStatus)}>
                        {getLabelText(row.rideStatus)}
                      </Label>
                    </TableCell>
                    <TableCell>{row.createDatetime}</TableCell>
                    <TableCell>{row.updateDatetime}</TableCell>
                    <TableCell>{row.locationName}</TableCell>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
        </TableContainer>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={rides.length}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Card>
    </Container>
  );
}
