import { useState } from 'react';
import { Link as RouterLink } from 'react-router-dom';

import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import MuiLink from '@mui/material/Link';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import LoadingButton from '@mui/lab/LoadingButton';
import { alpha, useTheme } from '@mui/material/styles';
import InputAdornment from '@mui/material/InputAdornment';

import { useRouter } from 'src/routes/hooks';

import { bgGradient } from 'src/theme/css';
import { apiEndpoint } from 'src/api-config';

import Logo from 'src/components/logo';

export default function LoginView() {
  const theme = useTheme();
  const router = useRouter();

  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [emailError, setEmailError] = useState(false);
  const [passwordError, setPasswordError] = useState(false);
  const [generalError, setGeneralError] = useState(null);
  const [loading, setLoading] = useState(false); // New loading state

  const handleLogin = () => {
    // Reset all error states
    setEmailError(false);
    setPasswordError(false);
    setGeneralError(null);

    // Validate the fields before proceeding
    if (!email) {
      setEmailError(true);
    }

    if (!password) {
      setPasswordError(true);
    }

    // If both fields are not empty, proceed with the login
    if (email && password) {
      setLoading(true); // Set loading to true
      const apiUrl = apiEndpoint('admin/login');

      // Prepare the login data using shorthand property notation
      const loginData = {
        email,
        password,
      };

      // Make the API call using fetch
      fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(loginData),
      })
        .then(async (response) => {
          setLoading(false); // Set loading to false
          if (!response.ok) {
            if (response.status === 401) {
              setGeneralError('Invalid email or password');
            } else {
              setGeneralError('Failed to login. Please try again later.');
            }
          } else {
            try {
              const responseData = await response.json();
              if (responseData.data.token) {
                console.log('Token:', responseData.data.token);
                localStorage.setItem('authToken', responseData.data.token);

                // Redirect ke halaman lain setelah login berhasil
                router.push('/');
              } else {
                // Tangani situasi di mana respons tidak mengandung token
                console.error('Invalid response format');
                setGeneralError('An error occurred. Please try again later.');
              }
            } catch (error) {
              // Tangani kesalahan pembongkaran JSON
              console.error('Error parsing JSON:', error);
              setGeneralError('An error occurred. Please try again later.');
            }
          }
        })
        .catch((error) => {
          setLoading(false); // Set loading to false
          // Tangani kesalahan jaringan, dsb.
          console.error('Error during login:', error);
          setGeneralError('An error occurred. Please try again later.');
        });
    }
  };

  const renderForm = (
    <>
      <Stack spacing={3}>
        <TextField
          name="email"
          label="Email"
          error={emailError}
          helperText={emailError ? 'Email is required' : ''}
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <TextField
          name="password"
          label="Password"
          type={showPassword ? 'text' : 'password'}
          error={passwordError}
          helperText={passwordError ? 'Password is required' : ''}
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          InputProps={{
            endAdornment: (
              <InputAdornment position="end">
                <IconButton onClick={() => setShowPassword(!showPassword)} edge="end">
                  {/* <Iconify icon={showPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} /> */}
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
      </Stack>

      <LoadingButton
        fullWidth
        size="large"
        type="submit"
        variant="contained"
        color="inherit"
        onClick={handleLogin}
        loading={loading} // Bind loading state to button
        style={{ marginTop: '20px' }}
      >
        Login
      </LoadingButton>
    </>
  );

  return (
    <Box
      sx={{
        ...bgGradient({
          color: alpha(theme.palette.background.default, 0.9),
          imgUrl: '/assets/background/overlay_4.jpg',
        }),
        height: 1,
      }}
    >
      <Logo
        sx={{
          position: 'fixed',
          top: { xs: 16, md: 24 },
          left: { xs: 16, md: 24 },
        }}
      />

      <Stack alignItems="center" justifyContent="center" sx={{ height: 1 }}>
        <Card
          sx={{
            p: 5,
            width: 1,
            maxWidth: 420,
          }}
        >
          <Typography variant="h4">Hello Admin,</Typography>

          <Typography variant="body2" sx={{ mt: 2, mb: 5 }}>
            Masuk ke Halaman Admin{' '}
            <MuiLink component={RouterLink} to="/login" variant="subtitle2" sx={{ ml: 0.5 }}>
              Airport Taxi Sharing
            </MuiLink>
          </Typography>

          {generalError && (
            <Typography variant="body2" color="error" sx={{ mb: 4 }}>
              {generalError}
            </Typography>
          )}

          {renderForm}
        </Card>
      </Stack>
    </Box>
  );
}
