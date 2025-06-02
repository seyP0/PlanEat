// functions/src/index.ts

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Export functions from other modules
export { generatePlan } from './recommendations/generatePlan';
export { createUser } from './auth/createUser';
// export other functions here as you add them
