import React, { useState, useEffect } from 'react';

import { useRouter } from 'src/routes/hooks';  // Import the useRouter hook

import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Table from '@mui/material/Table';
import Container from '@mui/material/Container';
import TableBody from '@mui/material/TableBody';
import Typography from '@mui/material/Typography';
import TableContainer from '@mui/material/TableContainer';
import TablePagination from '@mui/material/TablePagination';

import Scrollbar from 'src/components/scrollbar';

import TableNoData from '../table-no-data';
import UserTableRow from '../user-table-row';
import UserTableHead from '../user-table-head';
import TableEmptyRows from '../table-empty-rows';
import { emptyRows, getComparator } from '../utils';
import UserTableToolbar from '../user-table-toolbar';

export default function CustomerPage() {
  const [page, setPage] = useState(0);
  const [order, setOrder] = useState('asc');
  const [activeCount, setActiveCount] = useState(0);
  const [inactiveCount, setInactiveCount] = useState(0);
  const [selected, setSelected] = useState([]);
  const [orderBy, setOrderBy] = useState('name');
  const [filterName, setFilterName] = useState('');
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [customers, setCustomers] = useState([]);
  const router = useRouter();  // Initialize the router

  useEffect(() => {
    const token = localStorage.getItem('authToken');

    const fetchCustomers = async () => {
      try {
        const response = await fetch('http://localhost:3001/api/admin/getCustomer', {
          method: 'GET',
          headers: {
            Authorization: `${token}`,
          },
        });

        if (!response.ok) {
          throw new Error('Failed to fetch customer data');
        }

        const { data } = await response.json();
        setCustomers(data);
        // Calculate active and inactive driver counts
        const activeCustomers = data.filter(customer => customer.status === true).length;
        const inactiveCustomers = data.filter(customer => customer.status === false).length;
 
        setActiveCount(activeCustomers);
        setInactiveCount(inactiveCustomers);

      } catch (error) {
        console.error('Error fetching customer data:', error);
        router.push('/login');  // Redirect to login page on error
      }
    };

    fetchCustomers();
  }, [router]);

  const handleSort = (event, id) => {
    const isAsc = orderBy === id && order === 'asc';
    if (id !== '') {
      setOrder(isAsc ? 'desc' : 'asc');
      setOrderBy(id);
    }
  };

  const handleSelectAllClick = (event) => {
    if (event.target.checked) {
      const newSelecteds = customers.map((n) => n.name);
      setSelected(newSelecteds);
      return;
    }
    setSelected([]);
  };

  const handleClick = (event, name) => {
    const selectedIndex = selected.indexOf(name);
    let newSelected = [];
    if (selectedIndex === -1) {
      newSelected = newSelected.concat(selected, name);
    } else if (selectedIndex === 0) {
      newSelected = newSelected.concat(selected.slice(1));
    } else if (selectedIndex === selected.length - 1) {
      newSelected = newSelected.concat(selected.slice(0, -1));
    } else if (selectedIndex > 0) {
      newSelected = newSelected.concat(
        selected.slice(0, selectedIndex),
        selected.slice(selectedIndex + 1)
      );
    }
    setSelected(newSelected);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setPage(0);
    setRowsPerPage(parseInt(event.target.value, 10));
  };

  const handleFilterByName = (event) => {
    setPage(0);
    setFilterName(event.target.value.toLowerCase());
  };

  const applyFilter = ({ inputData, comparator, filterValue }) => 
    inputData
      .filter((customer) => 
        customer.name.toLowerCase().includes(filterValue) ||
        customer.email.toLowerCase().includes(filterValue) ||
        customer.phoneNumber.toLowerCase().includes(filterValue) 
      )
      .sort(comparator);

  const dataFiltered = applyFilter({
    inputData: customers,
    comparator: getComparator(order, orderBy),
    filterValue: filterName, // Pass filterName as filterValue
  });


  const notFound = !dataFiltered.length && !!filterName;

  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="h4">Data Customer</Typography>
      </Stack>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={2}>
        <Typography variant="body2" color="textSecondary">
          Data ini merupakan informasi pelanggan yang menggunakan layanan dan Aplikasi Airport Taxi Sharing.
          Informasi ini termasuk informasi kontak pelanggan 
          yang bertujuan untuk memberikan pengalaman terbaik dalam layanan taksi.
        </Typography>
      </Stack>
      {/* Display Active/Inactive Customer Count */}
      <Stack 
        direction="row" 
        spacing={3} 
        mb={2} 
      >
        <Typography 
          variant="h7" 
          sx={{ 
            color: 'green', 
            fontWeight: 'normal', 
            padding: 1, 
            backgroundColor: '#e0f5e9', 
            borderRadius: 1 
          }}
        >
        {activeCount} Akun Aktif
        </Typography>
        <Typography 
          variant="h7" 
          sx={{ 
            color: 'red', 
            fontWeight: 'normal', 
            padding: 1, 
            backgroundColor: '#f8d7da', 
            borderRadius: 1 
          }}
        >
        {inactiveCount} Akun Tidak Aktif
        </Typography>
      </Stack>
      <Card>
        <UserTableToolbar
          numSelected={selected.length}
          filterName={filterName}
          onFilterName={handleFilterByName}
        />

        <Scrollbar>
          <TableContainer sx={{ overflow: 'unset' }}>
            <Table sx={{ minWidth: 800 }}>
              <UserTableHead
                order={order}
                orderBy={orderBy}
                rowCount={customers.length}
                numSelected={selected.length}
                onRequestSort={handleSort}
                onSelectAllClick={handleSelectAllClick}
                headLabel={[
                  { id: 'name', label: 'Nama Customer' },
                  { id: 'email', label: 'Email' },
                  { id: 'phoneNumber', label: 'Nomor HP' },
                  { id: 'status', label: 'Status' },
                  { id: 'verifiedEmail', label: 'Status Email' },
                  { id: '' },
                ]}
              />
              <TableBody>
                {dataFiltered
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((row) => (
                    <UserTableRow
                      key={row.id}
                      id={row.id}
                      name={row.name}
                      email={row.email}
                      phoneNumber={row.phoneNumber}
                      status={row.status}
                      verifiedEmail={row.verifiedEmail}
                      photo={row.photo}
                      selected={selected.indexOf(row.name) !== -1}
                      handleClick={(event) => handleClick(event, row.name)}
                    />
                  ))}

                <TableEmptyRows
                  height={77}
                  emptyRows={emptyRows(page, rowsPerPage, customers.length)}
                />

                {notFound && <TableNoData query={filterName} />}
              </TableBody>
            </Table>
          </TableContainer>
        </Scrollbar>

        <TablePagination
          page={page}
          component="div"
          count={customers.length}
          rowsPerPage={rowsPerPage}
          onPageChange={handleChangePage}
          rowsPerPageOptions={[5, 10, 25]}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Card>
    </Container>
  );
}
