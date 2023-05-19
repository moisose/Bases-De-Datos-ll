// Import the functions you need from the SDKs you need
import firebase from "firebase/compat/app";
import "firebase/compat/auth";

import * as Constants from "./constants";

export const firebaseProperties = firebase.initializeApp({
  apiKey: Constants.apiKey,
  authDomain: Constants.authDomain,
  databaseURL: Constants.databaseURL,
  projectId: Constants.projectId,
  storageBucket: Constants.storageBucket,
  messagingSenderId: Constants.messagingSenderId,
  appId: Constants.appId,
  measurementId: Constants.measurementId,
});
