import React, { useState, useEffect } from 'react';

import CircularProgress from '@mui/material/CircularProgress';
import { 
  Card, 
  Stack,
  Table,
  Dialog,   
  Button, 
  Popover,
  TableRow,
  MenuItem,
  Container,
  TableBody,
  TableHead, 
  TableCell,
  TextField, 
  Typography,
  IconButton,
  DialogTitle,
  DialogActions,
  DialogContent,
  TableContainer, 
  DialogContentText,
} from '@mui/material';

import Iconify from 'src/components/iconify';

export default function FarePage() {
  const [fares, setFares] = useState([]);
  const [loading, setLoading] = useState(true); 
  const [open, setOpen] = useState(null);
  const [isLoading, setIsLoading] = useState(false); 
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [editData, setEditData] = useState({ id: '', farePerKm: '' });

  useEffect(() => {
    const token = localStorage.getItem('authToken');

    const fetchFares = async () => {
      try {
        const response = await fetch('http://localhost:3001/api/admin/getFare', {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch fare data');
        }

        const { data } = await response.json();
        setFares([data]);
      } catch (error) {
        console.error('Error fetching fare data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchFares();
  }, []);

  const handleOpenMenu = (event) => {
    setOpen(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpen(null);
  };

  const handleOpenEditModal = (row) => {
    setEditData({ id: row.id, farePerKm: row.farePerKm });
    setEditModalOpen(true);
    handleCloseMenu();
  };

  const handleCloseEditModal = () => {
    setEditModalOpen(false);
  };

  const handleEditChange = (event) => {
    const { name, value } = event.target;
    const numericValue = value === '' ? '' : parseFloat(value);

    if (!Number.isNaN(numericValue)) {
      setEditData((prevData) => ({
        ...prevData,
        [name]: numericValue,
      }));
    }
  };

  const handleSubmitEdit = async () => {
    setIsLoading(true);
    const token = localStorage.getItem('authToken');
    console.log(token);
    try {
      const editDataWithIntegers = {
        fareId: parseInt(editData.id, 10),
        farePerKm: parseInt(editData.farePerKm, 10)
      };
      console.log('Submitting edit with:', editDataWithIntegers.fareId, editDataWithIntegers.farePerKm);
      const response = await fetch('http://localhost:3001/api/admin/updateFare', {
        method: 'PATCH',
        headers: {
          Authorization: `${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(editDataWithIntegers),
      });
  
      if (!response.ok) {
        throw new Error('Failed to update fare');
      }
  
      window.location.reload();
    } catch (error) {
      console.error('Error updating fare:', error);
    } finally {
      setIsLoading(false);
      handleCloseEditModal();
    }
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
        <Typography variant="h4">Data Tarif</Typography>
      </Stack>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="body2" color="textSecondary">
          Data ini merupakan informasi tarif per kilometer yang digunakan dalam layanan dan Aplikasi Airport Taxi Sharing.
        </Typography>
      </Stack>

      <Card>
        <TableContainer sx={{ overflow: 'auto' }}>
          <Table sx={{ minWidth: 800 }}>
            <TableHead>
              <TableRow>
                <TableCell>Biaya Per Km (Rp.)</TableCell>
                <TableCell>Dibuat Pada</TableCell>
                <TableCell>Diperbarui Pada</TableCell>
                <TableCell align="right"> </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {fares.map((row) => (
                <TableRow key={row.id}>
                  <TableCell>{row.farePerKm}</TableCell>
                  <TableCell>{row.createDatetime}</TableCell>
                  <TableCell>{row.updateDatetime}</TableCell>
                  <TableCell align="right">
                    <IconButton onClick={handleOpenMenu}>
                      <Iconify icon="eva:more-vertical-fill" />
                    </IconButton>
                    <Popover
                      open={!!open}
                      anchorEl={open}
                      onClose={handleCloseMenu}
                      anchorOrigin={{ vertical: 'top', horizontal: 'left' }}
                      transformOrigin={{ vertical: 'top', horizontal: 'right' }}
                      PaperProps={{
                        sx: { width: 140 },
                      }}
                    >
                      <MenuItem onClick={() => handleOpenEditModal(row)}>
                        <Iconify icon="eva:edit-fill" sx={{ mr: 2 }} />
                        Edit
                      </MenuItem>
                    </Popover>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      </Card>

      <Dialog open={editModalOpen} onClose={handleCloseEditModal}>
        <DialogTitle>Edit Fare Per Km</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Untuk mengubah tarif per kilometer, silakan masukkan nilai baru di bawah ini dan klik submit.
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            name="farePerKm"
            label="Fare Per Km"
            type="number"
            fullWidth
            value={editData.farePerKm}
            onChange={handleEditChange}
            inputProps={{ min: 0 }} // Ensures only non-negative numbers are accepted
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseEditModal} color="primary">
            Cancel
          </Button>
          <Button onClick={handleSubmitEdit} color="primary" disabled={isLoading}>
            {isLoading ? <CircularProgress size={24} /> : 'Submit'}
          </Button>
        </DialogActions>
      </Dialog>

      <Dialog open={isLoading}>
        <DialogContent>
          <Stack direction="row" alignItems="center" justifyContent="center">
            <CircularProgress />
          </Stack>
        </DialogContent>
      </Dialog>
    </Container>
  );
}
