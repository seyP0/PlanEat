import * as functions from 'firebase-functions';

export const createUser = functions.https.onRequest((req, res) => {
    const email = req.body.email;
    const name = req.body.name;

    if (!email || !name) {
        res.status(400).send({ error: 'Missing email or name' });
        return;
    }

    res.status(200).send({ message: `User ${name} with email ${email} created.` });
});
