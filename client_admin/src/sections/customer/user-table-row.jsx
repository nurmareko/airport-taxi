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

import { apiEndpoint } from 'src/api-config';

import Label from 'src/components/label';
import Iconify from 'src/components/iconify';

export default function UserTableRow({
  id,
  name,
  email,
  phoneNumber,
  status,
  verifiedEmail,
  photo,
}) {
  const [open, setOpen] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [reason, setReason] = useState('');
  const token = localStorage.getItem('authToken');
  const router = useRouter();

  const handleOpenMenu = (event) => {
    setOpen(event.currentTarget);
  };

  const handleCloseMenu = () => {
    setOpen(null);
  };

  const handleOpenDialog = () => {
    if (!status) {
      handleToggleStatus();
    } else {
      setIsDialogOpen(true);
    }
  };

  const handleCloseDialog = () => {
    setIsDialogOpen(false);
    setReason('');
  };

  const handleToggleStatus = async () => {
    setIsDialogOpen(false);
    setIsLoading(true);
    try {
      const endpoint = status
        ? apiEndpoint('admin/deactivateCustomerAccount')
        : apiEndpoint('admin/activateCustomerAccount');

      const response = await fetch(endpoint, {
        method: 'PATCH',
        headers: {
          Authorization: `${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          customerId: id,
          reason: status ? reason : ''
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to toggle status');
      }

      // Refresh halaman setelah berhasil
      window.location.reload();
    } catch (error) {
      console.error('Error toggling status:', error);
      router.push('/login');
    } finally {
      setIsLoading(false);
      handleCloseDialog();
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
        <TableCell>{phoneNumber}</TableCell>
        <TableCell>
          <Label color={status ? 'success' : 'error'}>{status ? 'Active' : 'Inactive'}</Label>
        </TableCell>
        <TableCell>
          <Label color={verifiedEmail ? 'success' : 'error'}>
            {verifiedEmail ? 'Verified' : 'Unverified'}
          </Label>
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
        <MenuItem onClick={handleOpenDialog} sx={{ color: status ? '#f44336' : '#4caf50' }}>
          {isLoading ? (
            <CircularProgress size={24} sx={{ mr: 2 }} />
          ) : (
            <Iconify icon="eva:edit-fill" sx={{ mr: 2 }} />
          )}
          {status ? 'Nonaktifkan' : 'Aktifkan'}
        </MenuItem>
      </Popover>

      <Dialog open={isDialogOpen} onClose={handleCloseDialog}>
        <DialogTitle>{status ? 'Nonaktifkan Akun' : 'Aktifkan Akun'}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Mohon memberikan alasan kepada customer terkait penonaktifan akun ini. Silakan isi alasan penonaktifan akun. Formulir ini dapat dikosongkan jika tidak ada alasan khusus.
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            id="reason"
            label="Alasan"
            type="text"
            fullWidth
            variant="outlined"
            value={reason}
            onChange={(e) => setReason(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog} color="primary">
            Batal
          </Button>
          <Button onClick={handleToggleStatus} color="primary" disabled={isLoading}>
            {isLoading ? <CircularProgress size={24} /> : 'Submit'}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

UserTableRow.propTypes = {
  id: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  email: PropTypes.string.isRequired,
  phoneNumber: PropTypes.string.isRequired,
  status: PropTypes.bool.isRequired,
  verifiedEmail: PropTypes.bool.isRequired,
  photo: PropTypes.string,
};
