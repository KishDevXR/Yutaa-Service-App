const mongoose = require('mongoose');

async function deleteAllUsers() {
    try {
        await mongoose.connect('mongodb://127.0.0.1:27017/yutaa_service_app');
        console.log('Connected to MongoDB');

        const result = await mongoose.connection.db.collection('users').deleteMany({});
        console.log(`Deleted ${result.deletedCount} users`);

        await mongoose.connection.close();
        console.log('Done!');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

deleteAllUsers();
