import 'dotenv/config';
import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  if (process.env.NODE_ENV === 'production') {
    throw new Error('Development seed cannot run in production.');
  }

  const password = await bcrypt.hash('password123', 10);
  await prisma.$transaction(async (db) => {
    await db.customer.upsert({
      where: { email: 'customer@example.com' },
      update: {},
      create: {
        email: 'customer@example.com',
        name: 'Demo Customer',
        phoneNumber: '+6280000000001',
        password,
        verifiedEmail: true,
        status: true,
        lat: -6.2,
        long: 106.816666,
      },
    });

    await db.driver.upsert({
      where: { email: 'driver@example.com' },
      update: {},
      create: {
        email: 'driver@example.com',
        name: 'Demo Driver',
        phoneNumber: '+6280000000002',
        noMembership: 'DEMO-001',
        licensePlate: 'B1234DEMO',
        password,
        verifiedEmail: true,
        status: true,
        lat: -6.2,
        long: 106.816666,
      },
    });

    const admin = await db.admin.upsert({
      where: { email: 'admin@example.com' },
      update: {},
      create: {
        email: 'admin@example.com',
        username: 'demo_admin',
        fullName: 'Demo Admin',
        phoneNumber: '+6280000000003',
        // The existing admin login compares passwords directly.
        password: 'admin123',
        createDatetime: new Date(),
        updateDatetime: new Date(),
      },
    });

    // Application services select the first fare and airport.
    // Preserve any existing configuration instead of adding competing defaults.
    if (!(await db.fare.findFirst())) {
      await db.fare.create({
        data: { adminId: admin.id, farePerKm: 5000 },
      });
    }
    if (!(await db.airport.findFirst())) {
      await db.airport.create({
        data: {
          name: 'Soekarno-Hatta International Airport',
          address: 'Tangerang, Banten, Indonesia',
          status: 1,
          lat: -6.1256,
          long: 106.6559,
        },
      });
    }
  });
  console.log('Development seed complete. Existing records were preserved.');
  console.log('New customer: customer@example.com / password123');
  console.log('New driver: driver@example.com / password123');
  console.log('New admin: admin@example.com / admin123');
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
