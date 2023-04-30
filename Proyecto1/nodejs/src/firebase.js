// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
export const firebaseConfig = {
  apiKey: "AIzaSyBMEKpHHGlKGXKYXAZGP74Sc3y9_wAvv1s",
  authDomain: "proyecto1bd-678f1.firebaseapp.com",
  databaseURL: "https://proyecto1bd-678f1-default-rtdb.firebaseio.com",
  projectId: "proyecto1bd-678f1",
  storageBucket: "proyecto1bd-678f1.appspot.com",
  messagingSenderId: "38043828434",
  appId: "1:38043828434:web:7b146c27db19c60f4aad0b",
  measurementId: "G-WNS4LENGWE",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// Initialize Firebase Authentication and get a reference to the service
export const auth = getAuth(app);
