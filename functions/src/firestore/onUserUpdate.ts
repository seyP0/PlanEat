import * as functions from 'firebase-functions/v1';

export const onUserUpdate = functions.firestore
    .document('users/{userId}')
    .onUpdate((change: functions.Change<FirebaseFirestore.DocumentSnapshot>, context: functions.EventContext) => {
        const before = change.before.data();
        const after = change.after.data();
        const userId = context.params.userId;

        console.log(`User ${userId} updated profile.`);
        console.log('Before:', before);
        console.log('After:', after);

        return null;
    });
