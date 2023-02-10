const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();

var db = admin.firestore();



exports.senddevices = functions.firestore
  .document("NOTIFICATION/{id}")
  .onCreate((snapshot) => {
    const TEXT = snapshot.get("TEXT");
    const SUBJECT = snapshot.get("SUBJECT");
    const TOKEN = snapshot.get("TOKEN");
const payload = {
      notification: {
        title: SUBJECT,
        body: "msg: " + TEXT,
        sound: "default",
      },
    };

    return fcm.sendToDevice(TOKEN, payload);
  });


exports.sendToTopic = functions.firestore
  .document("NOTIFIER/{id}")
  .onCreate(async(snapshot) => {



//const name=snapshot.get("NAME");

 const Batch = snapshot.get("TOPIC");
 const SUB=snapshot.get("SUB");
 const MSG=snapshot.get("MSG");
 const IMAGE=snapshot.get("IMAGE");
//console.log(Topic === "Nokia")
 if(Batch === "2019BCA"){
   var topics=[];
   var col = await db.collection('TOKEN_REC').doc('BCA').collection('2019BCA').get();
   col.forEach((doc)=>{
   topics.push(doc.id);
   })
   console.log(topics)
   const payload = {
       notification: {
         title: "Subject: "+SUB,
         body: "Msg: "+MSG,
         image: IMAGE,
         sound: "default",
       },
     };
 return fcm.sendToDevice(topics, payload);
 }



  });
//    exports.sentToAll = functions.https.onCall(async (data,context) => {
//
////          var auth = context.auth;
//  var tokens = await admin.firestore().collection("NOTIFIER").doc(data.BATCH).collection("NOTILIST").get();
//
//
//   for(var i in tokens){
//        const payload = {
//          notification: {
//            title: "hello",
//            body: "Yor product has been ",
//            sound: "default",
//          },
//
//
//  });

