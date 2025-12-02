importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyCw8tM40-lGAF5uFZkGt4JHg05MN_IdQ6Q",
    authDomain: "vill-bazaar.firebaseapp.com",
    projectId: "vill-bazaar",
    storageBucket: "vill-bazaar.firebasestorage.app",
    messagingSenderId: "81470577520",
    appId: "1:81470577520:web:a2e56b44913adb0c350db5",
    measurementId: "G-CMWYW8SSSC"
});

const messaging = firebase.messaging();
