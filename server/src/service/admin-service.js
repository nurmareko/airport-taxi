import { validate } from "../validation/validation.js";
import { loginAdminValidation } from "../validation/admin-validation.js";
import { prismaClient } from "../application/database.js";
import { ResponseError } from "../error/response-error.js";
import {
  sendDriverAccountActivationEmail,
  sendDriverAccountDeactivationEmail,
  sendCustomerAccountDeactivationEmail,
  sendCustomerAccountActivationEmail,
} from "../utils/sendEmailAccountStatus.js";
import { v4 as uuid } from "uuid";

import { format } from "date-fns";
import { id } from "date-fns/locale";

const login = async (request) => {
  const loginRequest = validate(loginAdminValidation, request);

  const admin = await prismaClient.admin.findUnique({
    where: {
      email: loginRequest.email,
    },
  });

  if (!admin || admin.password !== loginRequest.password) {
    throw new ResponseError(401, "Kredensial tidak valid", loginRequest.email);
  }

  const token = uuid().toString();
  const tokenExpiry = new Date();
  tokenExpiry.setDate(tokenExpiry.getDate() + 1);

  return prismaClient.admin.update({
    data: {
      token: token,
      tokenExpiry: tokenExpiry,
    },
    where: {
      email: admin.email,
    },
    select: {
      token: true,
    },
  });
};

const getCurrent = async (email) => {
  const admin = await prismaClient.admin.findFirst({
    where: {
      email: email,
    },
    select: {
      id: true,
      username: true,
      fullName: true,
      email: true,
      phoneNumber: true,
      photo: true,
    },
  });

  if (!admin) {
    throw new ResponseError(404, "Admin not found");
  }

  return admin;
};

const getDriver = async () => {
  const drivers = await prismaClient.driver.findMany({
    select: {
      id: true,
      noMembership: true,
      licensePlate: true,
      email: true,
      name: true,
      phoneNumber: true,
      photo: true,
      status: true,
      verifiedEmail: true,
    },
  });

  return drivers;
};

const getCustomer = async () => {
  const customers = await prismaClient.customer.findMany({
    select: {
      id: true,
      email: true,
      name: true,
      phoneNumber: true,
      photo: true,
      status: true,
      verifiedEmail: true,
    },
  });

  return customers;
};

const getFare = async () => {
  const fare = await prismaClient.fare.findFirst({
    select: {
      id: true,
      farePerKm: true,
      createDatetime: true,
      updateDatetime: true,
    },
  });

  if (fare) {
    fare.createDatetime = format(new Date(fare.createDatetime), "PPPP p", {
      locale: id,
    });
    fare.updateDatetime = format(new Date(fare.updateDatetime), "PPPP p", {
      locale: id,
    });
  }

  return fare;
};

const updateFare = async (email, fareId, farePerKm) => {
  const admin = await prismaClient.admin.findUnique({
    where: {
      email: email,
    },
    select: {
      id: true,
    },
  });
  // Cari fare berdasarkan fareId
  const fare = await prismaClient.fare.findUnique({
    where: {
      id: fareId,
    },
  });

  if (!fare) {
    throw ResponseError(404, `Fare with ID ${fareId} not found`);
  }

  const updatedFare = await prismaClient.fare.update({
    where: {
      id: fareId,
    },
    data: {
      farePerKm: farePerKm,
      adminId: admin.id,
    },
    select: {
      id: true,
    },
  });

  return updatedFare;
};

const activateDriverAccount = async (driverId) => {
  const driver = await prismaClient.driver.findUnique({
    where: {
      id: driverId,
    },
  });

  if (!driver) {
    throw new ResponseError(404, "Driver not found");
  }

  if (driver.status === true) {
    throw new ResponseError(400, "Driver account is already active");
  }

  const updatedDriver = await prismaClient.driver.update({
    where: {
      id: driverId,
    },
    data: {
      status: true,
    },
    select: {
      email: true,
      name: true,
    },
  });

  try {
    await sendDriverAccountActivationEmail(
      updatedDriver.email,
      updatedDriver.name
    );
    console.log("Activation email sent successfully");
  } catch (error) {
    console.error("Error sending activation email:", error.message);
  }

  return updatedDriver;
};

const deactivateDriverAccount = async (driverId, reason) => {
  const driver = await prismaClient.driver.findUnique({
    where: {
      id: driverId,
    },
  });

  if (!driver) {
    throw new ResponseError(404, "Driver not found");
  }

  if (driver.status === false) {
    throw new ResponseError(400, "Driver account is already inactive");
  }

  const updatedDriver = await prismaClient.driver.update({
    where: {
      id: driverId,
    },
    data: {
      status: false,
    },
    select: {
      email: true,
      name: true,
    },
  });

  try {
    await sendDriverAccountDeactivationEmail(
      updatedDriver.email,
      updatedDriver.name,
      reason
    );
    console.log("Deactivation email sent successfully");
  } catch (error) {
    console.error("Error sending deactivation email:", error.message);
  }

  return updatedDriver;
};

