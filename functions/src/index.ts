import * as functions from "firebase-functions";
import * as firestore from "firebase-admin";

firestore.initializeApp();


// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//

export const jerseyAdded =
    functions.https.onRequest(async (request, response) => {
      const id = request.query.id as string;
      const who: string = request.query.who as string;

      if ((id != null) && (who != null) && (id != "") && (who != "")) {
        const snapshot = await firestore.firestore()
          .collection(who.toLowerCase())
          .count().get();

        const oldCount = snapshot.data().count;
        const newCount = oldCount + 1;

        const newData = {
          id: id,
          rank: newCount,
        };

        const res1 = await firestore.firestore().collection("PatRank" + who)
          .doc(String(id)).set(newData);

        console.log("Pat Rank resp: " + res1);

        const res2 = await firestore.firestore().collection("BrockRank" + who)
          .doc(String(id)).set(newData);

        console.log("Brock Rank resp: " + res2);

        const res3 = await firestore.firestore().collection("BrianRank" + who)
          .doc(String(id)).set(newData);

        console.log("Briank Rank resp: " + res3);
        response.send("All Good!");
      } else {
        console.log("Invalid Parameters");
        response.status(500).send("Invalid Parameters");
      }
    });

