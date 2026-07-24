const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

exports.sendEventNotification = onDocumentCreated(
    "events/{eventId}",
    async (event) => {
      const eventData = event.data.data();

      const usersSnapshot = await admin.firestore()
          .collection("users")
          .get();

      const tokens = [];

      usersSnapshot.forEach((doc) => {
        const token = doc.data().fcmToken;

        if (token) {
          tokens.push(token);
        }
      });

      if (tokens.length === 0) {
        console.log("No FCM tokens found");
        return;
      }

      const message = {
        notification: {
          title: "📢 New Tina Mart Event",
          body: eventData.title,
        },
        tokens: tokens,
      };

      const response =
      await admin.messaging().sendEachForMulticast(message);

      console.log(
          "Notifications sent:",
          response.successCount,
      );
    },
);