const activateCustomerAccount = async (customerId) => {
  const customer = await prismaClient.customer.findUnique({
    where: {
      id: customerId,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "Customer not found");
  }

  if (customer.status === true) {
    throw new ResponseError(400, "Customer account is already active");
  }

  const updatedCustomer = await prismaClient.customer.update({
    where: {
      id: customerId,
    },
    data: {
      status: true,
    },
    select: {
      email: true,
      name: true,
    },
  });

  try {
    await sendCustomerAccountActivationEmail(
      updatedCustomer.email,
      updatedCustomer.name
    );
    console.log("Deactivation email sent successfully");
  } catch (error) {
    console.error("Error sending deactivation email:", error.message);
  }

  return updatedCustomer;
};

const deactivateCustomerAccount = async (customerId, reason) => {
  const customer = await prismaClient.customer.findUnique({
    where: {
      id: customerId,
    },
  });

  if (!customer) {
    throw new ResponseError(404, "Customer not found");
  }

  if (customer.status === false) {
    throw new ResponseError(400, "Customer account is already inactive");
  }

  const updatedCustomer = await prismaClient.customer.update({
    where: {
      id: customerId,
    },
    data: {
      status: false,
    },
    select: {
      email: true,
      name: true,
    },
  });

  try {
    await sendCustomerAccountDeactivationEmail(
      updatedCustomer.email,
      updatedCustomer.name,
      reason
    );
    console.log("Deactivation email sent successfully");
  } catch (error) {
    console.error("Error sending deactivation email:", error.message);
  }

  return updatedCustomer;
};

const getOrderan = async () => {
  const orders = await prismaClient.order.findMany({
    select: {
      id: true,
      lat: true,
      long: true,
      status: true,
      customerToAirportDistance: true,
      farePerKm: true,
      cost: true,
      driverId: true,
      customerId: true,
      rideId: true,
      createDatetime: true,
      updateDatetime: true,
    },
  });

  // Ambil nama driver dari tabel driver menggunakan driverId
  for (let order of orders) {
    const driver = await prismaClient.driver.findUnique({
      where: {
        id: order.driverId,
      },
      select: {
        name: true,
      },
    });
    order.driverName = driver ? driver.name : "Unknown"; // Tambahkan nama driver ke dalam objek order

    // Ambil nama customer dari tabel customer menggunakan customerId
    const customer = await prismaClient.customer.findUnique({
      where: {
        id: order.customerId,
      },
      select: {
        name: true,
      },
    });
    order.customerName = customer ? customer.name : "Unknown"; // Tambahkan nama customer ke dalam objek order
  }

  for (let order of orders) {
    if (order.createDatetime) {
      order.createDatetime = format(
        new Date(order.createDatetime),
        "dd MMMM yyyy HH:mm",
        { locale: id }
      );
    }
    if (order.updateDatetime) {
      order.updateDatetime = format(
        new Date(order.updateDatetime),
        "dd MMMM yyyy HH:mm",
        { locale: id }
      );
    }
  }

  return orders;
};

const getRide = async () => {
  const rides = await prismaClient.ride.findMany({
    select: {
      id: true,
      lat: true,
      long: true,
      rideStatus: true,
      pickupRadius: true,
      driverId: true,
      createDatetime: true,
      updateDatetime: true,
    },
  });

  // Collecting unique driverIds to minimize database queries
  const driverIds = rides.map((ride) => ride.driverId);
  const uniqueDriverIds = [...new Set(driverIds)];

  // Fetching driver names for all unique driverIds
  const drivers = await prismaClient.driver.findMany({
    where: {
      id: {
        in: uniqueDriverIds,
      },
    },
    select: {
      id: true,
      name: true,
    },
  });

  // Creating a map of driverId to driver name for quick lookup
  const driverMap = {};
  drivers.forEach((driver) => {
    driverMap[driver.id] = driver.name;
  });

  // Formatting rides and adding driver names
  const formattedRides = rides.map((ride) => ({
    ...ride,
    createDatetime: format(new Date(ride.createDatetime), "PPPP p", {
      locale: id,
    }),
    updateDatetime: format(new Date(ride.updateDatetime), "PPPP p", {
      locale: id,
    }),
    driverName: driverMap[ride.driverId], // Adding driver name
  }));

  return formattedRides;
};

const logout = async (email) => {
  const admin = await prismaClient.admin.findUnique({
    where: {
      email: email,
    },
  });

  if (!admin) {
    throw new ResponseError(404, "Admin not found");
  }

  return prismaClient.admin.update({
    where: {
      email: email,
    },
    data: {
      token: null,
    },
  });
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
