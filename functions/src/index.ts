import * as functions from "firebase-functions";
import * as firestore from "firebase-admin";
import { DocumentReference } from "firebase-admin/firestore";

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
        console.log("Old Count: " + oldCount);
        const newCount = oldCount;

        type Data = {
          id: number,
          rank: number,
        }
        const newData: Data = {
          id: Number(id),
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

        // Delete the document from the person"s jersey list
        await db.collection(who.toLowerCase()).doc(String(id)).delete();


        const patRank = db.collection("PatRank" + who).doc(String(id));
        const patDoc = await patRank.get();
        if (!patDoc.exists) {
          console.log("No such document!");
        } else {
          const removeRank = patDoc.data()!.rank
          console.log("Pat data:", removeRank);

          const bfrankcollection = db.collection("PatRank" + who);
          const snapshot = await bfrankcollection.get();
          if (snapshot.empty) {
            console.log("No matching documents for PatRank.");
            return;
          }  

          snapshot.forEach(doc => {
            const newRank = doc.data()!.rank
            if(newRank > removeRank)
            {
              updateRank(doc.ref, newRank - 1);
            }
          });

          await patDoc.ref.delete()
        }

        const brockRank = db.collection("BrockRank" + who).doc(String(id));
        const brockDoc = await brockRank.get();
        if (!brockDoc.exists) {
          console.log("No such document!");
        } else {
          const removeRank = brockDoc.data()!.rank
          console.log("Brock data:", removeRank);

          const bfrankcollection = db.collection("BrockRank" + who);
          const snapshot = await bfrankcollection.get();
          if (snapshot.empty) {
            console.log("No matching documents for BrockRank.");
            return;
          }  

          snapshot.forEach(doc => {
            const newRank = doc.data()!.rank
            if(newRank > removeRank)
            {
              updateRank(doc.ref, newRank - 1);
            }
          });

          await brockDoc.ref.delete()
        }

        const brianRank = db.collection("BrianRank" + who).doc(String(id));
        const brianDoc = await brianRank.get();
        if (!brianDoc.exists) {
          console.log("No such document!");
        } else {
          const removeRank = brianDoc.data()!.rank
          console.log("Brian data:", removeRank);

          const bfrankcollection = db.collection("BrianRank" + who);
          const snapshot = await bfrankcollection.get();
          if (snapshot.empty) {
            console.log("No matching documents for BrianRank.");
            return;
          }  

          snapshot.forEach(doc => {
            const newRank = doc.data()!.rank
            if(newRank > removeRank)
            {
              updateRank(doc.ref, newRank - 1);
            }
          });

          await brianDoc.ref.delete()
        }

        response.send("All Good!");
      } else {
        console.log("Invalid Parameters");
        response.status(500).send("Invalid Parameters");
      }
    });

async function updateRank(doc: DocumentReference, newRank: number) {
  await doc.update({rank: newRank})
}
