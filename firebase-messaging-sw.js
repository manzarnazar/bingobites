importScripts('https://www.gstatic.com/firebasejs/8.3.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.3.2/firebase-messaging.js');

firebase.initializeApp({
    apiKey: "AIzaSyCwE5GOeg4TUEsRt7wGOROakdcBm5lo24o",
    authDomain: "bingo-bites.firebaseapp.com",
    projectId: "bingo-bites",
    storageBucket: "bingo-bites.firebasestorage.app",
    messagingSenderId: "996869641828",
    appId: "1:996869641828:web:701835d34e6caade537171",
    measurementId: "G-15JLXZ8JS5"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    return self.registration.showNotification(payload.data.title, {
        body: payload.data.body ? payload.data.body : '',
        icon: payload.data.icon ? payload.data.icon : ''
    });
});