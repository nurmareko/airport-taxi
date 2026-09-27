import adminService from '../service/admin-service.js';

// login

const login = async (req, res, next) => {
  try {
    const result = await adminService.login(req.body);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getCurrent = async (req, res, next) => {
  try {
    const { email } = req.admin;
    const result = await adminService.getCurrent(email);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getDriver = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const result = await adminService.getDriver();
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getCustomer = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const result = await adminService.getCustomer();
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getFare = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const result = await adminService.getFare();
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const updateFare = async (req, res, next) => {
  try {
    const { email } = req.admin;
    const { fareId } = req.body;
    const { farePerKm } = req.body;
    const result = await adminService.updateFare(email, fareId, farePerKm);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const activateDriverAccount = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const { driverId } = req.body;
    console.log(driverId);
    const result = await adminService.activateDriverAccount(driverId);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const deactivateDriverAccount = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const { driverId } = req.body;
    const { reason } = req.body;
    const result = await adminService.deactivateDriverAccount(driverId, reason);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const activateCustomerAccount = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const { customerId } = req.body;
    console.log(customerId);
    const result = await adminService.activateCustomerAccount(customerId);
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const deactivateCustomerAccount = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const { customerId } = req.body;
    const { reason } = req.body;
    const result = await adminService.deactivateCustomerAccount(
      customerId,
      reason,
    );
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getOrderan = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const result = await adminService.getOrderan();
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const getRide = async (req, res, next) => {
  try {
    // const email = req.admin.email;
    const result = await adminService.getRide();
    res.status(200).json({
      data: result,
    });
  } catch (e) {
    next(e);
  }
};

const logout = async (req, res, next) => {
  try {
    await adminService.logout(req.admin.email);
    res.status(200).json({
      data: 'OK',
    });
  } catch (e) {
    next(e);
  }
};

export default {
  login,
  getCurrent,
  getDriver,
  getCustomer,
  getFare,
  updateFare,
  activateDriverAccount,
  deactivateDriverAccount,
  activateCustomerAccount,
  deactivateCustomerAccount,
  getOrderan,
  getRide,
  logout,
};
