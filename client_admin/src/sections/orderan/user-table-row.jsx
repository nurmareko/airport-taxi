import PropTypes from 'prop-types';
import React, { useState } from 'react';

import { useRouter } from 'src/routes/hooks';  // Import the useRouter hook

import Stack from '@mui/material/Stack';
import Avatar from '@mui/material/Avatar';
import Popover from '@mui/material/Popover';
import TableRow from '@mui/material/TableRow';
import MenuItem from '@mui/material/MenuItem';
import TableCell from '@mui/material/TableCell';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import CircularProgress from '@mui/material/CircularProgress'; // Import CircularProgress
import Dialog from '@mui/material/Dialog';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import DialogTitle from '@mui/material/DialogTitle';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';

import Label from 'src/components/label';
import Iconify from 'src/components/iconify';

// ----------------------------------------------------------------------

export default function UserTableRow({
  id,
  name,
  email,
  noMembership,
  licensePlate,
  phoneNumber,
  photo,
  status,
  verifiedEmail
}) {
  const [open, setOpen] = useState(null);
  const [isLoading, setIsLoading] = useState(false); // Add isLoading state
  const [reason, setReason] = useState(''); // Add reason state
  const [dialogOpen, setDialogOpen] = useState(false); // Add dialogOpen state
  const token = localStorage.getItem('authToken');
  const router = useRouter();  // Initialize the router

  const handleOpenMenu = (event) => {
    setOpen(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpen(null);
  };

  const handleOpenDialog = () => {
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
  };

  const handleToggleStatus = async () => {
    setDialogOpen(false);
    setIsLoading(true); // Set isLoading to true at the start
    try {
      const endpoint = status
        ? 'http://localhost:3001/api/admin/deactivateDriverAccount'
        : 'http://localhost:3001/api/admin/activateDriverAccount';

      const response = await fetch(endpoint, {
        method: 'PATCH',
        headers: {
          Authorization: `${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          driverId: id,
          reason: status ? reason : ''  // Include reason if deactivating
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to toggle status');
      }

      // Refresh the page upon success
      window.location.reload();
    } catch (error) {
      console.error('Error toggling status:', error);
      router.push('/login');  // Redirect to login page on error
    } finally {
      setIsLoading(false); // Set isLoading to false after completion
      handleCloseDialog(); // Close the dialog
    }
  };

  return (
    <>
      <TableRow hover tabIndex={-1} role="checkbox">
        <TableCell component="th" scope="row" padding="none">
          <Stack direction="row" alignItems="center" spacing={2} sx={{ pl: 2 }}>
            <Avatar alt={name} src={photo} />
            <Typography variant="subtitle2" noWrap>
              {name}
            </Typography>
          </Stack>
        </TableCell>

        <TableCell>{email}</TableCell>
        <TableCell>{noMembership}</TableCell>
        <TableCell>{licensePlate}</TableCell>
        <TableCell>{phoneNumber}</TableCell>

        <TableCell>
          <Label color={status ? 'success' : 'error'}>{status ? 'Active' : 'Inactive'}</Label>
        </TableCell>

        <TableCell>
          <Label color={verifiedEmail ? 'success' : 'error'}>{verifiedEmail ? 'Verified' : 'Unverified'}</Label>
        </TableCell>

        <TableCell align="right">
          <IconButton onClick={handleOpenMenu}>
            <Iconify icon="eva:more-vertical-fill" />
          </IconButton>
        </TableCell>
      </TableRow>

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
        <MenuItem onClick={status ? handleOpenDialog : handleToggleStatus} sx={{ color: status ? '#f44336' : '#4caf50' }}>
          {isLoading ? (
            <CircularProgress size={24} sx={{ mr: 2 }} /> // Show loading indicator
          ) : (
            <Iconify icon="eva:edit-fill" sx={{ mr: 2 }} />
          )}
          {status ? 'Nonaktifkan' : 'Aktifkan'}
        </MenuItem>
      </Popover>

      <Dialog open={dialogOpen} onClose={handleCloseDialog}>
        <DialogTitle>Akun Dinonaktifkan</DialogTitle>
        <DialogContent>
        <DialogContentText>
            Mohon memberikan alasan kepada driver terkait penonaktifan akun ini. Silakan isi alasan penonaktifan akun. Formulir ini dapat dikosongkan jika tidak ada alasan khusus.
        </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            id="reason"
            label="Alasan"
            type="text"
            fullWidth
            variant="standard"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Batal</Button>
          <Button onClick={handleToggleStatus}>Submit</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

UserTableRow.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  noMembership: PropTypes.string.isRequired,
  licensePlate: PropTypes.string.isRequired,
  phoneNumber: PropTypes.string.isRequired,
  photo: PropTypes.string.isRequired,
  status: PropTypes.bool.isRequired,
  verifiedEmail: PropTypes.bool.isRequired,
};
