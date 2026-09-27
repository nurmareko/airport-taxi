import PropTypes from 'prop-types';
import { forwardRef } from 'react';

import Box from '@mui/material/Box';

// ----------------------------------------------------------------------

const SvgColor = forwardRef(({ src, sx, ...other }, ref) => (
  <Box
    component="img"
    className="svg-color"
    ref={ref}
    src={src}
    sx={{
      width: 24,
      height: 24,
      display: 'inline-block',
      ...sx,
    }}
    {...other}
  />
));

SvgColor.propTypes = {
  src: PropTypes.string.isRequired,
  sx: PropTypes.object,
};

export default SvgColor;
