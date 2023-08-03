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

export const jerseyDelete =
    functions.https.onRequest(async (request, response) => {
      const id = request.query.id as string;
      const who: string = request.query.who as string;

      if ((id != null) && (who != null) && (id != "") && (who != "")) {
        const db = firestore.firestore();
        const snapshot = await db
          .collection(who.toLowerCase())
          .count().get();

        // Delete the document from the person"s jersey list
        //const res = await db.collection(who.toLowerCase()).document(String(id)).delete();


        const patRank = db.collection("PatRank" + who).doc(String(id));
        const patDoc = await patRank.get();
        if (!patDoc.exists) {
          console.log("No such document!");
        } else {
          console.log("Pat data:", patDoc.data["rank"]);
        }

        const brockRank = db.collection("BrockRank" + who).doc(String(id));
        const brockDoc = await brockRank.get();
        if (!brockDoc.exists) {
          console.log("No such document!");
        } else {
          console.log("Brock data:", brockDoc.data["rank"]);
        }

        const brianRank = db.collection("BrianRank" + who).doc(String(id));
        const brianDoc = await brianRank.get();
        if (!brianDoc.exists) {
          console.log("No such document!");
        } else {
          console.log("Brian data:", brianDoc.data["rank"]);

          const bfrankcollection = db.collection("BrianRank" + who);
          const snapshot = await bfrankcollection.get();
          if (snapshot.empty) {
            console.log("No matching documents for BrianRank.");
            return;
          }  

          snapshot.forEach(doc => {
            console.log(doc.rank);
          });
        }

 

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

